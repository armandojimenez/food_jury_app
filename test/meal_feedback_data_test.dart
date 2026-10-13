import 'dart:io';

import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:food_jury/data/database/app_database.dart';
import 'package:food_jury/features/decision/data/models/food_option.dart';
import 'package:food_jury/features/decision/data/models/objective.dart';
import 'package:food_jury/features/decision/data/models/verdict.dart';

const _food = FoodOption(id: 'tacos', name: 'Tacos', notes: 'Extra lime');
const _other = FoodOption(id: 'pizza', name: 'Pizza');

Verdict _case(String id) => Verdict(
  id: id,
  winner: _food,
  rankings: const [_food, _other],
  contenders: const [_food, _other],
  reasoning: 'A saved ruling stays exactly as it was.',
  objective: Objective.fun,
  judgeTone: JudgeTone.stern,
  createdAt: DateTime(2026, 10, 12),
);

void main() {
  test(
    'feedback requires a saved verdict and cannot resurrect a deleted case',
    () async {
      final db = AppDatabase.forTesting(NativeDatabase.memory());
      addTearDown(db.close);
      await expectLater(
        db.setMealFeedback('missing', ate: true, wouldAgain: true),
        throwsStateError,
      );
      expect(await db.getMealFeedback('missing'), isNull);
      await db.saveVerdict(_case('saved'));
      await db.setMealFeedback('saved', ate: true);
      expect((await db.getMealFeedback('saved'))!.ate, isTrue);
      await db.deleteVerdict('saved');
      await expectLater(
        db.setMealFeedback('saved', ate: true),
        throwsStateError,
      );
      expect(await db.getMealFeedback('saved'), isNull);
    },
  );

  test(
    'feedback persists across restart independently of immutable verdict and allowance',
    () async {
      final directory = await Directory.systemTemp.createTemp(
        'foodjury-feedback-',
      );
      addTearDown(() => directory.delete(recursive: true));
      final file = File('${directory.path}/cases.sqlite');
      final original = AppDatabase.forTesting(NativeDatabase(file));
      final verdict = _case('saved');
      await original.saveAiVerdict(verdict);
      await original.setMealFeedback('saved', ate: true, wouldAgain: true);
      await original.close();

      final reopened = AppDatabase.forTesting(NativeDatabase(file));
      addTearDown(reopened.close);
      final feedback = await reopened.getMealFeedback('saved');
      expect(feedback!.ate, isTrue);
      expect(feedback.wouldAgain, isTrue);
      expect(await reopened.getVerdictById('saved'), verdict);
      expect(await reopened.remainingAiDecisions(), 2);
      expect(
        (await reopened.watchAllMealFeedback().first).single.verdictId,
        'saved',
      );
      expect(await reopened.watchMealFeedback('saved').first, feedback);
    },
  );

  test(
    'answers can change or clear without retaining an incompatible rating',
    () async {
      final db = AppDatabase.forTesting(NativeDatabase.memory());
      addTearDown(db.close);
      await db.saveAiVerdict(_case('saved'));
      await db.setMealFeedback('saved', ate: true, wouldAgain: true);
      await db.setMealFeedback('saved', ate: true, wouldAgain: false);
      expect((await db.getMealFeedback('saved'))!.wouldAgain, isFalse);
      await db.setMealFeedback('saved', ate: false, wouldAgain: true);
      final corrected = await db.getMealFeedback('saved');
      expect(corrected!.ate, isFalse);
      expect(corrected.wouldAgain, isNull);
      await db.deleteMealFeedback('saved');
      expect(await db.getMealFeedback('saved'), isNull);
      expect(await db.getVerdictById('saved'), _case('saved'));
      expect(await db.remainingAiDecisions(), 2);
    },
  );

  test(
    'case deletion and feedback cleanup roll back together on a failed deletion',
    () async {
      final db = AppDatabase.forTesting(NativeDatabase.memory());
      addTearDown(db.close);
      await db.saveAiVerdict(_case('first'));
      await db.saveAiVerdict(_case('second'));
      await db.setMealFeedback('first', ate: true, wouldAgain: true);
      await db.setMealFeedback('second', ate: true);
      await db.customStatement(
        "CREATE TRIGGER refuse_delete BEFORE DELETE ON verdicts BEGIN SELECT RAISE(ABORT, 'Simulated delete failure'); END",
      );
      await expectLater(db.deleteVerdict('first'), throwsA(isA<Exception>()));
      expect(await db.getVerdictById('first'), isNotNull);
      expect(await db.getMealFeedback('first'), isNotNull);
      await db.customStatement('DROP TRIGGER refuse_delete');
      await db.deleteVerdict('first');
      expect(await db.getMealFeedback('first'), isNull);
      expect(await db.getMealFeedback('second'), isNotNull);
      await db.deleteAllVerdicts();
      expect(await db.watchAllMealFeedback().first, isEmpty);
      expect(await db.getAllVerdicts(), isEmpty);
      expect(await db.remainingAiDecisions(), 1);
    },
  );

  for (final version in [2, 3]) {
    test(
      'version $version migration adds feedback while retaining history and consumed uses',
      () async {
        final db = AppDatabase.forTesting(
          NativeDatabase.memory(
            setup: (raw) {
              final extra = version >= 3
                  ? ", contenders_json TEXT NOT NULL DEFAULT '[]', random_json TEXT NULL"
                  : '';
              raw.execute(
                'CREATE TABLE verdicts (id TEXT NOT NULL PRIMARY KEY, winner_json TEXT NOT NULL, rankings_json TEXT NOT NULL, reasoning TEXT NOT NULL, objective TEXT NOT NULL, judge_tone TEXT NOT NULL, created_at INTEGER NOT NULL, bonus TEXT NULL, bonus_type TEXT NULL$extra)',
              );
              const food =
                  '{"id":"legacy-food","name":"Old pizza","notes":null,"imageBase64":null}';
              raw.execute(
                'INSERT INTO verdicts (id, winner_json, rankings_json, reasoning, objective, judge_tone, created_at) VALUES (?, ?, ?, ?, ?, ?, ?)',
                [
                  'legacy',
                  food,
                  '[$food]',
                  'Original ruling',
                  'fun',
                  'stern',
                  1,
                ],
              );
              if (version >= 3) {
                raw.execute(
                  'CREATE TABLE ai_uses (operation_id TEXT NOT NULL PRIMARY KEY, charged_free INTEGER NOT NULL DEFAULT 1)',
                );
                raw.execute('INSERT INTO ai_uses (operation_id) VALUES (?)', [
                  'legacy',
                ]);
              }
              raw.execute('PRAGMA user_version = $version');
            },
          ),
        );
        addTearDown(db.close);
        await db.setMealFeedback('legacy', ate: true, wouldAgain: true);
        expect((await db.getMealFeedback('legacy'))!.wouldAgain, isTrue);
        expect(
          (await db.getVerdictById('legacy'))!.reasoning,
          'Original ruling',
        );
        expect(await db.remainingAiDecisions(), 2);
        expect((await db.watchCaseShelf().first).sets, isEmpty);
      },
    );
  }
}
