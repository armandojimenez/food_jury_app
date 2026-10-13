import 'package:equatable/equatable.dart';

import '../../decision/data/models/food_option.dart';
import '../../decision/data/models/objective.dart';
import '../../lucky/data/decision_case.dart';

/// A resumable case, including incomplete cases that have no goal yet.
class CaseDraft extends Equatable {
  /// Takes an independent snapshot of user evidence.
  CaseDraft({required List<FoodOption> options, this.objective})
    : options = List.unmodifiable(options.map((option) => option.snapshot())) {
    if (options.length > 5 ||
        options.map((option) => option.id).toSet().length != options.length ||
        options.any((option) => option.name.trim().isEmpty)) {
      throw ArgumentError(
        'A draft supports up to five distinct named options.',
      );
    }
  }

  /// Copies a completed case into an editable draft.
  factory CaseDraft.fromCase(DecisionCase value) =>
      CaseDraft(options: value.options, objective: value.objective);

  /// Original order, notes, illustrations and actual photos.
  final List<FoodOption> options;

  /// Optional until the user chooses how the case should be judged.
  final Objective? objective;

  /// Whether there is anything useful to resume.
  bool get isEmpty => options.isEmpty && objective == null;

  @override
  List<Object?> get props => [options, objective];
}

/// A named lineup kept separately from historical verdicts.
class SavedCaseSet {
  /// Creates a reusable lineup from an immutable draft.
  const SavedCaseSet({
    required this.id,
    required this.name,
    required this.draft,
  });

  /// Stable local storage identifier.
  final String id;

  /// User-chosen name, such as Friday takeout.
  final String name;

  /// All original contenders and optional goal.
  final CaseDraft draft;
}

/// Reactive contents of the local case shelf.
class CaseShelf {
  /// Creates a shelf snapshot.
  const CaseShelf({this.draft, this.sets = const []});

  /// The most recently edited unfinished case.
  final CaseDraft? draft;

  /// Named lineups, most recently saved first.
  final List<SavedCaseSet> sets;
}
