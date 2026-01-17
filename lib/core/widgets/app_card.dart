import 'package:flutter/material.dart';
import 'package:food_jury/core/theme/app_colors.dart';
import 'package:food_jury/core/theme/app_dimensions.dart';

class AppCard extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry? padding;
  final Color? color;
  final Border? border;
  final bool animateOnTap;

  const AppCard({
    super.key,
    required this.child,
    this.onTap,
    this.padding,
    this.color,
    this.border,
    this.animateOnTap = true,
  });

  @override
  State<AppCard> createState() => _AppCardState();
}

class _AppCardState extends State<AppCard> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<Offset> _slideAnimation;
  late final Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: AppDimensions.durationFast,
    );

    // Slight lift up
    _slideAnimation =
        Tween<Offset>(begin: Offset.zero, end: const Offset(0, -2)).animate(
          CurvedAnimation(
            parent: _controller,
            curve: AppDimensions.curveSnappy,
          ),
        );
    // Slight scale up for "lift" effect
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.02).animate(
      CurvedAnimation(parent: _controller, curve: AppDimensions.curveSnappy),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTapDown(TapDownDetails details) {
    if (widget.onTap != null && widget.animateOnTap) {
      _controller.forward();
    }
  }

  void _handleTapUp(TapUpDetails details) {
    if (widget.onTap != null && widget.animateOnTap) {
      _controller.reverse();
      widget.onTap?.call();
    }
  }

  void _handleTapCancel() {
    if (widget.onTap != null && widget.animateOnTap) {
      _controller.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    final card = Container(
      decoration: BoxDecoration(
        color: widget.color ?? AppColors.surface,
        borderRadius: AppDimensions.borderRadiusMd,
        border: widget.border,
        boxShadow: widget.onTap != null
            ? AppDimensions
                  .shadowMd // Slightly more elevated if interactive
            : AppDimensions.shadowSm,
      ),
      padding: widget.padding ?? const EdgeInsets.all(AppDimensions.spaceMd),
      clipBehavior: Clip.antiAlias, // Ensures clean corners for child content
      child: widget.child,
    );

    if (widget.onTap == null) {
      return card;
    }

    return GestureDetector(
      onTapDown: _handleTapDown,
      onTapUp: _handleTapUp,
      onTapCancel: _handleTapCancel,
      child: SlideTransition(
        position:
            _slideAnimation, // Use slide for lift vs scale for button press
        child: ScaleTransition(scale: _scaleAnimation, child: card),
      ),
    );
  }
}
