import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:food_jury/data/database/app_database.dart';
import 'package:food_jury/features/decision/data/models/food_option.dart';
import 'package:food_jury/features/decision/data/models/objective.dart';
import 'package:food_jury/features/decision/data/models/verdict.dart';

Verdict _ruling(String id) => Verdict(
  id: id,
  winner: const FoodOption(id: 'tacos', name: 'Tacos'),
  rankings: const [
    FoodOption(id: 'tacos', name: 'Tacos'),
    FoodOption(id: 'pizza', name: 'Pizza'),
  ],
  reasoning: 'Tacos fit the stated goal.',
  objective: Objective.fun,
  judgeTone: JudgeTone.chill,
  createdAt: DateTime(2026, 10, 13),
);

void main() {
  test(
    'only charged trial IDs are exported, independently of history',
    () async {
      final db = AppDatabase.forTesting(NativeDatabase.memory());
      addTearDown(db.close);
      await db.saveAiVerdict(_ruling('trial'));
      await db.saveAiVerdict(_ruling('premium'), premium: true);
      final ids = await db.chargedAiOperationIds();
      expect(ids, {'trial'});
      expect(() => ids.add('not-allowed'), throwsUnsupportedError);
      await db.deleteAllVerdicts();
      expect(await db.chargedAiOperationIds(), {'trial'});
      expect(await db.remainingAiDecisions(), 2);
    },
  );

  test(
    'recovery is monotonic and idempotent without modifying premium or verdicts',
    () async {
      final db = AppDatabase.forTesting(NativeDatabase.memory());
      addTearDown(db.close);
      await db.saveAiVerdict(_ruling('local'));
      await db.saveAiVerdict(_ruling('premium'), premium: true);
      final before = await db.getAllVerdicts();
      await db.restoreChargedAiOperations({'restored', 'local', 'premium'});
      await db.restoreChargedAiOperations({'restored'});
      await db.restoreChargedAiOperations({});
      expect(await db.chargedAiOperationIds(), {'local', 'restored'});
      expect(await db.remainingAiDecisions(), 1);
      expect(await db.getAllVerdicts(), before);
      expect(await db.getVerdictById('restored'), isNull);
      await db.deleteVerdict('local');
      await db.restoreChargedAiOperations({'restored'});
      expect(await db.chargedAiOperationIds(), {'local', 'restored'});
      expect(await db.remainingAiDecisions(), 1);
    },
  );

  test(
    'recovered usage enforces the existing allowance before a new save',
    () async {
      final db = AppDatabase.forTesting(NativeDatabase.memory());
      addTearDown(db.close);
      await db.restoreChargedAiOperations({'one', 'two', 'three', 'four'});
      expect(await db.remainingAiDecisions(), 0);
      await expectLater(
        db.saveAiVerdict(_ruling('another-trial')),
        throwsA(isA<AiAllowanceExhausted>()),
      );
      expect(await db.getAllVerdicts(), isEmpty);
      await db.saveAiVerdict(_ruling('paid'), premium: true);
      expect((await db.getAllVerdicts()).single.id, 'paid');
      expect(await db.chargedAiOperationIds(), {'one', 'two', 'three', 'four'});
    },
  );

  test(
    'failed recovery rolls back the complete import and can retry',
    () async {
      final db = AppDatabase.forTesting(NativeDatabase.memory());
      addTearDown(db.close);
      await db.restoreChargedAiOperations({'existing'});
      await db.customStatement('''
      CREATE TRIGGER fail_recovered_use BEFORE INSERT ON ai_uses
      WHEN NEW.operation_id = 'fail'
      BEGIN SELECT RAISE(ABORT, 'Simulated storage failure'); END
    ''');
      await expectLater(
        db.restoreChargedAiOperations({'before-failure', 'fail'}),
        throwsA(isA<Exception>()),
      );
      expect(await db.chargedAiOperationIds(), {'existing'});
      expect(await db.remainingAiDecisions(), 2);
      await db.customStatement('DROP TRIGGER fail_recovered_use');
      await db.restoreChargedAiOperations({'before-failure', 'fail'});
      expect(await db.chargedAiOperationIds(), {
        'existing',
        'before-failure',
        'fail',
      });
    },
  );

  test(
    'preview and test database constructors isolate platform usage storage',
    () async {
      final isolated = AppDatabase.forTesting(NativeDatabase.memory());
      expect(isolated.usesEphemeralStorage, isTrue);
      await isolated.close();
      final device = AppDatabase();
      addTearDown(device.close);
      expect(device.usesEphemeralStorage, isFalse);
    },
  );
}
