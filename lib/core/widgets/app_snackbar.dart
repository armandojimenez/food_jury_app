import 'package:flutter/material.dart';

import '../theme/theme.dart';

/// Retro diner style snackbar system
class AppSnackbar {
  /// Show success snackbar (green with checkmark)
  static void showSuccess(
    BuildContext context, {
    required String message,
    Duration duration = const Duration(seconds: 3),
  }) {
    _show(
      context,
      message: message,
      icon: Icons.check_circle,
      backgroundColor: AppColors.success,
      duration: duration,
    );
  }

  /// Show error snackbar (red with X)
  static void showError(
    BuildContext context, {
    required String message,
    Duration duration = const Duration(seconds: 4),
  }) {
    _show(
      context,
      message: message,
      icon: Icons.error,
      backgroundColor: AppColors.error,
      duration: duration,
    );
  }

  /// Show warning snackbar (orange with warning icon)
  static void showWarning(
    BuildContext context, {
    required String message,
    Duration duration = const Duration(seconds: 3),
  }) {
    _show(
      context,
      message: message,
      icon: Icons.warning,
      backgroundColor: AppColors.warning,
      duration: duration,
    );
  }

  /// Show info snackbar (blue with info icon)
  static void showInfo(
    BuildContext context, {
    required String message,
    Duration duration = const Duration(seconds: 3),
  }) {
    _show(
      context,
      message: message,
      icon: Icons.info,
      backgroundColor: AppColors.info,
      duration: duration,
    );
  }

  /// Show Judge Bite verdict snackbar (special orange with gavel)
  static void showVerdict(
    BuildContext context, {
    required String message,
    Duration duration = const Duration(seconds: 4),
  }) {
    _show(
      context,
      message: message,
      icon: Icons.gavel,
      backgroundColor: AppColors.primary,
      duration: duration,
    );
  }

  /// Internal method to show snackbar with retro styling
  static void _show(
    BuildContext context, {
    required String message,
    required IconData icon,
    required Color backgroundColor,
    required Duration duration,
  }) {
    final snackBar = SnackBar(
      content: _SnackbarContent(message: message, icon: icon),
      backgroundColor: Colors.transparent,
      elevation: 0,
      behavior: SnackBarBehavior.floating,
      duration: duration,
      margin: const EdgeInsets.all(AppDimensions.spaceMd),
      padding: EdgeInsets.zero,
      shape: RoundedRectangleBorder(borderRadius: AppDimensions.borderRadiusMd),
    );

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(snackBar);
  }
}

/// Custom snackbar content with retro styling
class _SnackbarContent extends StatefulWidget {
  const _SnackbarContent({required this.message, required this.icon});

  final String message;
  final IconData icon;

  @override
  State<_SnackbarContent> createState() => _SnackbarContentState();
}

class _SnackbarContentState extends State<_SnackbarContent>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: AppDimensions.durationMedium,
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: AppDimensions.curveBouncy),
    );

    _slideAnimation = Tween<Offset>(begin: const Offset(0, 1), end: Offset.zero)
        .animate(
          CurvedAnimation(
            parent: _controller,
            curve: AppDimensions.curveSnappy,
          ),
        );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _slideAnimation,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Container(
          padding: const EdgeInsets.all(AppDimensions.spaceMd),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: AppDimensions.borderRadiusMd,
            border: Border.all(
              color: AppColors.accent,
              width: AppDimensions.borderThick,
            ),
            boxShadow: AppDimensions.shadowRetro,
          ),
          child: Row(
            children: [
              // Icon with background
              Container(
                padding: const EdgeInsets.all(AppDimensions.spaceSm),
                decoration: BoxDecoration(
                  color: AppColors.primaryLight,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  widget.icon,
                  color: AppColors.primary,
                  size: AppDimensions.iconSizeMd,
                ),
              ),
              const SizedBox(width: AppDimensions.spaceMd),

              // Message
              Expanded(
                child: Text(
                  widget.message,
                  style: AppTypography.bodyLarge.copyWith(
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
