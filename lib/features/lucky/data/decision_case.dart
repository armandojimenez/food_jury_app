import '../../decision/data/models/food_option.dart';
import '../../decision/data/models/objective.dart';

/// Original contender order and user intent, frozen before any decision.
class DecisionCase {
  DecisionCase({required List<FoodOption> options, required this.objective})
    : options = List.unmodifiable(options.map((option) => option.snapshot())) {
    if (options.length < 2 ||
        options.length > 5 ||
        options.map((o) => o.id).toSet().length != options.length ||
        options.any((o) => o.name.trim().isEmpty)) {
      throw ArgumentError('A case needs two to five distinct, named options.');
    }
  }
  final List<FoodOption> options;
  final Objective objective;
}

/// Each ritual draws once, with equal odds for every contender.
enum RandomMethod { wheel, ticket, cloche, coin }
