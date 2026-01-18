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
    this.bonus,
    this.bonusType,
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

  /// Optional bonus content (joke, fun fact, tip, story) based on judge personality.
  final String? bonus;

  /// Type of bonus content (joke, fun_fact, tip, story).
  final BonusType? bonusType;

  @override
  List<Object?> get props => [
    id,
    winner,
    rankings,
    reasoning,
    objective,
    judgeTone,
    createdAt,
    bonus,
    bonusType,
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
    String? bonus,
    BonusType? bonusType,
  }) {
    return Verdict(
      id: id ?? this.id,
      winner: winner ?? this.winner,
      rankings: rankings ?? this.rankings,
      reasoning: reasoning ?? this.reasoning,
      objective: objective ?? this.objective,
      judgeTone: judgeTone ?? this.judgeTone,
      createdAt: createdAt ?? this.createdAt,
      bonus: bonus ?? this.bonus,
      bonusType: bonusType ?? this.bonusType,
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

/// Type of bonus content the judge provides.
enum BonusType {
  /// A food-related joke.
  joke,

  /// An interesting food fact.
  funFact,

  /// A helpful food tip.
  tip,

  /// A short food-related story.
  story,
}

/// Extension methods for [BonusType].
extension BonusTypeExtension on BonusType {
  /// Display name for the bonus type.
  String get displayName {
    switch (this) {
      case BonusType.joke:
        return 'Judge\'s Joke';
      case BonusType.funFact:
        return 'Fun Fact';
      case BonusType.tip:
        return 'Pro Tip';
      case BonusType.story:
        return 'Story Time';
    }
  }

  /// Icon/emoji for the bonus type.
  String get icon {
    switch (this) {
      case BonusType.joke:
        return '😂';
      case BonusType.funFact:
        return '💡';
      case BonusType.tip:
        return '👨‍🍳';
      case BonusType.story:
        return '📖';
    }
  }
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
