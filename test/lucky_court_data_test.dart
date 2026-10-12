import 'dart:async';
import 'dart:math';
import 'dart:typed_data';
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:food_jury/core/env/env.dart';
import 'package:food_jury/core/providers/ai_service_provider.dart';
import 'package:food_jury/core/services/ai_service.dart';
import 'package:food_jury/data/database/app_database.dart';
import 'package:food_jury/data/providers/database_provider.dart';
import 'package:food_jury/features/decision/data/models/food_option.dart';
import 'package:food_jury/features/decision/data/models/objective.dart';
import 'package:food_jury/features/decision/data/models/verdict.dart';
import 'package:food_jury/features/lucky/data/court_providers.dart';
import 'package:food_jury/features/lucky/data/decision_case.dart';

class IndexRandom implements Random {
  IndexRandom(this.index);
  final int index;
  @override
  int nextInt(int max) => index % max;
  @override
  bool nextBool() => true;
  @override
  double nextDouble() => .5;
}

DecisionCase makeCase([int count = 3]) => DecisionCase(
  options: List.generate(
    count,
    (i) => FoodOption(
      id: 'option-$i',
      name: 'Dish $i',
      illustrationId: 'category-seafood',
      notes: 'Exact dish details $i',
    ),
  ),
  objective: Objective.healthy,
);
Verdict aiVerdict(String id, {DecisionCase? caseData}) {
  final c = caseData ?? makeCase();
  return Verdict(
    id: id,
    winner: c.options.first,
    rankings: c.options,
    contenders: c.options,
    reasoning: 'Based on your stated goal.',
    objective: c.objective,
    judgeTone: JudgeTone.stern,
    createdAt: DateTime(2026, 10, 11),
  );
}

class ImmediateAi implements AiService {
  int calls = 0;
  bool invalid = false;
  Completer<void>? gate;
  @override
  Future<Verdict> generateVerdict({
    required List<FoodOption> options,
    required Objective objective,
    required JudgeTone tone,
    required Locale locale,
  }) async {
    calls++;
    if (gate != null) await gate!.future;
    final c = DecisionCase(options: options, objective: objective);
    return aiVerdict(
      'service-id',
      caseData: c,
    ).copyWith(rankings: invalid ? [options.first, options.first] : options);
  }
}

class FailOnceDatabase extends AppDatabase {
  FailOnceDatabase() : super.forTesting(NativeDatabase.memory());
  bool fail = true;
  @override
  Future<void> saveVerdict(Verdict verdict) async {
    if (fail) {
      fail = false;
      throw StateError('Simulated disk failure');
    }
    return super.saveVerdict(verdict);
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setUp(() {
    SharedPreferences.setMockInitialValues({});
    Env.current = Environment.dev;
  });

  test(
    'case snapshot protects original order, details, artwork and photo bytes',
    () {
      final photo = Uint8List.fromList([1, 2, 3]);
      final options = [
        FoodOption(
          id: 'fish',
          name: 'Uncommon fish',
          notes: 'Grilled whole',
          illustrationId: 'category-seafood',
          imageBytes: photo,
        ),
        const FoodOption(id: 'soup', name: 'Soup'),
      ];
      final c = DecisionCase(options: options, objective: Objective.quick);
      photo[0] = 9;
      options.clear();
      expect(c.options.first.imageBytes, [1, 2, 3]);
      expect(c.options.first.illustrationId, 'category-seafood');
      expect(() => c.options.clear(), throwsUnsupportedError);
      expect(() => c.options.first.imageBytes![0] = 5, throwsUnsupportedError);
    },
  );

  test('case validates 2–5 distinct named contenders', () {
    for (final count in [0, 1, 6]) {
      expect(() => makeCase(count), throwsArgumentError);
    }
    expect(
      () => DecisionCase(
        options: const [
          FoodOption(id: 'a', name: 'a'),
          FoodOption(id: 'a', name: 'b'),
        ],
        objective: Objective.fun,
      ),
      throwsArgumentError,
    );
  });

  for (final count in [2, 3, 4, 5]) {
    for (final method in RandomMethod.values.where(
      (m) => m != RandomMethod.coin || count == 2,
    )) {
      test(
        '${method.name}: every one of $count indices maps to its original contender',
        () async {
          for (var index = 0; index < count; index++) {
            final verdict = await LuckyCourt(random: IndexRandom(index)).draw(
              caseData: makeCase(count),
              method: method,
              tone: JudgeTone.stern,
              locale: const Locale('en'),
            );
            expect(verdict.winner.id, 'option-$index');
            expect(verdict.rankings, isEmpty);
            expect(verdict.reasoning, isEmpty);
            expect(
              verdict.caseOptions.map((o) => o.id),
              List.generate(count, (i) => 'option-$i'),
            );
            expect(verdict.random!.method, method);
          }
        },
      );
    }
  }

  test('coin never silently drops extra contenders', () async {
    expect(
      () => LuckyCourt().draw(
        caseData: makeCase(),
        method: RandomMethod.coin,
        tone: JudgeTone.chill,
        locale: const Locale('en'),
      ),
      throwsArgumentError,
    );
  });

  test(
    'quote bag does not repeat within a cycle or at a persisted cycle boundary',
    () async {
      final ids = <String>[];
      for (var i = 0; i < 23; i++) {
        final result = await LuckyCourt(random: Random(i)).draw(
          caseData: makeCase(),
          method: RandomMethod.ticket,
          tone: JudgeTone.sassy,
          locale: const Locale('es'),
        );
        ids.add(result.random!.quoteId);
        expect(result.random!.locale, 'es');
        expect(result.random!.quote, isNotEmpty);
      }
      expect(ids.take(11).toSet().length, 11);
      expect(ids.skip(11).take(11).toSet().length, 11);
      expect(ids[10], isNot(ids[11]));
      expect(ids[21], isNot(ids[22]));
    },
  );

  test(
    'fresh draws receive new immutable IDs even when the same dish wins',
    () async {
      final court = LuckyCourt(random: IndexRandom(1));
      Future<Verdict> draw() => court.draw(
        caseData: makeCase(),
        method: RandomMethod.cloche,
        tone: JudgeTone.stern,
        locale: const Locale('en'),
      );
      final a = await draw(), b = await draw();
      expect(a.id, isNot(b.id));
      expect(a.winner, b.winner);
      expect(a.random!.quoteId, isNot(b.random!.quoteId));
    },
  );

  test(
    'three successful AI saves, duplicate retry, deletion and exhaustion',
    () async {
      final db = AppDatabase.forTesting(NativeDatabase.memory());
      addTearDown(db.close);
      expect(await db.remainingAiDecisions(), 3);
      for (var i = 0; i < 3; i++) {
        await db.saveAiVerdict(aiVerdict('ai-$i'));
      }
      await db.saveAiVerdict(aiVerdict('ai-0'));
      expect(await db.remainingAiDecisions(), 0);
      expect((await db.getAllVerdicts()).length, 3);
      await db.deleteAllVerdicts();
      expect(await db.remainingAiDecisions(), 0);
      await expectLater(
        db.saveAiVerdict(aiVerdict('fourth')),
        throwsA(isA<AiAllowanceExhausted>()),
      );
      expect(await db.getAllVerdicts(), isEmpty);
    },
  );

  test(
    'premium operations retain idempotency without spending unused free credits',
    () async {
      final db = AppDatabase.forTesting(NativeDatabase.memory());
      addTearDown(db.close);
      await db.saveAiVerdict(aiVerdict('free'));
      for (var i = 0; i < 4; i++) {
        await db.saveAiVerdict(aiVerdict('plus-$i'), premium: true);
      }
      expect(await db.remainingAiDecisions(), 2);
      await db.saveAiVerdict(aiVerdict('plus-0'), premium: false);
      expect(await db.remainingAiDecisions(), 2);
    },
  );

  test(
    'saved Lucky verdicts preserve photo, quote and artwork; conflicting IDs never overwrite',
    () async {
      final db = AppDatabase.forTesting(NativeDatabase.memory());
      addTearDown(db.close);
      final c = DecisionCase(
        options: [
          FoodOption(
            id: 'a',
            name: 'Rare fish',
            illustrationId: 'category-seafood',
            imageBytes: Uint8List.fromList([1, 2, 3]),
          ),
          const FoodOption(id: 'b', name: 'Pizza'),
        ],
        objective: Objective.fit,
      );
      final v = await LuckyCourt(random: IndexRandom(0)).draw(
        caseData: c,
        method: RandomMethod.wheel,
        tone: JudgeTone.chill,
        locale: const Locale('es'),
      );
      await db.saveVerdict(v);
      await db.saveVerdict(v.copyWith(winner: c.options.last));
      final saved = (await db.getVerdictById(v.id))!;
      expect(saved.winner.name, 'Rare fish');
      expect(saved.winner.imageBytes, [1, 2, 3]);
      expect(saved.winner.illustrationId, 'category-seafood');
      expect(saved.random, v.random);
      expect(saved.rankings, isEmpty);
      expect(saved.caseOptions, c.options);
      expect(await db.remainingAiDecisions(), 3);
      expect(() => saved.caseOptions.clear(), throwsUnsupportedError);
    },
  );

  test('v2 migration keeps history and counts existing AI decisions', () async {
    final db = AppDatabase.forTesting(
      NativeDatabase.memory(
        setup: (raw) {
          raw.execute(
            'CREATE TABLE verdicts (id TEXT NOT NULL PRIMARY KEY, winner_json TEXT NOT NULL, rankings_json TEXT NOT NULL, reasoning TEXT NOT NULL, objective TEXT NOT NULL, judge_tone TEXT NOT NULL, created_at INTEGER NOT NULL, bonus TEXT NULL, bonus_type TEXT NULL)',
          );
          const food =
              '{"id":"legacy-food","name":"Old pizza","notes":null,"imageBase64":null}';
          raw.execute(
            'INSERT INTO verdicts VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)',
            [
              'old',
              food,
              '[$food]',
              'Old reasoning',
              'fun',
              'stern',
              1,
              null,
              null,
            ],
          );
          raw.execute('PRAGMA user_version = 2');
        },
      ),
    );
    addTearDown(db.close);
    final old = (await db.getAllVerdicts()).single;
    expect(old.isRandom, false);
    expect(old.winner.name, 'Old pizza');
    expect(old.caseOptions.single.name, 'Old pizza');
    expect(await db.remainingAiDecisions(), 2);
    await db.deleteAllVerdicts();
    expect(await db.remainingAiDecisions(), 2);
  });

  test(
    'AI disk failure preserves result for retry and consumes exactly once',
    () async {
      final db = FailOnceDatabase(), ai = ImmediateAi();
      addTearDown(db.close);
      final container = ProviderContainer(
        overrides: [
          databaseProvider.overrideWithValue(db),
          aiServiceProvider.overrideWithValue(ai),
        ],
      );
      addTearDown(container.dispose);
      final attempt = AiAttempt(makeCase(), const Locale('en'));
      final court = container.read(aiCourtProvider);
      await expectLater(court.decide(attempt), throwsStateError);
      expect(ai.calls, 1);
      expect(await db.remainingAiDecisions(), 3);
      expect(await db.getAllVerdicts(), isEmpty);
      final result = await court.decide(attempt);
      expect(ai.calls, 1);
      expect(await db.remainingAiDecisions(), 2);
      expect(result.id, attempt.id);
      await court.decide(attempt);
      expect(ai.calls, 1);
      expect(await db.remainingAiDecisions(), 2);
    },
  );

  test('concurrent AI attempt cannot double generate or spend', () async {
    final db = AppDatabase.forTesting(NativeDatabase.memory()),
        ai = ImmediateAi()..gate = Completer<void>();
    addTearDown(db.close);
    final container = ProviderContainer(
      overrides: [
        databaseProvider.overrideWithValue(db),
        aiServiceProvider.overrideWithValue(ai),
      ],
    );
    addTearDown(container.dispose);
    final court = container.read(aiCourtProvider),
        attempt = AiAttempt(makeCase(), const Locale('en'));
    final first = court.decide(attempt);
    await expectLater(court.decide(attempt), throwsStateError);
    ai.gate!.complete();
    await first;
    expect(ai.calls, 1);
    expect(await db.remainingAiDecisions(), 2);
  });

  test('invalid AI rankings do not spend credits or save a verdict', () async {
    final db = AppDatabase.forTesting(NativeDatabase.memory()),
        ai = ImmediateAi()..invalid = true;
    addTearDown(db.close);
    final container = ProviderContainer(
      overrides: [
        databaseProvider.overrideWithValue(db),
        aiServiceProvider.overrideWithValue(ai),
      ],
    );
    addTearDown(container.dispose);
    await expectLater(
      container
          .read(aiCourtProvider)
          .decide(AiAttempt(makeCase(), const Locale('en'))),
      throwsA(isA<AiServiceException>()),
    );
    expect(await db.remainingAiDecisions(), 3);
    expect(await db.getAllVerdicts(), isEmpty);
  });
}
