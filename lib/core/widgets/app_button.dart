import 'package:flutter/material.dart';

import '../theme/theme.dart';

/// Primary button for major CTAs
/// Features: Pill shape, orange fill, bouncy interaction
class AppButton extends StatefulWidget {
  const AppButton({
    required this.onPressed,
    required this.label,
    this.icon,
    this.size = AppButtonSize.medium,
    this.isLoading = false,
    super.key,
  });

  final VoidCallback? onPressed;
  final String label;
  final IconData? icon;
  final AppButtonSize size;
  final bool isLoading;

  @override
  State<AppButton> createState() => _AppButtonState();
}

class _AppButtonState extends State<AppButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: AppDimensions.durationFast,
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTapDown(TapDownDetails details) {
    if (widget.onPressed != null && !widget.isLoading) {
      _controller.forward();
    }
  }

  void _handleTapUp(TapUpDetails details) {
    _resetPress();
  }

  void _handleTapCancel() {
    _resetPress();
  }

  void _resetPress() {
    _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final bool isDisabled = widget.onPressed == null || widget.isLoading;
    final height = widget.size.height;
    final fontSize = widget.size.fontSize;
    final padding = widget.size.padding;

    return GestureDetector(
      onTapDown: _handleTapDown,
      onTapUp: _handleTapUp,
      onTapCancel: _handleTapCancel,
      onTap: widget.onPressed,
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(scale: _scaleAnimation.value, child: child);
        },
        child: Container(
          height: height,
          padding: padding,
          decoration: BoxDecoration(
            gradient: isDisabled ? null : AppColors.primaryGradient,
            color: isDisabled ? colorScheme.outline : null,
            borderRadius: BorderRadius.circular(height / 2),
            border: Border.all(
              color: isDisabled ? colorScheme.outline : colorScheme.secondary,
              width: AppDimensions.borderThick,
            ),
            boxShadow: isDisabled ? null : AppDimensions.shadowRetroSm,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (widget.isLoading)
                SizedBox(
                  width: fontSize,
                  height: fontSize,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: const AlwaysStoppedAnimation<Color>(
                      AppColors.textInverse,
                    ),
                  ),
                )
              else if (widget.icon != null) ...[
                Icon(
                  widget.icon,
                  size: fontSize,
                  color: isDisabled
                      ? colorScheme.onSurfaceVariant
                      : AppColors.textInverse,
                ),
                const SizedBox(width: AppDimensions.spaceSm),
              ],
              Text(
                widget.label.toUpperCase(),
                style: TextStyle(
                  fontFamily: AppTypography.bodyFont,
                  fontSize: fontSize,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.5,
                  color: isDisabled
                      ? colorScheme.onSurfaceVariant
                      : AppColors.textInverse,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Secondary button for supporting actions
/// Features: Outlined style, navy border, press animation
class AppSecondaryButton extends StatefulWidget {
  const AppSecondaryButton({
    required this.onPressed,
    required this.label,
    this.icon,
    this.size = AppButtonSize.medium,
    super.key,
  });

  final VoidCallback? onPressed;
  final String label;
  final IconData? icon;
  final AppButtonSize size;

  @override
  State<AppSecondaryButton> createState() => _AppSecondaryButtonState();
}

class _AppSecondaryButtonState extends State<AppSecondaryButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: AppDimensions.durationFast,
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTapDown(TapDownDetails details) {
    if (widget.onPressed != null) {
      _controller.forward();
    }
  }

  void _handleTapUp(TapUpDetails details) {
    _controller.reverse();
  }

  void _handleTapCancel() {
    _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final bool isDisabled = widget.onPressed == null;
    final height = widget.size.height;
    final fontSize = widget.size.fontSize;
    final padding = widget.size.padding;

    return GestureDetector(
      onTapDown: _handleTapDown,
      onTapUp: _handleTapUp,
      onTapCancel: _handleTapCancel,
      onTap: widget.onPressed,
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(scale: _scaleAnimation.value, child: child);
        },
        child: Container(
          height: height,
          padding: padding,
          decoration: BoxDecoration(
            color: colorScheme.surface,
            borderRadius: BorderRadius.circular(height / 2),
            border: Border.all(
              color: isDisabled ? colorScheme.outline : colorScheme.secondary,
              width: AppDimensions.borderThick,
            ),
            boxShadow: isDisabled ? null : AppDimensions.shadowRetroSm,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (widget.icon != null) ...[
                Icon(
                  widget.icon,
                  size: fontSize,
                  color: isDisabled
                      ? colorScheme.onSurfaceVariant
                      : colorScheme.secondary,
                ),
                const SizedBox(width: AppDimensions.spaceSm),
              ],
              Text(
                widget.label,
                style: TextStyle(
                  fontFamily: AppTypography.bodyFont,
                  fontSize: fontSize,
                  fontWeight: FontWeight.w600,
                  color: isDisabled
                      ? colorScheme.onSurfaceVariant
                      : colorScheme.secondary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Icon button for utility actions
class AppIconButton extends StatelessWidget {
  const AppIconButton({
    required this.icon,
    required this.onPressed,
    this.color,
    super.key,
  });

  final IconData icon;
  final VoidCallback? onPressed;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return IconButton(
      icon: Icon(icon),
      onPressed: onPressed,
      color: color ?? colorScheme.secondary,
      iconSize: AppDimensions.iconSizeMd,
    );
  }
}

/// Button size presets
enum AppButtonSize {
  small(
    height: AppDimensions.buttonHeightSm,
    fontSize: 14,
    padding: EdgeInsets.symmetric(horizontal: 20),
  ),
  medium(
    height: AppDimensions.buttonHeightMd,
    fontSize: 16,
    padding: EdgeInsets.symmetric(horizontal: 32),
  ),
  large(
    height: AppDimensions.buttonHeightLg,
    fontSize: 18,
    padding: EdgeInsets.symmetric(horizontal: 40),
  );

  const AppButtonSize({
    required this.height,
    required this.fontSize,
    required this.padding,
  });

  final double height;
  final double fontSize;
  final EdgeInsets padding;
}
