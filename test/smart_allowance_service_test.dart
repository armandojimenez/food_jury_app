import 'dart:async';
import 'dart:convert';

import 'package:drift/native.dart';
import 'package:drift/drift.dart' show driftRuntimeOptions;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:food_jury/config/routes/app_router.dart';
import 'package:food_jury/core/env/env.dart';
import 'package:food_jury/core/providers/ai_service_provider.dart';
import 'package:food_jury/core/services/ai_service.dart';
import 'package:food_jury/core/services/smart_allowance_service.dart';
import 'package:food_jury/core/widgets/widgets.dart';
import 'package:food_jury/data/database/app_database.dart';
import 'package:food_jury/data/providers/database_provider.dart';
import 'package:food_jury/features/lucky/data/court_providers.dart';
import 'package:food_jury/features/lucky/presentation/lucky_verdict_screen.dart';
import 'package:food_jury/features/lucky/presentation/plus_preview_screen.dart';
import 'package:food_jury/features/decision/presentation/verdict_screen.dart';

import 'decision_flow_test.dart' show drain;
import 'lucky_court_data_test.dart'
    show aiVerdict, makeCase, ImmediateAi, FailOnceDatabase;
import 'lucky_court_ui_test.dart' show CountingCourt;
import 'support/diner_harness.dart';

class FaultAllowanceStore extends MemorySmartAllowanceStore {
  bool failRead = false;
  int? failWriteNumber;
  int? failWritesFrom;
  int writes = 0;
  @override
  Future<String?> read() async {
    if (failRead) throw StateError('Storage unavailable');
    return super.read();
  }

  @override
  Future<void> write(String value) async {
    writes++;
    if (writes == failWriteNumber ||
        (failWritesFrom != null && writes >= failWritesFrom!)) {
      throw StateError('Storage unavailable');
    }
    await super.write(value);
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setUpAll(() async {
    // Each database has its own in-memory executor; these tests intentionally
    // simulate reinstall/restart and two independent provider containers.
    driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;
    await loadDesignFonts();
  });
  tearDownAll(() => driftRuntimeOptions.dontWarnAboutMultipleDatabases = false);
  setUp(() {
    SharedPreferences.setMockInitialValues({});
    Env.current = Environment.dev;
  });

  AppDatabase database() {
    final db = AppDatabase.forTesting(NativeDatabase.memory());
    addTearDown(db.close);
    return db;
  }

  ProviderContainer courtContainer(
    AppDatabase db,
    SmartAllowanceStore store,
    ImmediateAi ai,
  ) {
    final container = ProviderContainer(
      overrides: [
        databaseProvider.overrideWithValue(db),
        smartAllowanceServiceProvider.overrideWithValue(
          SmartAllowanceService(store),
        ),
        aiServiceProvider.overrideWithValue(ai),
      ],
    );
    addTearDown(container.dispose);
    return container;
  }

  test(
    'random local identity survives service restart without dish data',
    () async {
      final store = MemorySmartAllowanceStore(), db = database();
      final first = await SmartAllowanceService(store).reconcile(db);
      expect(first.remaining, 3);
      expect(first.deviceId, isNotEmpty);
      await db.saveAiVerdict(aiVerdict('first'));
      final second = await SmartAllowanceService(store).reconcile(db);
      expect(second.deviceId, first.deviceId);
      expect(second.remaining, 2);
      final record = jsonDecode(store.value!) as Map;
      expect(
        record.keys,
        unorderedEquals(['version', 'deviceId', 'chargedOperations']),
      );
      expect(record['chargedOperations'], ['first']);
    },
  );

  test(
    'database loss retains exhaustion and never fabricates verdicts',
    () async {
      final store = MemorySmartAllowanceStore(), original = database();
      final service = SmartAllowanceService(store);
      for (var i = 0; i < 3; i++) {
        await original.saveAiVerdict(aiVerdict('used-$i'));
      }
      final before = await service.reconcile(original);
      await original.deleteAllVerdicts();
      final replacement = database();
      final restored = await SmartAllowanceService(
        store,
      ).reconcile(replacement);
      expect(restored.deviceId, before.deviceId);
      expect(restored.remaining, 0);
      expect(await replacement.remainingAiDecisions(), 0);
      expect(await replacement.getAllVerdicts(), isEmpty);
      var calls = 0;
      await expectLater(
        SmartAllowanceService(store).decide(
          replacement,
          operationId: 'fourth',
          premium: false,
          generate: () async {
            calls++;
            return aiVerdict('fourth');
          },
        ),
        throwsA(isA<AiAllowanceExhausted>()),
      );
      expect(calls, 0);
    },
  );

  test('missing mirror seeds from usage even after history deletion', () async {
    final store = MemorySmartAllowanceStore(), db = database();
    await db.saveAiVerdict(aiVerdict('used'));
    final service = SmartAllowanceService(store);
    expect((await service.reconcile(db)).remaining, 2);
    await db.deleteAllVerdicts();
    store.value = null;
    expect((await SmartAllowanceService(store).reconcile(db)).remaining, 2);
    expect(SmartAllowance.decode(store.value!).chargedOperations, {'used'});
  });

  test(
    'different stored operation IDs merge without refunding either use',
    () async {
      final store = MemorySmartAllowanceStore(),
          first = database(),
          second = database();
      await first.saveAiVerdict(aiVerdict('first'));
      final before = await SmartAllowanceService(store).reconcile(first);
      await second.saveAiVerdict(aiVerdict('second'));
      final combined = await SmartAllowanceService(store).reconcile(second);
      expect(combined.deviceId, before.deviceId);
      expect(combined.remaining, 1);
      expect(combined.chargedOperations, {'first', 'second'});
      expect(await second.chargedAiOperationIds(), {'first', 'second'});
      expect((await second.getAllVerdicts()).single.id, 'second');
    },
  );

  for (final raw in [
    '',
    '{broken',
    '{"version":2,"deviceId":"future","chargedOperations":[]}',
    '{"version":1,"deviceId":"bad","chargedOperations":[]}',
  ]) {
    test(
      'corrupt or unsupported persistent state fails closed / $raw',
      () async {
        final store = MemorySmartAllowanceStore()..value = raw;
        final db = database(), ai = ImmediateAi();
        final container = courtContainer(db, store, ai);
        await expectLater(
          container
              .read(aiCourtProvider)
              .decide(AiAttempt(makeCase(), const Locale('en'))),
          throwsA(isA<SmartAllowanceUnavailable>()),
        );
        expect(ai.calls, 0);
        expect(store.value, raw);
        expect(await db.remainingAiDecisions(), 3);
      },
    );
  }

  for (final read in [true, false]) {
    test('unavailable initial storage never calls AI / read=$read', () async {
      final store = FaultAllowanceStore()
        ..failRead = read
        ..failWriteNumber = read ? null : 1;
      final db = database(), ai = ImmediateAi();
      final container = courtContainer(db, store, ai);
      await expectLater(
        container
            .read(aiCourtProvider)
            .decide(AiAttempt(makeCase(), const Locale('en'))),
        throwsA(isA<SmartAllowanceUnavailable>()),
      );
      expect(ai.calls, 0);
      expect(await db.remainingAiDecisions(), 3);
      expect(await db.getAllVerdicts(), isEmpty);
    });
  }

  test(
    'post-commit mirror failure repairs saved operation without another generation',
    () async {
      final store = FaultAllowanceStore()..failWritesFrom = 2;
      final db = database(), ai = ImmediateAi();
      final first = courtContainer(db, store, ai);
      final attempt = AiAttempt(makeCase(), const Locale('en'));
      await expectLater(
        first.read(aiCourtProvider).decide(attempt),
        throwsA(isA<SmartAllowanceUnavailable>()),
      );
      expect(ai.calls, 1);
      expect(await db.remainingAiDecisions(), 2);
      expect((await db.getAllVerdicts()).single.id, attempt.id);
      expect(SmartAllowance.decode(store.value!).remaining, 3);
      store.failWritesFrom = null;
      final replacementAi = ImmediateAi();
      final restarted = courtContainer(db, store, replacementAi);
      final result = await restarted.read(aiCourtProvider).decide(attempt);
      expect(result.id, attempt.id);
      expect(replacementAi.calls, 0);
      expect(SmartAllowance.decode(store.value!).remaining, 2);
      await restarted.read(aiCourtProvider).decide(attempt);
      expect(await db.remainingAiDecisions(), 2);
      expect(await db.getAllVerdicts(), hasLength(1));
    },
  );

  test(
    'failed DB save is uncharged in both stores and retries cached result',
    () async {
      final db = FailOnceDatabase(), store = MemorySmartAllowanceStore();
      addTearDown(db.close);
      final ai = ImmediateAi();
      final container = courtContainer(db, store, ai);
      final attempt = AiAttempt(makeCase(), const Locale('en'));
      await expectLater(
        container.read(aiCourtProvider).decide(attempt),
        throwsStateError,
      );
      expect(SmartAllowance.decode(store.value!).remaining, 3);
      expect(await db.remainingAiDecisions(), 3);
      await container.read(aiCourtProvider).decide(attempt);
      expect(ai.calls, 1);
      expect(SmartAllowance.decode(store.value!).remaining, 2);
    },
  );

  test(
    'AI failure and invalid operation ID consume no persistent use',
    () async {
      final store = MemorySmartAllowanceStore(), db = database();
      final service = SmartAllowanceService(store);
      await expectLater(
        service.decide(
          db,
          operationId: 'failed',
          premium: false,
          generate: () => Future.error(const AiServiceException('Offline')),
        ),
        throwsA(isA<AiServiceException>()),
      );
      await expectLater(
        service.decide(
          db,
          operationId: 'correct',
          premium: false,
          generate: () async => aiVerdict('different'),
        ),
        throwsArgumentError,
      );
      expect(SmartAllowance.decode(store.value!).remaining, 3);
      expect(await db.remainingAiDecisions(), 3);
    },
  );

  test('two service instances serialize the last free decision', () async {
    final store = MemorySmartAllowanceStore(), a = database(), b = database();
    await a.saveAiVerdict(aiVerdict('first'));
    await a.saveAiVerdict(aiVerdict('second'));
    final gate = Completer<void>(), started = Completer<void>();
    var calls = 0;
    final first = SmartAllowanceService(store).decide(
      a,
      operationId: 'third',
      premium: false,
      generate: () async {
        calls++;
        started.complete();
        await gate.future;
        return aiVerdict('third');
      },
    );
    await started.future;
    final second = SmartAllowanceService(store).decide(
      b,
      operationId: 'fourth',
      premium: false,
      generate: () async {
        calls++;
        return aiVerdict('fourth');
      },
    );
    final rejected = expectLater(second, throwsA(isA<AiAllowanceExhausted>()));
    gate.complete();
    await first;
    await rejected;
    expect(calls, 1);
    expect(SmartAllowance.decode(store.value!).remaining, 0);
    expect(await b.getAllVerdicts(), isEmpty);
  });

  test(
    'verified premium has a stable identity and never spends remaining uses',
    () async {
      final store = FaultAllowanceStore();
      final db = database();
      final service = SmartAllowanceService(store);
      await service.decide(
        db,
        operationId: 'plus',
        premium: true,
        generate: () async {
          expect(
            service.deviceId,
            SmartAllowance.decode(store.value!).deviceId,
          );
          return aiVerdict('plus');
        },
      );
      expect(await db.remainingAiDecisions(), 3);
      expect(SmartAllowance.decode(store.value!).remaining, 3);
      expect(store.writes, 1);
    },
  );

  test(
    'preview databases automatically get isolated in-memory allowances',
    () async {
      final a = ProviderContainer(
        overrides: [databaseProvider.overrideWithValue(database())],
      );
      final b = ProviderContainer(
        overrides: [databaseProvider.overrideWithValue(database())],
      );
      addTearDown(a.dispose);
      addTearDown(b.dispose);
      expect(
        a.read(smartAllowanceServiceProvider).store,
        isA<MemorySmartAllowanceStore>(),
      );
      final first = await a
          .read(smartAllowanceServiceProvider)
          .reconcile(a.read(databaseProvider));
      final second = await b
          .read(smartAllowanceServiceProvider)
          .reconcile(b.read(databaseProvider));
      expect(first.deviceId, isNot(second.deviceId));
      expect(second.remaining, 3);
    },
  );

  testWidgets(
    'last-use mirror failure retries the saved ruling at zero quota without reopening new AI use',
    (tester) async {
      final db = database();
      await tester.runAsync(() async {
        await db.saveAiVerdict(aiVerdict('used-1'));
        await db.saveAiVerdict(aiVerdict('used-2'));
      });
      final store = FaultAllowanceStore();
      final ai = ImmediateAi();
      final app = DinerHarness();
      await app.pump(
        tester,
        route: AppRouter.methods,
        extra: makeCase(),
        overrides: [
          databaseProvider.overrideWithValue(db),
          smartAllowanceServiceProvider.overrideWithValue(
            SmartAllowanceService(store),
          ),
          aiServiceProvider.overrideWithValue(ai),
        ],
      );
      expect(
        await tester.runAsync(
          () => app.container.read(aiAllowanceProvider.future),
        ),
        1,
      );
      // The next write mirrors the committed third use. Automatic allowance
      // refresh then repairs the mirror and observes zero remaining uses.
      store.failWriteNumber = store.writes + 1;
      final ask = find.byKey(const Key('ask-ai'));
      await scrollTo(tester, ask);
      await tester.tap(ask);
      await drain(tester);
      final confirm = find.widgetWithText(DinerButton, 'USE MY SMART RULING');
      await scrollTo(tester, confirm);
      await tester.tap(confirm);
      await drain(tester);
      await drain(tester);
      expect(ai.calls, 1);
      expect(find.byType(VerdictScreen), findsNothing);
      expect(
        await tester.runAsync(
          () => app.container.read(aiAllowanceProvider.future),
        ),
        0,
      );
      await tester.pumpAndSettle();
      final committed = (await tester.runAsync(
        db.getAllVerdicts,
      ))!.singleWhere((verdict) => !verdict.id.startsWith('used-'));
      expect(tester.widget<DinerButton>(ask).label, 'Retry');
      await scrollTo(tester, ask);
      await tester.tap(ask);
      for (
        var i = 0;
        i < 10 && find.byType(VerdictScreen).evaluate().isEmpty;
        i++
      ) {
        await drain(tester);
      }
      expect(find.byType(VerdictScreen), findsOneWidget);
      expect(
        tester.widget<VerdictScreen>(find.byType(VerdictScreen)).verdict.id,
        committed.id,
      );
      expect(ai.calls, 1);
      expect((await tester.runAsync(db.getAllVerdicts))!.length, 3);
      expect(await tester.runAsync(db.remainingAiDecisions), 0);
      // Once recovery succeeds, this screen has no retained attempt. Starting
      // another Smart ruling routes to the offer and never calls AI again.
      app.router.pop();
      await drain(tester);
      await scrollTo(tester, ask);
      expect(tester.widget<DinerButton>(ask).label, isNot('Retry'));
      await tester.tap(ask);
      await drain(tester);
      expect(find.byType(PlusPreviewScreen), findsOneWidget);
      expect(ai.calls, 1);
      expect(await tester.runAsync(db.remainingAiDecisions), 0);
      expect(tester.takeException(), isNull);
    },
  );

  for (final corrupt in [true, false]) {
    testWidgets(
      'unverified Smart allowance keeps Lucky available / corrupt=$corrupt',
      (tester) async {
        final store = FaultAllowanceStore()
          ..failRead = !corrupt
          ..value = corrupt ? '{broken' : null;
        final app = DinerHarness();
        final court = CountingCourt();
        await app.pump(
          tester,
          route: AppRouter.methods,
          extra: makeCase(),
          overrides: [
            smartAllowanceServiceProvider.overrideWithValue(
              SmartAllowanceService(store),
            ),
            luckyCourtProvider.overrideWithValue(court),
          ],
        );
        await tester.runAsync(
          () => expectLater(
            app.container.read(aiAllowanceProvider.future),
            throwsA(isA<SmartAllowanceUnavailable>()),
          ),
        );
        await tester.pumpAndSettle();
        expect(find.byKey(const Key('ask-ai')), findsNothing);
        expect(
          find.textContaining('allowance could not be verified'),
          findsOneWidget,
        );
        final lucky = find.byKey(const Key('start-lucky'));
        expect(tester.widget<DinerButton>(lucky).onPressed, isNotNull);
        expect(lucky.hitTestable(), findsOneWidget);
        await tester.tap(lucky);
        // Preference hydration and route changes complete asynchronously.
        for (
          var i = 0;
          i < 10 && find.byType(LuckyVerdictScreen).evaluate().isEmpty;
          i++
        ) {
          await drain(tester);
          await tester.pumpAndSettle();
        }
        expect(
          find.byType(LuckyVerdictScreen),
          findsOneWidget,
          reason:
              'Route: ${app.router.routeInformationProvider.value.uri}; '
              'draws: ${court.draws}',
        );
        expect(
          await tester.runAsync(
            app.container.read(databaseProvider).remainingAiDecisions,
          ),
          3,
        );
        expect(tester.takeException(), isNull);
      },
    );
  }
}
