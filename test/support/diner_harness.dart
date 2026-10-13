import 'dart:io';
import 'package:drift/native.dart';
import 'package:food_jury/data/database/app_database.dart';
import 'package:food_jury/data/providers/database_provider.dart';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:food_jury/config/routes/app_router.dart';
import 'package:food_jury/core/env/env.dart';
import 'package:food_jury/core/providers/ai_consent_provider.dart';
import 'package:food_jury/core/theme/theme.dart';
import 'package:food_jury/data/providers/verdict_provider.dart';
import 'package:food_jury/features/decision/data/models/food_option.dart';
import 'package:food_jury/features/decision/data/models/objective.dart';
import 'package:food_jury/features/decision/data/models/verdict.dart';
import 'package:food_jury/l10n/app_localizations.dart';

const taco = FoodOption(
  id: 'taco',
  name: 'Tacos al pastor',
  notes: 'Extra lime, please.',
);
const pizza = FoodOption(id: 'pizza', name: 'Pepperoni pizza');
const salad = FoodOption(id: 'salad', name: 'Garden salad');
final sampleVerdict = Verdict(
  id: 'sample',
  winner: taco,
  rankings: const [taco, pizza, salad],
  reasoning:
      'Smoky, a little spicy, and a whole lot of joy. These tacos take the crown. Case closed!',
  objective: Objective.fun,
  judgeTone: JudgeTone.enthusiastic,
  createdAt: DateTime(2026, 10, 11, 12),
);
final sampleHistory = [
  sampleVerdict,
  sampleVerdict.copyWith(
    id: 'sample-2',
    winner: pizza,
    createdAt: DateTime(2026, 10, 10, 18),
  ),
];

Future<void> loadDesignFonts() async {
  for (final entry in {
    'Bangers': ['assets/fonts/Bangers-Regular.ttf'],
    'Nunito': [
      'assets/fonts/Nunito-Regular.ttf',
      'assets/fonts/Nunito-Bold.ttf',
      'assets/fonts/Nunito-ExtraBold.ttf',
    ],
    'MaterialIcons': ['fonts/MaterialIcons-Regular.otf'],
  }.entries) {
    final loader = FontLoader(entry.key);
    for (final path in entry.value) {
      loader.addFont(
        path.startsWith('/')
            ? File(
                path,
              ).readAsBytes().then((bytes) => ByteData.sublistView(bytes))
            : rootBundle.load(path),
      );
    }
    await loader.load();
  }
}

class DinerHarness {
  final repaintKey = GlobalKey();
  final motionDisabled = ValueNotifier<bool>(true);
  late GoRouter router;
  late ProviderContainer container;

  Future<void> pump(
    WidgetTester tester, {
    String route = AppRouter.home,
    Object? extra,
    Size size = const Size(390, 844),
    double textScale = 1,
    String locale = 'en',
    bool dark = false,
    bool reducedMotion = true,
    bool aiConsent = true,
    List<Override> overrides = const [],
    List<Verdict>? history,
    Map<String, Object> preferences = const {},
  }) async {
    motionDisabled.value = reducedMotion;
    addTearDown(motionDisabled.dispose);
    Env.current = Environment.dev;
    SharedPreferences.setMockInitialValues({
      if (aiConsent) aiConsentPreferenceKey: aiConsentVersion,
      ...preferences,
    });
    tester.view.devicePixelRatio = 2;
    tester.view.physicalSize = size * 2;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    router = AppRouter.createRouter(
      initialLocation: route,
      initialExtra: extra,
    );
    final db = AppDatabase.forTesting(NativeDatabase.memory());
    addTearDown(db.close);
    container = ProviderContainer(
      overrides: [
        databaseProvider.overrideWithValue(db),
        recentVerdictsProvider.overrideWith(
          (ref) async => history ?? sampleHistory,
        ),
        verdictsProvider.overrideWith((ref) async => history ?? sampleHistory),
        ...overrides,
      ],
    );
    addTearDown(() {
      router.dispose();
      container.dispose();
    });
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: MaterialApp.router(
          debugShowCheckedModeBanner: false,
          theme: dark ? AppTheme.dark : AppTheme.light,
          locale: Locale(locale),
          supportedLocales: const [Locale('en'), Locale('es')],
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          routerConfig: router,
          builder: (context, child) => ValueListenableBuilder<bool>(
            valueListenable: motionDisabled,
            builder: (context, disabled, _) => MediaQuery(
              data: MediaQuery.of(context).copyWith(
                textScaler: TextScaler.linear(textScale),
                disableAnimations: disabled,
                accessibleNavigation: disabled,
              ),
              child: RepaintBoundary(key: repaintKey, child: child!),
            ),
          ),
        ),
      ),
    );
    await tester.pump();
    await tester.runAsync(() async {
      await Future<void>.delayed(const Duration(milliseconds: 120));
    });
    await tester.pump(const Duration(seconds: 1));
    await tester.pump();
  }

  Future<void> screenshot(WidgetTester tester, String name) async {
    if (!const bool.fromEnvironment('UPDATE_DESIGN_PREVIEWS')) return;
    // Image decoders run outside the fake widget-test clock. Paint their result
    // before capturing newly added option thumbnails.
    await tester.runAsync(() async {
      await Future<void>.delayed(const Duration(milliseconds: 120));
    });
    await tester.pump();
    await tester.runAsync(() async {
      final boundary =
          repaintKey.currentContext!.findRenderObject()!
              as RenderRepaintBoundary;
      final image = await boundary.toImage(pixelRatio: 2);
      final data = await image.toByteData(format: ui.ImageByteFormat.png);
      final file = File('design/verification/$name.png');
      await file.parent.create(recursive: true);
      await file.writeAsBytes(data!.buffer.asUint8List());
      image.dispose();
    });
  }
}

Future<void> scrollTo(WidgetTester tester, Finder finder) async {
  await tester.ensureVisible(finder);
  await tester.pump(const Duration(milliseconds: 400));
}
