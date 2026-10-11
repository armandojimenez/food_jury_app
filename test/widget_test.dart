import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:food_jury/config/routes/app_router.dart';
import 'package:food_jury/core/widgets/widgets.dart';
import 'support/diner_harness.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setUpAll(loadDesignFonts);
  const screens = {
    'home': AppRouter.home,
    'case': AppRouter.newDecision,
    'verdict': AppRouter.verdict,
    'history': AppRouter.history,
    'settings': AppRouter.settings,
    'about': AppRouter.aboutDeveloper,
    'kitchen': AppRouter.devSettings,
  };
  final configurations = [
    (
      name: 'phone',
      size: const Size(390, 844),
      scale: 1.0,
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
      name: 'phone-dark',
      size: const Size(390, 844),
      scale: 1.0,
      locale: 'en',
      dark: true,
    ),
  ];
  for (final config in configurations) {
    for (final screen in screens.entries) {
      testWidgets(
        '${screen.key} / ${config.name} lays out and scrolls without exceptions',
        (tester) async {
          final app = DinerHarness();
          await app.pump(
            tester,
            route: screen.value,
            extra: screen.key == 'verdict'
                ? VerdictRouteData(
                    verdict: sampleVerdict,
                    showRevealAnimation: false,
                  )
                : null,
            size: config.size,
            textScale: config.scale,
            locale: config.locale,
            dark: config.dark,
          );
          expect(tester.takeException(), isNull);
          await app.screenshot(tester, '${screen.key}-${config.name}');
          final scrollables = find.byType(Scrollable);
          if (scrollables.evaluate().isNotEmpty) {
            await tester.drag(
              scrollables.first,
              Offset(0, -config.size.height * .8),
            );
            await tester.pumpAndSettle();
            expect(tester.takeException(), isNull);
          }
          await tester.pumpWidget(const SizedBox.shrink());
          await tester.pump();
        },
      );
    }
  }

  testWidgets('empty counter and archive keep a clear next action', (
    tester,
  ) async {
    final app = DinerHarness();
    await app.pump(tester, history: []);
    expect(find.byType(DinerButton), findsOneWidget);
    await app.screenshot(tester, 'home-empty-phone');
    app.router.go(AppRouter.history);
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
    await app.screenshot(tester, 'history-empty-phone');
  });

  testWidgets('missing verdict data and unknown routes recover gracefully', (
    tester,
  ) async {
    final app = DinerHarness();
    await app.pump(tester, route: AppRouter.verdict);
    expect(find.text('BACK TO COURT'), findsOneWidget);
    expect(tester.takeException(), isNull);
    app.router.go('/missing');
    await tester.pumpAndSettle();
    expect(find.text('BACK TO COURT'), findsOneWidget);
  });

  testWidgets('long archive is lazy', (tester) async {
    final cases = List.generate(
      200,
      (i) => sampleVerdict.copyWith(id: 'case-$i'),
    );
    final app = DinerHarness();
    await app.pump(tester, route: AppRouter.history, history: cases);
    expect(find.text('Tacos al pastor').evaluate().length, lessThan(20));
    expect(tester.takeException(), isNull);
  });
}
