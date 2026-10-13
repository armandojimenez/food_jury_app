import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:food_jury/config/routes/app_router.dart';
import 'package:food_jury/core/providers/ai_consent_provider.dart';
import 'package:food_jury/core/providers/ai_service_provider.dart';
import 'package:food_jury/core/services/ai_gateway_service.dart';
import 'package:food_jury/core/services/ai_service.dart';
import 'package:food_jury/data/providers/database_provider.dart';
import 'package:food_jury/features/decision/data/models/food_option.dart';
import 'package:food_jury/features/decision/data/models/objective.dart';
import 'package:food_jury/features/decision/data/models/verdict.dart';
import 'package:food_jury/features/decision/presentation/verdict_screen.dart';
import 'package:food_jury/features/lucky/data/decision_case.dart';
import 'package:food_jury/features/lucky/presentation/lucky_verdict_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'support/diner_harness.dart';

class _PermissionStore implements AiConsentStore {
  String? value;
  bool failWrite = false, failRead = false;
  Completer<void>? gate;
  @override
  Future<String?> read() async {
    if (failRead) throw StateError('Read failed');
    return value;
  }

  @override
  Future<void> write(String? version) async {
    if (gate != null) await gate!.future;
    if (failWrite) throw StateError('Write failed');
    value = version;
  }
}

class _ConsentAi implements AiService {
  int calls = 0;
  bool outdated = false;
  @override
  Future<Verdict> generateVerdict({
    required List<FoodOption> options,
    required Objective objective,
    required JudgeTone tone,
    required Locale locale,
  }) async {
    calls++;
    if (outdated) {
      throw const AiGatewayException(
        AiGatewayError.consentOutdated,
        'A newer disclosure is required',
        statusCode: 412,
      );
    }
    return sampleVerdict.copyWith(
      winner: options.first,
      rankings: options,
      contenders: options,
      objective: objective,
      judgeTone: tone,
    );
  }
}

Future<void> _settle(WidgetTester tester) async {
  await tester.runAsync(
    () => Future<void>.delayed(const Duration(milliseconds: 80)),
  );
  await tester.pumpAndSettle();
}

Future<void> _tap(WidgetTester tester, String key) async {
  final target = find.byKey(Key(key));
  await scrollTo(tester, target);
  await tester.tap(target);
  await _settle(tester);
}

final _case = DecisionCase(
  options: const [pizza, taco],
  objective: Objective.quick,
);

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setUpAll(loadDesignFonts);

  test(
    'permission requires the current version and persists accept/revoke',
    () async {
      SharedPreferences.setMockInitialValues({
        aiConsentPreferenceKey: 'older-policy',
      });
      final container = ProviderContainer();
      final notifier = container.read(aiConsentProvider.notifier);
      expect(await notifier.acceptedVersion(), isNull);
      await notifier.accept();
      expect(await notifier.acceptedVersion(), aiConsentVersion);
      container.dispose();
      final restarted = ProviderContainer();
      addTearDown(restarted.dispose);
      final reloaded = restarted.read(aiConsentProvider.notifier);
      expect(await reloaded.acceptedVersion(), aiConsentVersion);
      await reloaded.revoke();
      expect(await reloaded.acceptedVersion(), isNull);
      expect(
        (await SharedPreferences.getInstance()).getString(
          aiConsentPreferenceKey,
        ),
        isNull,
      );
    },
  );

  test(
    'unavailable storage never implies permission and explicit retry recovers',
    () async {
      final store = _PermissionStore()..failRead = true;
      final container = ProviderContainer(
        overrides: [aiConsentStoreProvider.overrideWithValue(store)],
      );
      addTearDown(container.dispose);
      final notifier = container.read(aiConsentProvider.notifier);
      await expectLater(notifier.acceptedVersion(), throwsStateError);
      store.failWrite = true;
      await expectLater(notifier.accept(), throwsStateError);
      await expectLater(notifier.acceptedVersion(), throwsStateError);
      store.failWrite = false;
      await notifier.accept();
      expect(await notifier.acceptedVersion(), aiConsentVersion);
      store.failWrite = true;
      await expectLater(notifier.revoke(), throwsStateError);
      expect(container.read(aiConsentProvider), isNull);
      await expectLater(notifier.acceptedVersion(), throwsStateError);
    },
  );

  test(
    'a request waits for pending consent edits and cannot bypass revoke',
    () async {
      final store = _PermissionStore();
      final container = ProviderContainer(
        overrides: [aiConsentStoreProvider.overrideWithValue(store)],
      );
      addTearDown(container.dispose);
      final notifier = container.read(aiConsentProvider.notifier);
      await notifier.ready;
      store.gate = Completer<void>();
      final accept = notifier.accept();
      var readFinished = false;
      final read = notifier.acceptedVersion().then((value) {
        readFinished = true;
        return value;
      });
      await Future<void>.delayed(Duration.zero);
      expect(readFinished, isFalse);
      // A revoke queued after the request starts waiting must still take effect.
      final revoke = notifier.revoke();
      store.gate!.complete();
      await Future.wait([accept, revoke]);
      expect(await read, isNull);
      expect(store.value, isNull);
    },
  );

  test(
    'preview consent never reads or writes the normal app permission',
    () async {
      SharedPreferences.setMockInitialValues({
        aiConsentPreferenceKey: aiConsentVersion,
      });
      final normal = ProviderContainer();
      final preview = ProviderContainer(
        overrides: [
          aiConsentStoreProvider.overrideWithValue(MemoryAiConsentStore()),
        ],
      );
      addTearDown(normal.dispose);
      addTearDown(preview.dispose);
      final realPermission = normal.read(aiConsentProvider.notifier);
      final previewPermission = preview.read(aiConsentProvider.notifier);
      expect(await realPermission.acceptedVersion(), aiConsentVersion);
      expect(await previewPermission.acceptedVersion(), isNull);
      await previewPermission.revoke();
      expect(
        (await SharedPreferences.getInstance()).getString(
          aiConsentPreferenceKey,
        ),
        aiConsentVersion,
      );
      await realPermission.revoke();
      await previewPermission.accept();
      expect(await previewPermission.acceptedVersion(), aiConsentVersion);
      expect(await realPermission.acceptedVersion(), isNull);
      expect(
        (await SharedPreferences.getInstance()).getString(
          aiConsentPreferenceKey,
        ),
        isNull,
      );
      expect(await MemoryAiConsentStore().read(), isNull);
    },
  );

  testWidgets(
    'declining sends nothing, spends nothing and keeps Lucky usable',
    (tester) async {
      final ai = _ConsentAi();
      final app = DinerHarness();
      await app.pump(
        tester,
        route: AppRouter.methods,
        extra: _case,
        aiConsent: false,
        overrides: [aiServiceProvider.overrideWithValue(ai)],
      );
      await _tap(tester, 'ask-ai');
      expect(find.byKey(const Key('ai-consent-sheet')), findsOneWidget);
      await _tap(tester, 'consent-not-now');
      expect(ai.calls, 0);
      final db = app.container.read(databaseProvider);
      expect(await tester.runAsync(db.remainingAiDecisions), 3);
      expect(await tester.runAsync(db.getAllVerdicts), isEmpty);
      expect(
        await app.container.read(aiConsentProvider.notifier).acceptedVersion(),
        isNull,
      );
      await _tap(tester, 'start-lucky');
      expect(find.byType(LuckyVerdictScreen), findsOneWidget);
      expect(ai.calls, 0);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'Smart waits for durable permission and can retry a failed consent save',
    (tester) async {
      final store = _PermissionStore()..failWrite = true;
      final ai = _ConsentAi();
      final app = DinerHarness();
      await app.pump(
        tester,
        route: AppRouter.methods,
        extra: _case,
        aiConsent: false,
        overrides: [
          aiServiceProvider.overrideWithValue(ai),
          aiConsentStoreProvider.overrideWithValue(store),
        ],
      );
      await _tap(tester, 'ask-ai');
      await _tap(tester, 'consent-send');
      expect(
        find.text(
          'Permission could not be saved. No new request was sent. Please try again.',
        ),
        findsOneWidget,
      );
      expect(ai.calls, 0);
      final db = app.container.read(databaseProvider);
      expect(await tester.runAsync(db.remainingAiDecisions), 3);
      store.failWrite = false;
      await _tap(tester, 'consent-send');
      await _settle(tester);
      expect(ai.calls, 1);
      expect(store.value, aiConsentVersion);
      expect(find.byType(VerdictScreen), findsOneWidget);
      expect(await tester.runAsync(db.remainingAiDecisions), 2);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'an outdated gateway policy withdraws permission before retrying',
    (tester) async {
      final ai = _ConsentAi()..outdated = true;
      final app = DinerHarness();
      await app.pump(
        tester,
        route: AppRouter.methods,
        extra: _case,
        overrides: [aiServiceProvider.overrideWithValue(ai)],
      );
      await _tap(tester, 'ask-ai');
      await _settle(tester);
      expect(ai.calls, 1);
      expect(
        await app.container.read(aiConsentProvider.notifier).acceptedVersion(),
        isNull,
      );
      final db = app.container.read(databaseProvider);
      expect(await tester.runAsync(db.remainingAiDecisions), 3);
      expect(await tester.runAsync(db.getAllVerdicts), isEmpty);
      await _tap(tester, 'ask-ai');
      expect(find.byKey(const Key('ai-consent-sheet')), findsOneWidget);
      await _tap(tester, 'consent-not-now');
      expect(ai.calls, 1);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'settings reviews and withdraws current permission at Spanish 200 percent',
    (tester) async {
      final app = DinerHarness();
      await app.pump(
        tester,
        route: AppRouter.settings,
        locale: 'es',
        size: const Size(320, 568),
        textScale: 2,
      );
      await _tap(tester, 'settings-ai-consent');
      expect(find.byKey(const Key('ai-consent-sheet')), findsOneWidget);
      await _tap(tester, 'consent-revoke');
      expect(find.byKey(const Key('ai-consent-sheet')), findsNothing);
      expect(
        await app.container.read(aiConsentProvider.notifier).acceptedVersion(),
        isNull,
      );
      expect(
        (await SharedPreferences.getInstance()).getString(
          aiConsentPreferenceKey,
        ),
        isNull,
      );
      app.router.go(AppRouter.methods, extra: _case);
      await _settle(tester);
      await _tap(tester, 'ask-ai');
      await _tap(tester, 'consent-not-now');
      expect(tester.takeException(), isNull);
    },
  );
}
