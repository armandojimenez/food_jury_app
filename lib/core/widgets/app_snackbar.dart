import 'package:flutter/material.dart';

import '../theme/theme.dart';
import 'diner_motion.dart';

/// Retro diner style snackbar system
class AppSnackbar {
  /// Show success feedback with a checkmark.
  static void showSuccess(
    BuildContext context, {
    required String message,
    Duration duration = const Duration(seconds: 3),
  }) {
    _show(
      context,
      message: message,
      icon: Icons.check_circle,
      duration: duration,
    );
  }

  /// Show error feedback with an error icon.
  static void showError(
    BuildContext context, {
    required String message,
    Duration duration = const Duration(seconds: 4),
  }) {
    _show(context, message: message, icon: Icons.error, duration: duration);
  }

  /// Show warning feedback with a warning icon.
  static void showWarning(
    BuildContext context, {
    required String message,
    Duration duration = const Duration(seconds: 3),
  }) {
    _show(context, message: message, icon: Icons.warning, duration: duration);
  }

  /// Show informational feedback.
  static void showInfo(
    BuildContext context, {
    required String message,
    Duration duration = const Duration(seconds: 3),
  }) {
    _show(context, message: message, icon: Icons.info, duration: duration);
  }

  /// Show verdict feedback with a gavel.
  static void showVerdict(
    BuildContext context, {
    required String message,
    Duration duration = const Duration(seconds: 4),
  }) {
    _show(context, message: message, icon: Icons.gavel, duration: duration);
  }

  /// Internal method to show snackbar with retro styling
  static void _show(
    BuildContext context, {
    required String message,
    required IconData icon,
    required Duration duration,
  }) {
    final scheme = Theme.of(context).colorScheme;
    final snackBar = SnackBar(
      content: Row(
        children: [
          Icon(icon, color: scheme.onSurface),
          const SizedBox(width: AppDimensions.spaceMd),
          Expanded(
            child: Text(
              message,
              style: TextStyle(
                color: scheme.onSurface,
                fontFamily: AppTypography.bodyFont,
                fontSize: AppTypography.bodyLarge.fontSize,
              ),
            ),
          ),
        ],
      ),
      backgroundColor: scheme.surface,
      elevation: 0,
      behavior: SnackBarBehavior.floating,
      duration: duration,
      margin: const EdgeInsets.all(AppDimensions.spaceMd),
      padding: const EdgeInsets.all(AppDimensions.spaceMd),
      shape: RoundedRectangleBorder(
        borderRadius: AppDimensions.borderRadiusMd,
        side: BorderSide(color: scheme.onSurface, width: DinerTokens.border),
      ),
    );
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        snackBar,
        snackBarAnimationStyle: reduceDinerMotion(context)
            ? AnimationStyle.noAnimation
            : const AnimationStyle(duration: DinerTokens.entrance),
      );
  }
}
