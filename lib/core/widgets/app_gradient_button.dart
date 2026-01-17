import 'package:flutter/material.dart';

import '../theme/theme.dart';

/// Enhanced primary button with gradient and glow effect.
///
/// This is a premium version of AppButton with visual polish:
/// - Gradient background (primary → primaryDark)
/// - Subtle glow effect
/// - Enhanced shadow
/// - Perfect for hero CTAs like "New Decision"
///
/// Example:
/// ```dart
/// AppGradientButton(
///   label: 'New Decision',
///   icon: Icons.gavel,
///   onPressed: () => handleAction(),
/// )
/// ```
class AppGradientButton extends StatefulWidget {
  const AppGradientButton({
    required this.label,
    required this.onPressed,
    this.icon,
    super.key,
  });

  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;

  @override
  State<AppGradientButton> createState() => _AppGradientButtonState();
}

class _AppGradientButtonState extends State<AppGradientButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isEnabled = widget.onPressed != null;

    return GestureDetector(
      onTapDown: isEnabled ? (_) => setState(() => _isPressed = true) : null,
      onTapUp: isEnabled ? (_) => setState(() => _isPressed = false) : null,
      onTapCancel: isEnabled ? () => setState(() => _isPressed = false) : null,
      onTap: widget.onPressed,
      child: AnimatedScale(
        scale: _isPressed ? 0.95 : 1.0,
        duration: AppDimensions.durationFast,
        curve: AppDimensions.curveSnappy,
        child: AnimatedContainer(
          duration: AppDimensions.durationFast,
          height: AppDimensions.buttonHeightLg, // Larger for impact!
          decoration: BoxDecoration(
            // Gradient background
            gradient: isEnabled
                ? const LinearGradient(
                    colors: [AppColors.primary, AppColors.primaryDark],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  )
                : null,
            color: isEnabled ? null : colorScheme.outline,
            borderRadius: AppDimensions.borderRadiusXl,
            border: Border.all(
              color: colorScheme.secondary, // Dark border
              width: AppDimensions.borderThick,
            ),
            // Hard retro shadow + gold glow for dramatic impact
            boxShadow: isEnabled && !_isPressed
                ? [
                    // Hard retro shadow (no blur!) - signature diner style
                    BoxShadow(
                      color: colorScheme.secondary,
                      blurRadius: 0,
                      offset: const Offset(4, 4),
                    ),
                    // Subtle gold glow for warmth
                    BoxShadow(
                      color: AppColors.pop.withValues(alpha: 0.3),
                      blurRadius: 16,
                      spreadRadius: 0,
                    ),
                  ]
                : [
                    const BoxShadow(
                      color: Color(0x1A000000),
                      blurRadius: 2,
                      offset: Offset(1, 1),
                    ),
                  ],
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppDimensions.spaceLg,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (widget.icon != null) ...[
                  Icon(
                    widget.icon,
                    color: isEnabled
                        ? AppColors.textInverse
                        : colorScheme.onSurfaceVariant,
                    size: AppDimensions.iconSizeMd,
                  ),
                  const SizedBox(width: AppDimensions.spaceSm),
                ],
                Text(
                  widget.label,
                  style: AppTypography.labelLarge.copyWith(
                    color: isEnabled
                        ? AppColors.textInverse
                        : colorScheme.onSurfaceVariant,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
