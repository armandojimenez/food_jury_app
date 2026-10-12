import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:food_jury/config/routes/app_router.dart';
import 'package:food_jury/core/widgets/widgets.dart';
import 'package:food_jury/data/providers/database_provider.dart';
import 'package:food_jury/features/decision/data/models/food_option.dart';
import 'package:food_jury/features/decision/data/models/objective.dart';
import 'package:food_jury/features/decision/data/models/verdict.dart';
import 'package:food_jury/features/decision/presentation/new_decision_screen.dart';
import 'package:food_jury/features/food_library/presentation/food_library_screen.dart';
import 'package:food_jury/features/lucky/data/court_providers.dart';
import 'package:food_jury/features/lucky/data/decision_case.dart';
import 'package:food_jury/features/lucky/presentation/lucky_draw_screen.dart';
import 'package:food_jury/features/lucky/presentation/lucky_verdict_screen.dart';
import 'package:food_jury/features/lucky/presentation/method_picker_screen.dart';
import 'support/diner_harness.dart';
import 'decision_flow_test.dart' show addOption, drain, photoBytes;

DecisionCase sampleCase({int count = 3, bool photo = false}) => DecisionCase(
  options: [
    FoodOption(
      id: 'fish',
      name: 'Grilled local lionfish',
      notes: 'Lemon, garlic and rice.',
      illustrationId: 'category-seafood',
      imageBytes: photo ? photoBytes : null,
    ),
    const FoodOption(id: 'tacos', name: 'Tacos', illustrationId: 'tacos'),
    if (count > 2)
      const FoodOption(
        id: 'salad',
        name: 'Garden salad',
        illustrationId: 'salad',
      ),
  ],
  objective: Objective.fun,
);
Verdict luckyVerdict({
  RandomMethod method = RandomMethod.wheel,
  bool photo = false,
}) {
  final c = sampleCase(
    count: method == RandomMethod.coin ? 2 : 3,
    photo: photo,
  );
  return Verdict(
    id: 'lucky-${method.name}',
    winner: c.options[photo ? 0 : 1],
    rankings: const [],
    reasoning: '',
    objective: c.objective,
    judgeTone: JudgeTone.stern,
    createdAt: DateTime(2026, 10, 11),
    contenders: c.options,
    random: RandomRuling(
      method: method,
      quoteId: 'stern-02',
      quote: 'A fair draw. A final ruling. Dinner may proceed.',
      locale: 'en',
      catalogVersion: 1,
    ),
  );
}

class CountingCourt extends LuckyCourt {
  int draws = 0;
  @override
  Future<Verdict> draw({
    required DecisionCase caseData,
    required RandomMethod method,
    required JudgeTone tone,
    required Locale locale,
  }) async {
    draws++;
    return luckyVerdict(method: method)
        .copyWith(
          id: 'count-$draws',
          contenders: caseData.options,
          winner: caseData.options.first,
        )
        .snapshot();
  }
}

Future<void> tapKey(WidgetTester tester, String key) async {
  final finder = find.byKey(Key(key));
  await scrollTo(tester, finder);
  await tester.tap(finder);
  await drain(tester);
}

Future<void> tapButton(WidgetTester tester, String text) async {
  final finder = find.widgetWithText(DinerButton, text);
  await scrollTo(tester, finder);
  await tester.tap(finder);
  await drain(tester);
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setUpAll(loadDesignFonts);
  final configs = [
    (
      name: 'small-phone',
      size: const Size(320, 568),
      scale: 1.0,
      locale: 'en',
      dark: false,
    ),
    (
      name: 'phone',
      size: const Size(390, 844),
      scale: 1.0,
      locale: 'en',
      dark: false,
    ),
    (
      name: 'phone-125',
      size: const Size(390, 844),
      scale: 1.25,
      locale: 'en',
      dark: false,
    ),
    (
      name: 'tablet',
      size: const Size(834, 1194),
      scale: 1.0,
      locale: 'en',
      dark: false,
    ),
    (
      name: 'landscape',
      size: const Size(1194, 834),
      scale: 1.0,
      locale: 'en',
      dark: false,
    ),
    (
      name: 'small-es-200',
      size: const Size(320, 568),
      scale: 2.0,
      locale: 'es',
      dark: false,
    ),
    (
      name: 'dark',
      size: const Size(390, 844),
      scale: 1.0,
      locale: 'en',
      dark: true,
    ),
  ];
  for (final config in configs) {
    for (final screen in ['methods', 'library', 'lucky', 'plus', 'photo']) {
      testWidgets('$screen / ${config.name} remains readable and scrollable', (
        tester,
      ) async {
        final app = DinerHarness();
        await app.pump(
          tester,
          route: switch (screen) {
            'methods' => AppRouter.methods,
            'library' => AppRouter.foodLibrary,
            'plus' => AppRouter.plus,
            _ => AppRouter.verdict,
          },
          extra: screen == 'methods'
              ? sampleCase()
              : screen == 'lucky' || screen == 'photo'
              ? VerdictRouteData(
                  verdict: luckyVerdict(photo: screen == 'photo'),
                  showRevealAnimation: false,
                )
              : null,
          size: config.size,
          textScale: config.scale,
          locale: config.locale,
          dark: config.dark,
        );
        await app.screenshot(tester, 'lucky-$screen-${config.name}');
        expect(tester.takeException(), isNull);
        final scroll = find.byType(Scrollable).first;
        for (var i = 0; i < 4; i++) {
          await tester.drag(scroll, Offset(0, -config.size.height * .8));
          await tester.pumpAndSettle();
          expect(tester.takeException(), isNull);
        }
        await tester.pumpWidget(const SizedBox.shrink());
      });
    }
    for (final method in RandomMethod.values) {
      testWidgets(
        '${method.name} animation / ${config.name} reaches its chosen result',
        (tester) async {
          final app = DinerHarness();
          await app.pump(
            tester,
            route: AppRouter.draw,
            extra: DrawRouteData(verdict: luckyVerdict(method: method)),
            size: config.size,
            textScale: config.scale,
            locale: config.locale,
            dark: config.dark,
            reducedMotion: false,
          );
          await app.screenshot(tester, 'lucky-${method.name}-${config.name}');
          expect(tester.takeException(), isNull);
          await tester.pump(const Duration(seconds: 4));
          await tester.pump();
          await tester.pumpAndSettle();
          expect(find.byType(LuckyVerdictScreen), findsOneWidget);
          expect(
            tester
                .widget<LuckyVerdictScreen>(find.byType(LuckyVerdictScreen))
                .verdict
                .id,
            'lucky-${method.name}',
          );
          expect(tester.takeException(), isNull);
        },
      );
    }
  }

  testWidgets(
    'generic seafood art preserves the exact name, notes and user photo',
    (tester) async {
      final app = DinerHarness();
      await app.pump(
        tester,
        route: AppRouter.newDecision,
        extra: sampleCase(photo: true),
      );
      final edit = find.byTooltip('Edit option').first;
      await scrollTo(tester, edit);
      await tester.tap(edit);
      await tester.pumpAndSettle();
      await tapKey(tester, 'choose-food-art');
      expect(find.byType(FoodLibraryScreen), findsOneWidget);
      await tester.enterText(
        find.byKey(const Key('food-library-search')),
        'seafood',
      );
      await tester.pumpAndSettle();
      await tapKey(tester, 'food-art-category-seafood');
      expect(
        tester
            .widget<TextFormField>(find.byKey(const Key('option-name')))
            .controller!
            .text,
        'Grilled local lionfish',
      );
      expect(
        tester
            .widget<TextFormField>(find.byKey(const Key('option-notes')))
            .controller!
            .text,
        'Lemon, garlic and rice.',
      );
      expect(
        tester.widget<FoodImagePicker>(find.byType(FoodImagePicker)).imageBytes,
        photoBytes,
      );
      await tapKey(tester, 'save-option');
      final images = tester.widgetList<DinerFoodImage>(
        find.byType(DinerFoodImage),
      );
      expect(images.first.illustrationId, 'category-seafood');
      expect(images.first.bytes, photoBytes);
    },
  );

  testWidgets(
    'unknown food search offers broad fallback and specific selection seeds only empty names',
    (tester) async {
      final app = DinerHarness();
      await app.pump(tester, route: AppRouter.newDecision);
      await tapKey(tester, 'add-option');
      await tapKey(tester, 'choose-food-art');
      await tester.enterText(
        find.byKey(const Key('food-library-search')),
        'Mystery moon dumpling',
      );
      await tester.pumpAndSettle();
      expect(find.text('OFF-MENU? THE COURT ALLOWS IT.'), findsOneWidget);
      await tapKey(tester, 'food-art-category-any');
      expect(
        tester
            .widget<TextFormField>(find.byKey(const Key('option-name')))
            .controller!
            .text,
        isEmpty,
      );
      await tapKey(tester, 'choose-food-art');
      await tapKey(tester, 'food-art-tacos');
      expect(
        tester
            .widget<TextFormField>(find.byKey(const Key('option-name')))
            .controller!
            .text,
        'Tacos',
      );
      await tapKey(tester, 'save-option');
      expect(find.text('Tacos'), findsOneWidget);
    },
  );

  testWidgets(
    'coin is unavailable for three options even when previously selected',
    (tester) async {
      final app = DinerHarness();
      await app.pump(
        tester,
        route: AppRouter.methods,
        extra: sampleCase(),
        preferences: {'lucky_method': 'coin'},
      );
      final card = tester.widget<InkWell>(find.byKey(const Key('method-coin')));
      expect(card.onTap, isNull);
      expect(
        find.text('Needs exactly 2 options. Edit your case to use the coin.'),
        findsOneWidget,
      );
      await tapKey(tester, 'start-lucky');
      await tester.pumpAndSettle();
      expect(
        tester
            .widget<LuckyVerdictScreen>(find.byType(LuckyVerdictScreen))
            .verdict
            .random!
            .method,
        RandomMethod.wheel,
      );
    },
  );

  testWidgets(
    'save is explicit; replay is identical; reroll creates a new unsaved result',
    (tester) async {
      final app = DinerHarness(), court = CountingCourt();
      await app.pump(
        tester,
        route: AppRouter.methods,
        extra: sampleCase(),
        overrides: [luckyCourtProvider.overrideWithValue(court)],
      );
      await tapKey(tester, 'start-lucky');
      await tester.pumpAndSettle();
      final db = app.container.read(databaseProvider);
      expect(await tester.runAsync(db.getAllVerdicts), isEmpty);
      final before = tester
          .widget<LuckyVerdictScreen>(find.byType(LuckyVerdictScreen))
          .verdict;
      await tapKey(tester, 'save-lucky');
      expect((await tester.runAsync(db.getAllVerdicts))!.length, 1);
      expect(await tester.runAsync(db.remainingAiDecisions), 3);
      await tapKey(tester, 'replay-lucky');
      await tester.pumpAndSettle();
      expect(court.draws, 1);
      expect(
        tester
            .widget<LuckyVerdictScreen>(find.byType(LuckyVerdictScreen))
            .verdict,
        before,
      );
      await tapKey(tester, 'reroll-lucky');
      await tester.pumpAndSettle();
      expect(court.draws, 2);
      expect(
        tester
            .widget<LuckyVerdictScreen>(find.byType(LuckyVerdictScreen))
            .verdict
            .id,
        isNot(before.id),
      );
      expect((await tester.runAsync(db.getAllVerdicts))!.length, 1);
    },
  );

  testWidgets('cancelling near animation completion cannot open the verdict', (
    tester,
  ) async {
    final app = DinerHarness();
    await app.pump(
      tester,
      route: AppRouter.methods,
      extra: sampleCase(),
      reducedMotion: false,
    );
    app.router.push(
      AppRouter.draw,
      extra: DrawRouteData(verdict: luckyVerdict()),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 3150));
    app.router.pop();
    await tester.pump();
    await tester.pump(const Duration(seconds: 2));
    expect(find.byType(MethodPickerScreen), findsOneWidget);
    expect(find.byType(LuckyVerdictScreen), findsNothing);
    expect(tester.takeException(), isNull);
  });

  testWidgets(
    'changing to reduced motion finishes exactly the existing result',
    (tester) async {
      final app = DinerHarness();
      await app.pump(
        tester,
        route: AppRouter.draw,
        extra: DrawRouteData(verdict: luckyVerdict()),
        reducedMotion: false,
      );
      app.motionDisabled.value = true;
      await tester.pump();
      await tester.pump();
      await tester.pumpAndSettle();
      expect(find.byType(LuckyVerdictScreen), findsOneWidget);
      expect(tester.binding.transientCallbackCount, 0);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets('history to another method to edit restores original evidence', (
    tester,
  ) async {
    final app = DinerHarness();
    await app.pump(
      tester,
      route: AppRouter.verdict,
      extra: VerdictRouteData(
        verdict: luckyVerdict(photo: true),
        saved: true,
        showRevealAnimation: false,
      ),
    );
    await tapButton(tester, 'TRY ANOTHER METHOD');
    await tapButton(tester, 'EDIT THIS CASE');
    expect(find.byType(NewDecisionScreen), findsOneWidget);
    expect(find.text('Grilled local lionfish'), findsOneWidget);
    final photo = tester
        .widgetList<DinerFoodImage>(find.byType(DinerFoodImage))
        .first;
    expect(photo.bytes, photoBytes);
    expect(photo.illustrationId, 'category-seafood');
  });

  testWidgets('successive new-case actions always begin with a blank draft', (
    tester,
  ) async {
    final app = DinerHarness();
    await app.pump(tester, route: AppRouter.newDecision);
    for (var i = 0; i < 2; i++) {
      await addOption(tester, 'Old dish $i');
      app.router.push(AppRouter.verdict, extra: luckyVerdict());
      await tester.pumpAndSettle();
      await tapButton(tester, 'START ANOTHER CASE');
      expect(find.byType(NewDecisionScreen), findsOneWidget);
      expect(find.text('Old dish $i'), findsNothing);
      expect(
        tester
            .widget<DinerButton>(find.byKey(const Key('submit-case')))
            .onPressed,
        isNull,
      );
    }
  });

  testWidgets('last free AI confirmation offers Lucky without losing the case', (
    tester,
  ) async {
    final app = DinerHarness();
    await app.pump(
      tester,
      route: AppRouter.methods,
      extra: sampleCase(),
      overrides: [
        aiAllowanceProvider.overrideWith((ref) async => 1),
        luckyCourtProvider.overrideWithValue(CountingCourt()),
      ],
    );
    await tapKey(tester, 'ask-ai');
    expect(
      find.text(
        'This is your last welcome Smart ruling. Lucky Court is always on the house. Plus keeps the judge deliberating, without limits.',
      ),
      findsOneWidget,
    );
    await tester.tap(find.text('LET LUCK DECIDE INSTEAD'));
    await tester.pumpAndSettle();
    expect(find.byType(MethodPickerScreen), findsOneWidget);
    expect(find.byType(DinerDeliberation), findsNothing);
    await tapKey(tester, 'start-lucky');
    await tester.pumpAndSettle();
    expect(find.byType(LuckyVerdictScreen), findsOneWidget);
  });

  testWidgets('Lucky winner exposes a single complete accessible result', (
    tester,
  ) async {
    final handle = tester.ensureSemantics();
    final app = DinerHarness();
    await app.pump(tester, route: AppRouter.verdict, extra: luckyVerdict());
    expect(
      find.bySemanticsLabel(RegExp('Tacos. Spin the plate. A fair draw.')),
      findsOneWidget,
    );
    handle.dispose();
  });
}
