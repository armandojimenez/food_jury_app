import 'dart:ui';

import '../../features/decision/data/models/food_option.dart';
import '../../features/decision/data/models/objective.dart';
import '../../features/decision/data/models/verdict.dart';

/// Abstract interface for AI verdict generation.
///
/// Implementations can use mock data or real AI services.
abstract class AiService {
  /// Generates a verdict for the given food options.
  ///
  /// [options] - List of 2-5 food options to judge
  /// [objective] - The user's goal (fun, healthy, fit, quick)
  /// [tone] - Judge Bite's personality tone
  /// [locale] - The user's locale for response language
  ///
  /// Returns a [Verdict] with winner, rankings, and reasoning.
  /// Throws [AiServiceException] on failure.
  Future<Verdict> generateVerdict({
    required List<FoodOption> options,
    required Objective objective,
    required JudgeTone tone,
    required Locale locale,
  });
}

/// Exception thrown when AI service fails.
class AiServiceException implements Exception {
  const AiServiceException(this.message, [this.cause]);

  final String message;
  final Object? cause;

  @override
  String toString() => 'AiServiceException: $message';
}
