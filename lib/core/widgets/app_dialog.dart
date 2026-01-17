import 'package:flutter/material.dart';

import '../theme/theme.dart';
import 'app_button.dart';

/// Retro diner style dialog system
class AppDialog {
  /// Show confirmation dialog
  static Future<bool> showConfirmation(
    BuildContext context, {
    required String title,
    required String message,
    String confirmText = 'Confirm',
    String cancelText = 'Cancel',
    IconData? icon,
  }) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => _AppDialogWidget(
        title: title,
        message: message,
        icon: icon,
        actions: [
          AppSecondaryButton(
            onPressed: () => Navigator.of(context).pop(false),
            label: cancelText,
          ),
          AppButton(
            onPressed: () => Navigator.of(context).pop(true),
            label: confirmText,
            size: AppButtonSize.small,
          ),
        ],
      ),
    );
    return result ?? false;
  }

  /// Show alert dialog (single button)
  static Future<void> showAlert(
    BuildContext context, {
    required String title,
    required String message,
    String buttonText = 'Got it',
    IconData? icon,
  }) async {
    await showDialog(
      context: context,
      builder: (context) => _AppDialogWidget(
        title: title,
        message: message,
        icon: icon,
        actions: [
          AppButton(
            onPressed: () => Navigator.of(context).pop(),
            label: buttonText,
            size: AppButtonSize.small,
          ),
        ],
      ),
    );
  }

  /// Show Judge's verdict dialog (special styling)
  static Future<void> showVerdict(
    BuildContext context, {
    required String title,
    required String message,
  }) async {
    await showDialog(
      context: context,
      builder: (context) => _VerdictDialog(title: title, message: message),
    );
  }

  /// Show custom dialog
  static Future<T?> showCustom<T>(
    BuildContext context, {
    required Widget child,
  }) async {
    return showDialog<T>(
      context: context,
      builder: (context) =>
          Dialog(backgroundColor: Colors.transparent, child: child),
    );
  }
}

/// Standard dialog widget with retro styling
class _AppDialogWidget extends StatefulWidget {
  const _AppDialogWidget({
    required this.title,
    required this.message,
    required this.actions,
    this.icon,
  });

  final String title;
  final String message;
  final IconData? icon;
  final List<Widget> actions;

  @override
  State<_AppDialogWidget> createState() => _AppDialogWidgetState();
}

class _AppDialogWidgetState extends State<_AppDialogWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

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

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: AppDimensions.curveSnappy),
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
    return FadeTransition(
      opacity: _fadeAnimation,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            constraints: const BoxConstraints(maxWidth: 400),
            padding: const EdgeInsets.all(AppDimensions.spaceLg),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: AppDimensions.borderRadiusMd,
              border: Border.all(
                color: AppColors.accent,
                width: AppDimensions.borderThick,
              ),
              boxShadow: AppDimensions.shadowXl,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Icon (if provided)
                if (widget.icon != null) ...[
                  Container(
                    padding: const EdgeInsets.all(AppDimensions.spaceMd),
                    decoration: BoxDecoration(
                      color: AppColors.primaryLight,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      widget.icon,
                      size: AppDimensions.iconSizeXl,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(height: AppDimensions.spaceMd),
                ],

                // Title
                Text(
                  widget.title,
                  style: AppTypography.displaySmall,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppDimensions.spaceMd),

                // Message
                Text(
                  widget.message,
                  style: AppTypography.bodyLarge.copyWith(
                    color: AppColors.textSecondary,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppDimensions.spaceLg),

                // Actions
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    for (int i = 0; i < widget.actions.length; i++) ...[
                      if (i > 0) const SizedBox(width: AppDimensions.spaceSm),
                      widget.actions[i],
                    ],
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Special verdict dialog with dramatic styling
class _VerdictDialog extends StatelessWidget {
  const _VerdictDialog({required this.title, required this.message});

  final String title;
  final String message;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Transform.rotate(
        angle: -AppDimensions.verdictTiltAngle,
        child: Container(
          constraints: const BoxConstraints(maxWidth: 400),
          padding: const EdgeInsets.all(AppDimensions.spaceXl),
          decoration: BoxDecoration(
            gradient: AppColors.verdictGradient,
            borderRadius: AppDimensions.borderRadiusMd,
            border: Border.all(
              color: AppColors.pop,
              width: AppDimensions.borderChunky,
            ),
            boxShadow: AppDimensions.shadowXl,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Gavel icon
              const Icon(
                Icons.gavel,
                size: AppDimensions.iconSizeXl * 1.5,
                color: AppColors.pop,
              ),
              const SizedBox(height: AppDimensions.spaceMd),

              // Title
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppDimensions.spaceMd,
                  vertical: AppDimensions.spaceSm,
                ),
                decoration: BoxDecoration(
                  color: AppColors.pop,
                  borderRadius: AppDimensions.borderRadiusSm,
                ),
                child: Text(
                  title.toUpperCase(),
                  style: AppTypography.displaySmall.copyWith(
                    color: AppColors.accent,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: AppDimensions.spaceLg),

              // Message in Judge's voice
              Text(
                message,
                style: AppTypography.judgeSpeech.copyWith(
                  color: AppColors.textInverse,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppDimensions.spaceLg),

              // Close button
              AppButton(
                onPressed: () => Navigator.of(context).pop(),
                label: 'Understood',
                size: AppButtonSize.small,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Bottom sheet helper
class AppBottomSheet {
  /// Show retro styled bottom sheet
  static Future<T?> show<T>(
    BuildContext context, {
    required Widget child,
    bool isDismissible = true,
  }) {
    return showModalBottomSheet<T>(
      context: context,
      backgroundColor: Colors.transparent,
      isDismissible: isDismissible,
      isScrollControlled: true,
      builder: (context) => _BottomSheetWrapper(child: child),
    );
  }
}

/// Bottom sheet wrapper with retro styling
class _BottomSheetWrapper extends StatelessWidget {
  const _BottomSheetWrapper({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(AppDimensions.radiusLg),
          topRight: Radius.circular(AppDimensions.radiusLg),
        ),
        border: const Border(
          top: BorderSide(
            color: AppColors.accent,
            width: AppDimensions.borderThick,
          ),
          left: BorderSide(
            color: AppColors.accent,
            width: AppDimensions.borderThick,
          ),
          right: BorderSide(
            color: AppColors.accent,
            width: AppDimensions.borderThick,
          ),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Drag handle
          const SizedBox(height: AppDimensions.spaceSm),
          Container(
            width: AppDimensions.dragHandleWidth,
            height: AppDimensions.dragHandleHeight,
            decoration: BoxDecoration(
              color: AppColors.border,
              borderRadius: BorderRadius.circular(
                AppDimensions.dragHandleHeight / 2,
              ),
            ),
          ),
          const SizedBox(height: AppDimensions.spaceMd),

          // Content
          child,
        ],
      ),
    );
  }
}
