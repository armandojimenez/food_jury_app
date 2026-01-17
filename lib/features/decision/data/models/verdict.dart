import 'package:equatable/equatable.dart';

import 'food_option.dart';
import 'objective.dart';

/// Represents the result of a food decision verdict.
///
/// Contains the winner, rankings, reasoning, and metadata about the decision.
class Verdict extends Equatable {
  /// Creates a verdict.
  const Verdict({
    required this.id,
    required this.winner,
    required this.rankings,
    required this.reasoning,
    required this.objective,
    required this.judgeTone,
    required this.createdAt,
  });

  /// Unique identifier for this verdict.
  final String id;

  /// The winning food option.
  final FoodOption winner;

  /// All options ranked from best (index 0) to worst.
  final List<FoodOption> rankings;

  /// Judge Bite's reasoning for the verdict.
  final String reasoning;

  /// The objective used for this decision.
  final Objective objective;

  /// The judge's personality tone used.
  final JudgeTone judgeTone;

  /// When this verdict was created.
  final DateTime createdAt;

  @override
  List<Object?> get props => [
        id,
        winner,
        rankings,
        reasoning,
        objective,
        judgeTone,
        createdAt,
      ];

  /// Creates a copy with optional overrides.
  Verdict copyWith({
    String? id,
    FoodOption? winner,
    List<FoodOption>? rankings,
    String? reasoning,
    Objective? objective,
    JudgeTone? judgeTone,
    DateTime? createdAt,
  }) {
    return Verdict(
      id: id ?? this.id,
      winner: winner ?? this.winner,
      rankings: rankings ?? this.rankings,
      reasoning: reasoning ?? this.reasoning,
      objective: objective ?? this.objective,
      judgeTone: judgeTone ?? this.judgeTone,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

/// Judge Bite's personality tones.
enum JudgeTone {
  /// Formal, authoritative, dry wit.
  stern,

  /// Playful, opinionated, witty.
  sassy,

  /// Excited, celebratory.
  enthusiastic,

  /// Casual, relaxed.
  chill,
}

/// Extension methods for [JudgeTone].
extension JudgeToneExtension on JudgeTone {
  /// Display name for the tone.
  String get displayName {
    switch (this) {
      case JudgeTone.stern:
        return 'Stern & Fair';
      case JudgeTone.sassy:
        return 'Sassy';
      case JudgeTone.enthusiastic:
        return 'Enthusiastic';
      case JudgeTone.chill:
        return 'Chill';
    }
  }

  /// Icon/emoji for the tone.
  String get icon {
    switch (this) {
      case JudgeTone.stern:
        return '\u2696\uFE0F'; // Balance scale
      case JudgeTone.sassy:
        return '\uD83D\uDE0F'; // Smirk
      case JudgeTone.enthusiastic:
        return '\uD83C\uDF89'; // Party
      case JudgeTone.chill:
        return '\uD83D\uDE0E'; // Sunglasses
    }
  }

  /// Sample phrase showing the tone's style.
  String get samplePhrase {
    switch (this) {
      case JudgeTone.stern:
        return 'The court has deliberated...';
      case JudgeTone.sassy:
        return 'Listen, I\'ve seen your choices...';
      case JudgeTone.enthusiastic:
        return 'OH WOW! This is exciting!';
      case JudgeTone.chill:
        return 'So like, here\'s the deal...';
    }
  }
}
