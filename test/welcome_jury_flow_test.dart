import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:food_jury/config/routes/app_router.dart';
import 'package:food_jury/core/providers/judge_tone_provider.dart';
import 'package:food_jury/data/providers/database_provider.dart';
import 'package:food_jury/features/case_shelf/data/case_shelf_models.dart';
import 'package:food_jury/features/decision/data/models/food_option.dart';
import 'package:food_jury/features/decision/data/models/verdict.dart';
import 'package:food_jury/features/decision/presentation/new_decision_screen.dart';
import 'package:food_jury/features/home/presentation/home_screen.dart';
import 'package:food_jury/features/lucky/presentation/lucky_verdict_screen.dart';
import 'package:food_jury/features/lucky/presentation/plus_preview_screen.dart';
import 'package:food_jury/features/lucky/data/court_providers.dart';
import 'package:food_jury/features/onboarding/data/onboarding_store.dart';
import 'package:food_jury/features/onboarding/presentation/onboarding_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'decision_flow_test.dart' show drain;
import 'support/diner_harness.dart';

Future<void> tapKey(WidgetTester tester, String key) async {
  final finder = find.byKey(Key(key));
  await scrollTo(tester, finder);
  await tester.tap(finder);
  await drain(tester);
}

Future<void> nominate(WidgetTester tester, String name) async {
  await tapKey(tester, 'jury-ready');
  await tester.enterText(find.byKey(const Key('jury-dish')), name);
  await tester.pump();
  await tapKey(tester, 'jury-nominate');
}

void main() {
  setUpAll(loadDesignFonts);

  testWidgets(
    'first-run Skip opens the offer and completion waits for its exit',
    (tester) async {
      final harness = DinerHarness();
      await harness.pump(tester, route: AppRouter.splash);
      await drain(tester);
      expect(find.byType(OnboardingScreen), findsOneWidget);
      await tapKey(tester, 'welcome-skip');
      expect(find.byType(PlusPreviewScreen), findsOneWidget);
      expect(await OnboardingStore.isComplete(), isFalse);
      await tapKey(tester, 'welcome-offer-continue');
      expect(find.byType(NewDecisionScreen), findsOneWidget);
      expect(await OnboardingStore.isComplete(), isTrue);
    },
  );

  testWidgets('completed introduction is not repeated at startup', (
    tester,
  ) async {
    final harness = DinerHarness();
    await harness.pump(
      tester,
      route: AppRouter.splash,
      preferences: {OnboardingStore.completionKey: true},
    );
    await drain(tester);
    expect(find.byType(HomeScreen), findsOneWidget);
    expect(find.byType(OnboardingScreen), findsNothing);
  });

  testWidgets(
    'practice has a payoff but spends no allowance or history and preserves tone',
    (tester) async {
      final harness = DinerHarness();
      await harness.pump(tester, route: AppRouter.onboarding);
      final db = harness.container.read(databaseProvider);
      expect(
        find.byKey(const Key('welcome-try-demo')).hitTestable(),
        findsOneWidget,
      );
      expect(find.byKey(const Key('welcome-next')), findsNothing);
      await harness.screenshot(tester, 'welcome-methods-phone');
      await tapKey(tester, 'welcome-smart');
      await tapKey(tester, 'welcome-try-demo');
      expect(find.byKey(const Key('welcome-demo-result')), findsOneWidget);
      await harness.screenshot(tester, 'welcome-demo-phone');
      expect(await tester.runAsync(db.remainingAiDecisions), 3);
      expect(await tester.runAsync(db.getAllVerdicts), isEmpty);
      await tapKey(tester, 'welcome-next');
      await tapKey(tester, 'welcome-evidence');
      expect(
        find.byKey(const Key('welcome-next')).hitTestable(),
        findsOneWidget,
      );
      await tester.pump(const Duration(milliseconds: 600));
      await harness.screenshot(tester, 'welcome-evidence-phone');
      await tapKey(tester, 'welcome-next');
      await tapKey(tester, 'welcome-tone-chill');
      await harness.screenshot(tester, 'welcome-tone-phone');
      await tapKey(tester, 'welcome-next');
      expect(find.byType(PlusPreviewScreen), findsOneWidget);
      expect(await OnboardingStore.isComplete(), isFalse);
      await harness.screenshot(tester, 'welcome-offer-phone');
      await tapKey(tester, 'welcome-offer-continue');
      expect(find.byType(NewDecisionScreen), findsOneWidget);
      expect(harness.container.read(judgeToneProvider), JudgeTone.chill);
      expect(
        (await SharedPreferences.getInstance()).getString('judge_tone'),
        'chill',
      );
      expect(await OnboardingStore.isComplete(), isTrue);
      expect(await tester.runAsync(db.remainingAiDecisions), 3);
      expect(await tester.runAsync(db.getAllVerdicts), isEmpty);
    },
  );

  testWidgets(
    'Settings replay preserves an unfinished case without an offer or plan copy',
    (tester) async {
      final harness = DinerHarness();
      await harness.pump(
        tester,
        overrides: [aiAllowanceProvider.overrideWith((ref) async => 0)],
      );
      final draft = CaseDraft(
        options: const [FoodOption(id: 'my-dish', name: 'Family recipe')],
      );
      final db = harness.container.read(databaseProvider);
      await tester.runAsync(() => db.saveCaseDraft(draft));
      harness.router.go(
        AppRouter.onboarding,
        extra: const OnboardingReplayRouteData(),
      );
      await drain(tester);
      expect(find.textContaining('welcome rulings'), findsNothing);
      expect(find.textContaining('Plus'), findsNothing);
      expect(find.textContaining('Free'), findsNothing);
      await tapKey(tester, 'welcome-try-demo');
      await tapKey(tester, 'welcome-next');
      await tapKey(tester, 'welcome-next');
      await tapKey(tester, 'welcome-next');
      final editor = tester.widget<NewDecisionScreen>(
        find.byType(NewDecisionScreen),
      );
      expect(editor.initialDraft, draft);
    },
  );

  testWidgets(
    'private ballots reveal a tie and use the existing Lucky flow without AI',
    (tester) async {
      final harness = DinerHarness();
      await harness.pump(tester, route: AppRouter.jury);
      await tapKey(tester, 'jury-start');
      await nominate(tester, 'Pizza');
      await nominate(tester, 'Tacos');
      await tapKey(tester, 'jury-ready');
      await tapKey(tester, 'jury-vote-Pizza');
      await tapKey(tester, 'jury-seal');
      expect(find.byKey(const Key('jury-vote-Pizza')), findsNothing);
      expect(find.text('1 vote'), findsNothing);
      await tapKey(tester, 'jury-ready');
      await tapKey(tester, 'jury-vote-Tacos');
      await tapKey(tester, 'jury-seal');
      expect(find.text('1 vote'), findsNWidgets(2));
      await harness.screenshot(tester, 'jury-results-phone');
      await tapKey(tester, 'jury-tiebreak');
      await drain(tester);
      expect(find.byType(LuckyVerdictScreen), findsOneWidget);
      final verdict = tester
          .widget<LuckyVerdictScreen>(find.byType(LuckyVerdictScreen))
          .verdict;
      expect(verdict.contenders.map((o) => o.name).toSet(), {'Pizza', 'Tacos'});
      final db = harness.container.read(databaseProvider);
      expect(await tester.runAsync(db.remainingAiDecisions), 3);
      expect(await tester.runAsync(db.getAllVerdicts), isEmpty);
    },
  );

  testWidgets(
    'demo is finite, reduced motion can finish it, and Skip cancels it safely',
    (tester) async {
      final harness = DinerHarness();
      await harness.pump(
        tester,
        route: AppRouter.onboarding,
        reducedMotion: false,
      );
      await tester.tap(find.byKey(const Key('welcome-try-demo')));
      await tester.pump(const Duration(milliseconds: 200));
      expect(find.byKey(const Key('welcome-demo-result')), findsNothing);
      harness.motionDisabled.value = true;
      await tester.pump();
      await tester.pump();
      expect(find.byKey(const Key('welcome-demo-result')), findsOneWidget);
      expect(find.byKey(const Key('welcome-next')), findsOneWidget);
      harness.motionDisabled.value = false;
      await tester.pump();
      await tapKey(tester, 'welcome-replay-demo');
      await tester.tap(find.byKey(const Key('welcome-skip')));
      await drain(tester);
      await tester.pump(const Duration(seconds: 2));
      expect(find.byType(PlusPreviewScreen), findsOneWidget);
      expect(await OnboardingStore.isComplete(), isFalse);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets('normal demo reaches its verdict without another tap', (
    tester,
  ) async {
    final harness = DinerHarness();
    await harness.pump(
      tester,
      route: AppRouter.onboarding,
      reducedMotion: false,
    );
    await tester.tap(find.byKey(const Key('welcome-try-demo')));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 1050));
    await tester.pump();
    expect(find.byKey(const Key('welcome-demo-result')), findsOneWidget);
    expect(find.byKey(const Key('welcome-next')), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  for (final config in [
    (name: 'spanish-200', size: const Size(320, 568), locale: 'es', scale: 2.0),
    (name: 'landscape', size: const Size(844, 390), locale: 'en', scale: 1.0),
  ]) {
    testWidgets('every welcome step and offer fits ${config.name}', (
      tester,
    ) async {
      final harness = DinerHarness();
      await harness.pump(
        tester,
        route: AppRouter.onboarding,
        size: config.size,
        locale: config.locale,
        textScale: config.scale,
      );
      expect(tester.takeException(), isNull);
      await tapKey(tester, 'welcome-try-demo');
      expect(tester.takeException(), isNull);
      await tapKey(tester, 'welcome-next');
      expect(tester.takeException(), isNull);
      await tapKey(tester, 'welcome-next');
      await tapKey(tester, 'welcome-tone-chill');
      expect(tester.takeException(), isNull);
      await tapKey(tester, 'welcome-next');
      expect(find.byType(PlusPreviewScreen), findsOneWidget);
      expect(tester.takeException(), isNull);
      await tapKey(tester, 'welcome-offer-close');
      expect(find.byType(NewDecisionScreen), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  }

  testWidgets('jury remains usable at Spanish 200 percent text size', (
    tester,
  ) async {
    final harness = DinerHarness();
    await harness.pump(
      tester,
      route: AppRouter.jury,
      size: const Size(320, 568),
      locale: 'es',
      textScale: 2,
    );
    await tapKey(tester, 'jury-start');
    await tapKey(tester, 'jury-ready');
    expect(tester.takeException(), isNull);
  });
}
