import 'package:flutter/material.dart';

import '../../../../core/utils/l10n_extensions.dart';

/// Represents the user's goal for their food decision.
enum Objective {
  /// Looking for a fun, indulgent choice.
  fun,

  /// Looking for a healthy option.
  healthy,

  /// Looking for a fitness-oriented choice.
  fit,

  /// Looking for a quick meal.
  quick;

  /// Gets the localized label for this objective.
  String getLabel(BuildContext context) {
    switch (this) {
      case Objective.fun:
        return context.l10n.objective_fun;
      case Objective.healthy:
        return context.l10n.objective_healthy;
      case Objective.fit:
        return context.l10n.objective_fit;
      case Objective.quick:
        return context.l10n.objective_quick;
    }
  }

  /// Gets the icon emoji for this objective.
  String get icon {
    switch (this) {
      case Objective.fun:
        return '🎉';
      case Objective.healthy:
        return '🥬';
      case Objective.fit:
        return '💪';
      case Objective.quick:
        return '⚡';
    }
  }

  /// Gets the color associated with this objective.
  Color get color {
    switch (this) {
      case Objective.fun:
        return const Color(0xFF5C9EFF); // Info blue
      case Objective.healthy:
        return const Color(0xFF4CAF50); // Success green
      case Objective.fit:
        return const Color(0xFFFFB547); // Warning yellow
      case Objective.quick:
        return const Color(0xFFFF6B35); // Primary orange
    }
  }
}
