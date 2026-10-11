import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'app.dart';
import 'config/routes/app_router.dart';
import 'core/env/env.dart';
import 'core/providers/ai_service_provider.dart';
import 'core/services/mock_ai_service.dart';
import 'data/database/app_database.dart';
import 'data/providers/database_provider.dart';
import 'features/decision/data/models/food_option.dart';
import 'features/decision/data/models/objective.dart';
import 'features/decision/data/models/verdict.dart';

/// Offline design preview. Uses its own in-memory database and never changes
/// real saved cases or calls Firebase. Production entry points are unchanged.
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Env.current = Environment.dev;
  final db = AppDatabase.forTesting(NativeDatabase.memory());
  const tacos = FoodOption(id: 'preview-tacos', name: 'Tacos al pastor');
  const pizza = FoodOption(id: 'preview-pizza', name: 'Pepperoni pizza');
  final verdict = Verdict(
    id: 'preview-case',
    winner: tacos,
    rankings: const [tacos, pizza],
    reasoning:
        'Smoky, a little spicy, and a whole lot of joy. These tacos take the crown. Case closed!',
    objective: Objective.fun,
    judgeTone: JudgeTone.enthusiastic,
    createdAt: DateTime.now(),
  );
  await db.saveVerdict(verdict);
  await db.saveVerdict(
    verdict.copyWith(
      id: 'preview-case-2',
      winner: pizza,
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
    ),
  );
  const route = String.fromEnvironment(
    'PREVIEW_ROUTE',
    defaultValue: AppRouter.home,
  );
  AppRouter.router.go(
    route,
    extra: route == AppRouter.verdict
        ? VerdictRouteData(verdict: verdict, showRevealAnimation: true)
        : null,
  );
  runApp(
    ProviderScope(
      overrides: [
        databaseProvider.overrideWithValue(db),
        aiServiceProvider.overrideWithValue(MockAiService()),
      ],
      child: const FoodJuryApp(),
    ),
  );
}
