import 'dart:convert';
import 'dart:developer' as developer;

import 'package:drift/native.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app.dart';
import 'config/routes/app_router.dart';
import 'core/env/env.dart';
import 'core/providers/ai_service_provider.dart';
import 'core/providers/ai_consent_provider.dart';
import 'core/services/mock_ai_service.dart';
import 'data/database/app_database.dart';
import 'data/providers/database_provider.dart';
import 'features/decision/data/models/food_option.dart';
import 'features/decision/data/models/objective.dart';
import 'features/decision/data/models/verdict.dart';
import 'features/lucky/data/decision_case.dart';
import 'features/lucky/presentation/lucky_draw_screen.dart';

/// Offline design preview. Its in-memory cases never touch real case history.
/// Debug service navigation exists only in this entry point for native QA.
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Env.current = Environment.dev;
  final db = AppDatabase.forTesting(NativeDatabase.memory());
  const options = [
    FoodOption(id: 'pizza', name: 'Pizza', illustrationId: 'pizza'),
    FoodOption(
      id: 'tacos',
      name: 'Tacos',
      illustrationId: 'tacos',
      notes: 'Extra lime, please.',
    ),
    FoodOption(id: 'burger', name: 'Burger', illustrationId: 'burger'),
    FoodOption(id: 'salad', name: 'Garden salad', illustrationId: 'salad'),
  ];
  final verdict = Verdict(
    id: 'preview-case',
    winner: options[1],
    rankings: [options[1], options[0], options[2], options[3]],
    contenders: options,
    reasoning:
        'Smoky, a little spicy, and a whole lot of joy. These tacos take the crown. Case closed!',
    objective: Objective.fun,
    judgeTone: JudgeTone.stern,
    createdAt: DateTime.now(),
  );
  final caseData = DecisionCase(options: options, objective: Objective.fun);
  Verdict lucky(RandomMethod method) => verdict
      .copyWith(
        id: 'preview-${method.name}',
        rankings: const [],
        reasoning: '',
        contenders: method == RandomMethod.coin
            ? options.take(2).toList()
            : options,
        random: RandomRuling(
          method: method,
          quoteId: 'preview-quote',
          quote: switch (method) {
            RandomMethod.wheel => 'The wheel has spoken. Pass the salsa.',
            RandomMethod.ticket => 'Your number is up. Dinner is served.',
            RandomMethod.cloche => 'A little suspense. A lot of dinner.',
            RandomMethod.coin => 'Two sides. One dinner. Case closed.',
          },
          locale: 'en',
          catalogVersion: 1,
        ),
      )
      .snapshot();
  await db.saveVerdict(verdict);
  await db.saveVerdict(lucky(RandomMethod.wheel));

  void show(String screen) {
    final method = RandomMethod.values
        .where((m) => m.name == screen)
        .firstOrNull;
    final route = method != null
        ? AppRouter.draw
        : switch (screen) {
            'methods' => AppRouter.methods,
            'library' => AppRouter.foodLibrary,
            'lucky' => AppRouter.verdict,
            'new' => AppRouter.newDecision,
            'plus' => AppRouter.plus,
            'history' => AppRouter.history,
            'settings' => AppRouter.settings,
            'about' => AppRouter.aboutDeveloper,
            'home' => AppRouter.home,
            'welcome' => AppRouter.onboarding,
            'jury' => AppRouter.jury,
            _ => screen,
          };
    AppRouter.router.go(
      route,
      extra: method != null
          ? DrawRouteData(verdict: lucky(method))
          : route == AppRouter.methods || route == AppRouter.newDecision
          ? caseData
          : route == AppRouter.verdict
          ? VerdictRouteData(
              verdict: screen == 'lucky' ? lucky(RandomMethod.wheel) : verdict,
              showRevealAnimation: screen != 'lucky',
            )
          : null,
    );
  }

  if (kDebugMode) {
    developer.registerExtension('ext.foodjury.preview', (_, parameters) async {
      show(parameters['screen'] ?? 'home');
      return developer.ServiceExtensionResponse.result(
        jsonEncode({'ok': true}),
      );
    });
  }
  show(const String.fromEnvironment('PREVIEW_ROUTE', defaultValue: 'home'));
  runApp(
    ProviderScope(
      overrides: [
        databaseProvider.overrideWithValue(db),
        aiConsentStoreProvider.overrideWithValue(MemoryAiConsentStore()),
        aiServiceProvider.overrideWithValue(MockAiService()),
      ],
      child: const FoodJuryApp(
        locale: Locale(
          String.fromEnvironment('PREVIEW_LOCALE', defaultValue: 'en'),
        ),
      ),
    ),
  );
}
