import 'dart:io';
import 'dart:typed_data';

import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:food_jury/data/database/app_database.dart';
import 'package:food_jury/features/case_shelf/data/case_shelf_models.dart';
import 'package:food_jury/features/case_shelf/data/case_shelf_provider.dart';
import 'package:food_jury/features/decision/data/models/food_option.dart';
import 'package:food_jury/features/decision/data/models/objective.dart';
import 'package:food_jury/features/decision/data/models/verdict.dart';

const _tacos = FoodOption(id: 'tacos', name: 'Tacos', illustrationId: 'tacos');
const _salad = FoodOption(id: 'salad', name: 'Salad', illustrationId: 'salad');

Verdict _verdict(List<FoodOption> options) => Verdict(
  id: 'ruling',
  winner: options.first,
  rankings: options,
  contenders: options,
  reasoning: 'The quick option fits this case.',
  objective: Objective.quick,
  judgeTone: JudgeTone.stern,
  createdAt: DateTime(2026, 10, 12),
);

class _FailingDraftDatabase extends AppDatabase {
  _FailingDraftDatabase() : super.forTesting(NativeDatabase.memory());
  bool failNext = true;

  @override
  Future<void> saveCaseDraft(CaseDraft draft) async {
    if (failNext) {
      failNext = false;
      throw StateError('Simulated disk failure');
    }
    await super.saveCaseDraft(draft);
  }
}

void main() {
  test(
    'unfinished draft and named lineup survive reopen with all evidence',
    () async {
      final directory = await Directory.systemTemp.createTemp(
        'foodjury-shelf-',
      );
      addTearDown(() => directory.delete(recursive: true));
      final file = File('${directory.path}/cases.sqlite');
      final bytes = Uint8List.fromList([1, 2, 3, 4]);
      final draft = CaseDraft(
        options: [
          FoodOption(
            id: 'photo',
            name: 'Local special',
            notes: 'Ready in ten minutes',
            imageBytes: bytes,
            illustrationId: 'category-seafood',
          ),
          _tacos,
        ],
      );
      bytes[0] = 99;
      final original = AppDatabase.forTesting(NativeDatabase(file));
      await original.saveCaseDraft(draft);
      await original.saveCaseSet(
        SavedCaseSet(id: 'friday', name: 'Friday takeout', draft: draft),
      );
      await original.close();

      final reopened = AppDatabase.forTesting(NativeDatabase(file));
      addTearDown(reopened.close);
      final shelf = await reopened.watchCaseShelf().first;
      expect(shelf.draft!.objective, isNull);
      expect(shelf.draft!.options.first.imageBytes, [1, 2, 3, 4]);
      expect(shelf.draft!.options.first.notes, 'Ready in ten minutes');
      expect(shelf.draft!.options.first.illustrationId, 'category-seafood');
      expect(shelf.sets.single.name, 'Friday takeout');
      expect(shelf.sets.single.draft, shelf.draft);
      expect(() => shelf.draft!.options.clear(), throwsUnsupportedError);
      expect(
        () => shelf.draft!.options.first.imageBytes![0] = 42,
        throwsUnsupportedError,
      );
    },
  );

  test(
    'draft changes and discard are serialized even when not awaited individually',
    () async {
      final db = AppDatabase.forTesting(NativeDatabase.memory());
      addTearDown(db.close);
      final store = CaseShelfStore(db);
      await Future.wait([
        store.saveDraft(CaseDraft(options: [_tacos])),
        store.saveDraft(
          CaseDraft(options: [_tacos, _salad], objective: Objective.quick),
        ),
        store.discardDraft(),
      ]);
      expect((await db.watchCaseShelf().first).draft, isNull);
    },
  );

  test(
    'a failed draft write can be retried without poisoning later writes',
    () async {
      final db = _FailingDraftDatabase();
      addTearDown(db.close);
      final store = CaseShelfStore(db);
      final draft = CaseDraft(options: [_tacos]);
      await expectLater(store.saveDraft(draft), throwsStateError);
      await store.saveDraft(draft);
      expect((await db.watchCaseShelf().first).draft, draft);
    },
  );

  test(
    'only a matching saved verdict retires a draft; lineups remain independent',
    () async {
      final db = AppDatabase.forTesting(NativeDatabase.memory());
      addTearDown(db.close);
      final draft = CaseDraft(
        options: [_tacos, _salad],
        objective: Objective.quick,
      );
      await db.saveCaseDraft(CaseDraft(options: [_salad]));
      await db.saveVerdict(_verdict(draft.options));
      expect((await db.watchCaseShelf().first).draft!.options, [_salad]);
      await db.saveCaseDraft(draft);
      await db.saveCaseSet(
        SavedCaseSet(id: 'lunch', name: 'Lunch', draft: draft),
      );
      await db.saveAiVerdict(_verdict(draft.options).copyWith(id: 'matching'));
      final shelf = await db.watchCaseShelf().first;
      expect(shelf.draft, isNull);
      expect(shelf.sets.single.name, 'Lunch');
      expect(await db.remainingAiDecisions(), 2);
      await db.deleteAllVerdicts();
      expect((await db.watchCaseShelf().first).sets.single.draft, draft);
      expect(await db.remainingAiDecisions(), 2);
      await expectLater(db.deleteCaseSet('draft'), throwsArgumentError);
    },
  );

  test(
    'a separate preview database never reads or clears the real shelf',
    () async {
      final real = AppDatabase.forTesting(NativeDatabase.memory());
      final preview = AppDatabase.forTesting(NativeDatabase.memory());
      addTearDown(real.close);
      addTearDown(preview.close);
      await real.saveCaseDraft(CaseDraft(options: [_tacos]));
      expect((await preview.watchCaseShelf().first).draft, isNull);
      await preview.deleteCaseDraft();
      expect((await real.watchCaseShelf().first).draft!.options, [_tacos]);
    },
  );

  test(
    'version 3 migration adds the shelf without changing history or allowance',
    () async {
      final db = AppDatabase.forTesting(
        NativeDatabase.memory(
          setup: (raw) {
            raw.execute(
              'CREATE TABLE verdicts (id TEXT NOT NULL PRIMARY KEY, winner_json TEXT NOT NULL, rankings_json TEXT NOT NULL, reasoning TEXT NOT NULL, objective TEXT NOT NULL, judge_tone TEXT NOT NULL, created_at INTEGER NOT NULL, bonus TEXT NULL, bonus_type TEXT NULL, contenders_json TEXT NOT NULL DEFAULT \'[]\', random_json TEXT NULL)',
            );
            raw.execute(
              'CREATE TABLE ai_uses (operation_id TEXT NOT NULL PRIMARY KEY, charged_free INTEGER NOT NULL DEFAULT 1)',
            );
            const food =
                '{"id":"old-food","name":"Old pizza","notes":null,"imageBase64":null}';
            raw.execute(
              'INSERT INTO verdicts VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)',
              [
                'legacy',
                food,
                '[$food]',
                'Old reasoning',
                'fun',
                'stern',
                1,
                null,
                null,
                '[$food]',
                null,
              ],
            );
            raw.execute('INSERT INTO ai_uses (operation_id) VALUES (?)', [
              'legacy',
            ]);
            raw.execute('PRAGMA user_version = 3');
          },
        ),
      );
      addTearDown(db.close);
      await db.saveCaseDraft(CaseDraft(options: [_tacos]));
      expect((await db.getAllVerdicts()).single.winner.name, 'Old pizza');
      expect(await db.remainingAiDecisions(), 2);
      expect((await db.watchCaseShelf().first).draft!.options, [_tacos]);
    },
  );
}
