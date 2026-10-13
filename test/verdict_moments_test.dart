import 'dart:async';
import 'dart:io';
import 'dart:ui' as ui;

import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:food_jury/config/routes/app_router.dart';
import 'package:food_jury/core/services/ai_service.dart';
import 'package:food_jury/core/services/ai_gateway_service.dart';
import 'package:food_jury/core/theme/theme.dart';
import 'package:food_jury/core/widgets/widgets.dart';
import 'package:food_jury/features/case_shelf/data/case_shelf_models.dart';
import 'package:food_jury/features/case_shelf/data/case_shelf_provider.dart';
import 'package:food_jury/features/moments/presentation/meal_feedback_card.dart';
import 'package:food_jury/data/database/app_database.dart';
import 'package:food_jury/data/providers/database_provider.dart';
import 'package:food_jury/features/decision/data/models/verdict.dart';
import 'package:food_jury/features/decision/presentation/new_decision_screen.dart';
import 'package:food_jury/features/lucky/data/decision_case.dart';
import 'package:food_jury/features/lucky/presentation/lucky_draw_screen.dart';
import 'package:food_jury/features/lucky/presentation/method_picker_screen.dart';
import 'package:food_jury/features/moments/presentation/saved_case_moment.dart';
import 'package:food_jury/features/moments/presentation/smart_error_copy.dart';
import 'package:food_jury/features/moments/presentation/verdict_receipt.dart';
import 'package:food_jury/l10n/app_localizations.dart';
import 'package:food_jury/l10n/app_localizations_en.dart';

import 'decision_flow_test.dart' show drain, photoBytes;
import 'lucky_court_ui_test.dart' show luckyVerdict;
import 'support/diner_harness.dart';

class _SaveFailureDatabase extends AppDatabase {
  _SaveFailureDatabase() : super.forTesting(NativeDatabase.memory());
  bool fail = true;
  @override
  Future<void> saveVerdict(Verdict verdict) async {
    if (fail) throw StateError('Disk full');
    await super.saveVerdict(verdict);
  }
}

class _FeedbackFailureDatabase extends AppDatabase {
  _FeedbackFailureDatabase() : super.forTesting(NativeDatabase.memory());
  bool failWrite = false, failRead = false;
  @override
  Future<void> setMealFeedback(
    String verdictId, {
    required bool ate,
    bool? wouldAgain,
  }) {
    if (failWrite) return Future.error(StateError('Feedback storage failure'));
    return super.setMealFeedback(verdictId, ate: ate, wouldAgain: wouldAgain);
  }

  @override
  Stream<MealFeedbackEntry?> watchMealFeedback(String verdictId) => failRead
      ? Stream.error(StateError('Feedback read failure'))
      : super.watchMealFeedback(verdictId);
}

Future<void> tapMomentKey(WidgetTester tester, String key) async {
  // Wait for database streams before locating a control in the changing receipt.
  await drain(tester);
  await tester.pumpAndSettle();
  final finder = find.byKey(Key(key));
  await Scrollable.ensureVisible(tester.element(finder), alignment: .5);
  await tester.pumpAndSettle();
  expect(finder.hitTestable(), findsOneWidget);
  await tester.tap(finder);
  await drain(tester);
}

Verdict illustratedReceiptVerdict(String locale) {
  final spanish = locale == 'es';
  final options = [
    taco.copyWith(illustrationId: 'tacos'),
    pizza.copyWith(name: spanish ? 'Pizza de pepperoni' : pizza.name),
    salad.copyWith(name: spanish ? 'Ensalada de la casa' : salad.name),
  ];
  return sampleVerdict.copyWith(
    winner: options.first,
    rankings: options,
    contenders: options,
    reasoning: spanish
        ? 'Ahumados, un poquito picantes y llenos de alegría. '
              'Estos tacos se llevan la corona. ¡Caso cerrado!'
        : sampleVerdict.reasoning,
  );
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setUpAll(loadDesignFonts);

  test('ritual pacing is method-specific and repeats are shorter', () {
    expect(
      ritualDuration(RandomMethod.coin),
      lessThan(ritualDuration(RandomMethod.wheel)),
    );
    for (final method in RandomMethod.values) {
      expect(
        ritualDuration(method, repeat: true),
        lessThan(ritualDuration(method)),
      );
      expect(ritualDuration(method, repeat: true), greaterThan(Duration.zero));
    }
  });

  test(
    'Smart errors keep offline and timeout causes through adapter wrapping',
    () {
      final l = AppLocalizationsEn();
      expect(
        smartRulingError(l, const SocketException('offline')),
        l.moments_offline,
      );
      expect(
        smartRulingError(
          l,
          AiServiceException('AI failed', TimeoutException('slow')),
        ),
        l.moments_timeout,
      );
      expect(smartRulingError(l, StateError('unexpected')), l.lucky_aiError);
      for (final entry in {
        AiGatewayError.rateLimit: l.moments_gatewayBusy,
        AiGatewayError.contentFilter: l.moments_gatewayCaseReview,
        AiGatewayError.payloadTooLarge: l.moments_gatewayTooLarge,
        AiGatewayError.configuration: l.moments_gatewayUnavailable,
        AiGatewayError.unauthorized: l.moments_gatewayUnavailable,
        AiGatewayError.network: l.moments_offline,
        AiGatewayError.timeout: l.moments_timeout,
      }.entries) {
        expect(
          smartRulingError(l, AiGatewayException(entry.key, 'Internal detail')),
          entry.value,
        );
      }
    },
  );

  for (final locale in ['en', 'es']) {
    testWidgets('receipt exports complete PNG with photo fixture / $locale', (
      tester,
    ) async {
      final boundaryKey = GlobalKey();
      final verdict = luckyVerdict(photo: true);
      tester.view.physicalSize = const Size(800, 1800);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            theme: AppTheme.dark,
            locale: Locale(locale),
            supportedLocales: const [Locale('en'), Locale('es')],
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            home: Builder(
              builder: (context) => MediaQuery(
                data: MediaQuery.of(context).copyWith(disableAnimations: true),
                child: Scaffold(
                  body: SingleChildScrollView(
                    child: Center(
                      child: SizedBox(
                        width: 360,
                        child: RepaintBoundary(
                          key: boundaryKey,
                          child: VerdictReceipt(verdict: verdict),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      );
      await drain(tester);
      expect(find.text('“${verdict.displayRuling}”'), findsOneWidget);
      for (final (index, option) in verdict.caseOptions.indexed) {
        expect(find.text('${index + 1}. ${option.name}'), findsOneWidget);
      }
      final providers = tester
          .widgetList<Image>(find.byType(Image))
          .map(
            (image) => image.image is ResizeImage
                ? (image.image as ResizeImage).imageProvider
                : image.image,
          );
      final photo = providers.whereType<MemoryImage>();
      expect(photo, hasLength(1));
      expect(photo.single.bytes, orderedEquals(photoBytes));
      await tester.runAsync(() async {
        final bytes = await captureVerdictReceipt(boundaryKey);
        if (const bool.fromEnvironment('UPDATE_DESIGN_PREVIEWS')) {
          await File(
            'design/verification/receipt-photo-fixture-$locale.png',
          ).writeAsBytes(bytes);
        }
        expect(bytes.take(8), orderedEquals([137, 80, 78, 71, 13, 10, 26, 10]));
        final codec = await ui.instantiateImageCodec(bytes);
        final frame = await codec.getNextFrame();
        expect(frame.image.width, 720);
        expect(frame.image.height, greaterThan(frame.image.width));
        frame.image.dispose();
        codec.dispose();
      });
      expect(tester.takeException(), isNull);
    });
  }

  for (final scenario in [
    (locale: 'en', scale: 1.0, name: 'receipt-en'),
    (locale: 'es', scale: 1.0, name: 'receipt-es'),
    (locale: 'es', scale: 2.0, name: 'receipt-es-200'),
  ]) {
    testWidgets('illustrated receipt is complete / ${scenario.name}', (
      tester,
    ) async {
      final boundaryKey = GlobalKey();
      final verdict = illustratedReceiptVerdict(scenario.locale);
      tester.view.physicalSize = const Size(800, 6400);
      tester.view.devicePixelRatio = 2;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            // The exported receipt stays legible when launched from dark mode.
            theme: AppTheme.dark,
            locale: Locale(scenario.locale),
            supportedLocales: const [Locale('en'), Locale('es')],
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            home: Builder(
              builder: (context) => MediaQuery(
                data: MediaQuery.of(context).copyWith(
                  disableAnimations: true,
                  textScaler: TextScaler.linear(scenario.scale),
                ),
                child: Scaffold(
                  body: SingleChildScrollView(
                    child: Center(
                      child: SizedBox(
                        width: 360,
                        child: RepaintBoundary(
                          key: boundaryKey,
                          child: VerdictReceipt(verdict: verdict),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      );
      await drain(tester);
      final assets = tester
          .widgetList<Image>(find.byType(Image))
          .map((image) => image.image);
      await tester.runAsync(() async {
        await Future.wait([
          for (final asset in assets)
            precacheImage(asset, boundaryKey.currentContext!),
        ]);
      });
      await tester.pump();
      final receipt = find.byKey(const Key('verdict-receipt'));
      expect(Theme.of(tester.element(receipt)).brightness, Brightness.light);
      expect(find.text('“${verdict.displayRuling}”'), findsOneWidget);
      for (final (index, option) in verdict.caseOptions.indexed) {
        expect(find.text('${index + 1}. ${option.name}'), findsOneWidget);
      }
      expect(find.byType(FoodIllustration), findsOneWidget);
      expect(find.byType(JudgeBite), findsOneWidget);
      await tester.runAsync(() async {
        final bytes = await captureVerdictReceipt(boundaryKey);
        final codec = await ui.instantiateImageCodec(bytes);
        final frame = await codec.getNextFrame();
        expect(frame.image.width, 720);
        expect(frame.image.height, greaterThan(frame.image.width));
        if (const bool.fromEnvironment('UPDATE_DESIGN_PREVIEWS')) {
          await File(
            'design/verification/${scenario.name}.png',
          ).writeAsBytes(bytes);
        }
        frame.image.dispose();
        codec.dispose();
      });
      expect(tester.takeException(), isNull);
    });
  }

  for (final scenario in [
    (locale: 'en', scale: 1.0, dark: false, name: 'smart-result-phone'),
    (locale: 'en', scale: 1.0, dark: true, name: 'smart-result-dark'),
    (locale: 'es', scale: 2.0, dark: false, name: 'smart-result-es-200'),
  ]) {
    testWidgets('Smart result and receipt layout / ${scenario.name}', (
      tester,
    ) async {
      final verdict = illustratedReceiptVerdict(scenario.locale);
      final app = DinerHarness();
      await app.pump(
        tester,
        route: AppRouter.verdict,
        extra: VerdictRouteData(verdict: verdict, showRevealAnimation: false),
        locale: scenario.locale,
        textScale: scenario.scale,
        dark: scenario.dark,
      );
      await tester.runAsync(
        () => app.container.read(databaseProvider).saveAiVerdict(verdict),
      );
      await drain(tester);
      expect(find.byType(JudgeBite), findsOneWidget);
      await app.screenshot(tester, scenario.name);
      final context = tester.element(
        find.byKey(const Key('smart-verdict-busy')),
      );
      final l = AppLocalizations.of(context)!;
      final share = find.widgetWithText(
        DinerButton,
        l.diner_share.toUpperCase(),
      );
      await tester.ensureVisible(share);
      await tester.pumpAndSettle();
      expect(share.hitTestable(), findsOneWidget);
      await tester.tap(share);
      await drain(tester);
      expect(find.byType(VerdictReceipt), findsOneWidget);
      await app.screenshot(tester, '${scenario.name}-share');
      final export = find.widgetWithText(
        DinerButton,
        l.moments_shareImage.toUpperCase(),
      );
      await tester.ensureVisible(export);
      await tester.pumpAndSettle();
      expect(export.hitTestable(), findsOneWidget);
      await app.screenshot(tester, '${scenario.name}-share-actions');
      expect(tester.takeException(), isNull);
    });
  }

  for (final edit in [true, false]) {
    testWidgets(
      'Smart objection preserves evidence and allowance / edit=$edit',
      (tester) async {
        final app = DinerHarness();
        final options = [taco.copyWith(imageBytes: photoBytes), pizza, salad];
        final verdict = sampleVerdict
            .copyWith(
              winner: options.first,
              contenders: options,
              rankings: options,
            )
            .snapshot();
        await app.pump(tester, route: AppRouter.verdict, extra: verdict);
        final db = app.container.read(databaseProvider);
        await tester.runAsync(() => db.saveAiVerdict(verdict));
        await tapMomentKey(tester, 'objection-smart');
        await tapMomentKey(
          tester,
          edit ? 'objection-edit' : 'objection-method',
        );
        await tester.pumpAndSettle();
        final CaseDraft caseData;
        if (edit) {
          final editor = tester.widget<NewDecisionScreen>(
            find.byType(NewDecisionScreen),
          );
          caseData =
              editor.initialDraft ?? CaseDraft.fromCase(editor.initialCase!);
        } else {
          caseData = CaseDraft.fromCase(
            tester
                .widget<MethodPickerScreen>(find.byType(MethodPickerScreen))
                .caseData,
          );
        }
        expect(
          caseData.options.map((o) => o.id),
          orderedEquals(options.map((o) => o.id)),
        );
        expect(caseData.options.first.imageBytes, orderedEquals(photoBytes));
        expect(caseData.options.first.notes, taco.notes);
        expect(caseData.objective, verdict.objective);
        expect(await tester.runAsync(db.remainingAiDecisions), 2);
        final saved = await tester.runAsync(db.getAllVerdicts);
        expect(saved, hasLength(1));
        expect(saved!.single, verdict);
        expect(tester.takeException(), isNull);
      },
    );
  }

  testWidgets('filing appears only after successful persistence', (
    tester,
  ) async {
    final db = _SaveFailureDatabase();
    addTearDown(db.close);
    final app = DinerHarness();
    await app.pump(
      tester,
      route: AppRouter.verdict,
      extra: luckyVerdict(),
      overrides: [databaseProvider.overrideWithValue(db)],
    );
    await tapMomentKey(tester, 'save-lucky');
    expect(find.byType(SavedCaseMoment), findsNothing);
    expect(await tester.runAsync(db.getAllVerdicts), isEmpty);
    db.fail = false;
    await tapMomentKey(tester, 'save-lucky');
    expect(find.byKey(const Key('case-filed')), findsOneWidget);
    expect(await tester.runAsync(db.getAllVerdicts), hasLength(1));
    expect(await tester.runAsync(db.remainingAiDecisions), 3);
    // Flush stream/image rebuilds without advancing time: reduced motion must
    // not leave a running filing or celebration ticker after those frames.
    await tester.pump();
    await tester.pump();
    expect(tester.binding.transientCallbackCount, 0);
  });
  testWidgets('objection edit can cancel replacement without losing a draft', (
    tester,
  ) async {
    final app = DinerHarness();
    await app.pump(tester, route: AppRouter.verdict, extra: sampleVerdict);
    final draft = CaseDraft(options: [pizza]);
    await tester.runAsync(
      () => app.container.read(caseShelfStoreProvider).saveDraft(draft),
    );
    await drain(tester);
    await tapMomentKey(tester, 'objection-smart');
    await tapMomentKey(tester, 'objection-edit');
    expect(find.text('A CASE IS STILL ON THE COUNTER'), findsOneWidget);
    await tester.tap(find.text('CANCEL').last);
    await drain(tester);
    expect(find.byType(NewDecisionScreen), findsNothing);
    expect(
      (await tester.runAsync(
        () => app.container.read(caseShelfProvider.future),
      ))!.draft,
      draft,
    );
  });

  testWidgets('saved-only meal feedback retries and remains reversible', (
    tester,
  ) async {
    final db = _FeedbackFailureDatabase();
    addTearDown(db.close);
    final app = DinerHarness();
    final verdict = luckyVerdict();
    await app.pump(
      tester,
      route: AppRouter.verdict,
      extra: verdict,
      overrides: [databaseProvider.overrideWithValue(db)],
    );
    expect(find.byType(MealFeedbackCard), findsNothing);
    await tapMomentKey(tester, 'save-lucky');
    expect(find.byType(MealFeedbackCard), findsOneWidget);
    // The filed footer must leave room to read and interact with the verdict.
    expect(tester.getSize(find.byType(SavedCaseMoment)).height, lessThan(160));
    await app.screenshot(tester, 'filed-verdict-phone');
    db.failWrite = true;
    await tapMomentKey(tester, 'feedback-ate-yes');
    expect(find.byKey(const Key('feedback-save-retry')), findsOneWidget);
    expect(await tester.runAsync(() => db.getMealFeedback(verdict.id)), isNull);
    db.failWrite = false;
    await tapMomentKey(tester, 'feedback-save-retry');
    await drain(tester);
    expect(
      (await tester.runAsync(() => db.getMealFeedback(verdict.id)))!.ate,
      true,
    );
    await tapMomentKey(tester, 'feedback-again-yes');
    await drain(tester);
    expect(
      (await tester.runAsync(() => db.getMealFeedback(verdict.id)))!.wouldAgain,
      true,
    );
    app.router.go(AppRouter.home);
    await drain(tester);
    app.router.push(
      AppRouter.verdict,
      extra: VerdictRouteData(
        verdict: verdict,
        saved: true,
        showRevealAnimation: false,
      ),
    );
    await drain(tester);
    expect(
      tester
          .widget<DinerChoice>(find.byKey(const Key('feedback-again-yes')))
          .selected,
      true,
    );
    await tapMomentKey(tester, 'feedback-again-no');
    await drain(tester);
    expect(
      (await tester.runAsync(() => db.getMealFeedback(verdict.id)))!.wouldAgain,
      false,
    );
    await tapMomentKey(tester, 'feedback-ate-no');
    await drain(tester);
    expect(find.byKey(const Key('feedback-again-yes')), findsNothing);
    final declined = await tester.runAsync(
      () => db.getMealFeedback(verdict.id),
    );
    expect(declined!.ate, false);
    expect(declined.wouldAgain, isNull);
    await tapMomentKey(tester, 'feedback-clear');
    await drain(tester);
    expect(await tester.runAsync(() => db.getMealFeedback(verdict.id)), isNull);
    expect(await tester.runAsync(db.getAllVerdicts), hasLength(1));
    expect(await tester.runAsync(db.remainingAiDecisions), 3);
    expect(tester.takeException(), isNull);
  });

  testWidgets('meal feedback load can retry and handles Spanish large text', (
    tester,
  ) async {
    final db = _FeedbackFailureDatabase()..failRead = true;
    addTearDown(db.close);
    await tester.runAsync(() async {
      await db.saveAiVerdict(sampleVerdict);
      await db.setMealFeedback(sampleVerdict.id, ate: true, wouldAgain: true);
    });
    final app = DinerHarness();
    await app.pump(
      tester,
      route: AppRouter.verdict,
      extra: sampleVerdict,
      size: const Size(320, 568),
      textScale: 2,
      locale: 'es',
      overrides: [databaseProvider.overrideWithValue(db)],
    );
    expect(find.byKey(const Key('feedback-load-retry')), findsOneWidget);
    db.failRead = false;
    await tapMomentKey(tester, 'feedback-load-retry');
    await drain(tester);
    await scrollTo(tester, find.byKey(const Key('feedback-again-yes')));
    await app.screenshot(tester, 'feedback-es-200');
    expect(
      tester
          .widget<DinerChoice>(find.byKey(const Key('feedback-again-yes')))
          .selected,
      true,
    );
    expect(await tester.runAsync(db.remainingAiDecisions), 2);
    expect(tester.takeException(), isNull);
  });
}
