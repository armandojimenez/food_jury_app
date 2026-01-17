import 'package:flutter/material.dart';
import 'package:food_jury/core/theme/app_colors.dart';
import 'package:food_jury/core/theme/app_dimensions.dart';

enum AppButtonStyle { primary, secondary, ghost, destructive }

class AppButton extends StatefulWidget {
  final String label;
  final VoidCallback? onPressed;
  final AppButtonStyle style;
  final IconData? icon;
  final bool isLoading;
  final bool isFullWidth;

  const AppButton({
    super.key,
    required this.label,
    this.onPressed,
    this.style = AppButtonStyle.primary,
    this.icon,
    this.isLoading = false,
    this.isFullWidth = false,
  });

  @override
  State<AppButton> createState() => _AppButtonState();
}

class _AppButtonState extends State<AppButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: AppDimensions.durationFast,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _controller, curve: AppDimensions.curveSnappy),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) {
    if (widget.onPressed != null && !widget.isLoading) {
      _controller.forward();
    }
  }

  void _onTapUp(TapUpDetails details) {
    if (widget.onPressed != null && !widget.isLoading) {
      _controller.reverse();
      widget.onPressed?.call();
    }
  }

  void _onTapCancel() {
    if (widget.onPressed != null && !widget.isLoading) {
      _controller.reverse();
    }
  }

  Color _getBackgroundColor() {
    if (widget.onPressed == null) return Colors.grey.shade300;

    switch (widget.style) {
      case AppButtonStyle.primary:
        return AppColors.primary;
      case AppButtonStyle.secondary:
        return AppColors.pop;
      case AppButtonStyle.ghost:
        return Colors.transparent;
      case AppButtonStyle.destructive:
        return AppColors.error;
    }
  }

  Color _getForegroundColor() {
    if (widget.onPressed == null) return Colors.grey.shade500;

    switch (widget.style) {
      case AppButtonStyle.primary:
        return AppColors.textInverse;
      case AppButtonStyle.secondary:
        return AppColors.textPrimary;
      case AppButtonStyle.ghost:
        return AppColors.primary;
      case AppButtonStyle.destructive:
        return AppColors.textInverse;
    }
  }

  Border? _getBorder() {
    if (widget.style == AppButtonStyle.ghost && widget.onPressed != null) {
      return Border.all(
        color: AppColors.primary,
        width: AppDimensions.borderMedium,
      );
    }
    return null;
  }

  List<BoxShadow> _getShadows() {
    if (widget.onPressed == null || widget.style == AppButtonStyle.ghost) {
      return [];
    }
    return AppDimensions.shadowRetroSm;
  }

  @override
  Widget build(BuildContext context) {
    final child = Container(
      height: AppDimensions.buttonHeightMd,
      constraints: const BoxConstraints(minWidth: 120),
      decoration: BoxDecoration(
        color: _getBackgroundColor(),
        borderRadius: AppDimensions.borderRadiusXl, // Pill shape
        border: _getBorder(),
        boxShadow: _getShadows(),
      ),
      padding: const EdgeInsets.symmetric(horizontal: AppDimensions.spaceLg),
      alignment: Alignment.center,
      child: widget.isLoading
          ? SizedBox(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: _getForegroundColor(),
              ),
            )
          : Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (widget.icon != null) ...[
                  Icon(
                    widget.icon,
                    size: AppDimensions.iconSizeSm,
                    color: _getForegroundColor(),
                  ),
                  const SizedBox(width: AppDimensions.spaceSm),
                ],
                Text(
                  widget.label,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: _getForegroundColor(),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
    );

    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: widget.isFullWidth
            ? SizedBox(width: double.infinity, child: child)
            : child,
      ),
    );
  }
}
