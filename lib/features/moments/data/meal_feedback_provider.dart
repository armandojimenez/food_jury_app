import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/database/app_database.dart';
import '../../../data/providers/database_provider.dart';

/// Feedback shares the verdict database, including isolated preview overrides.
final mealFeedbackProvider = StreamProvider.family<MealFeedbackEntry?, String>(
  (ref, verdictId) => ref.watch(databaseProvider).watchMealFeedback(verdictId),
);

/// One stream for archive badges, rather than a query for each history row.
final allMealFeedbackProvider = StreamProvider<List<MealFeedbackEntry>>(
  (ref) => ref.watch(databaseProvider).watchAllMealFeedback(),
);
