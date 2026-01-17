import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../theme/theme.dart';

/// Objective selector chip (Fun, Healthy, Fit, Quick)
///
/// Features springy selection animation and retro styling when selected.
class ObjectiveChip extends StatefulWidget {
  const ObjectiveChip({
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.onTap,
    super.key,
  });

  final String label;
  final String icon; // Emoji
  final bool isSelected;
  final VoidCallback onTap;

  @override
  State<ObjectiveChip> createState() => _ObjectiveChipState();
}

class _ObjectiveChipState extends State<ObjectiveChip>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _bounceAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.9).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.3, curve: Curves.easeOut),
      ),
    );

    _bounceAnimation = Tween<double>(begin: 0.9, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.3, 1.0, curve: Curves.elasticOut),
      ),
    );
  }

  @override
  void didUpdateWidget(ObjectiveChip oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Trigger bounce animation when selection changes
    if (widget.isSelected && !oldWidget.isSelected) {
      _controller.forward(from: 0.0);
      HapticFeedback.lightImpact();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  double get _scale {
    if (_controller.value <= 0.3) {
      return _scaleAnimation.value;
    } else {
      return _bounceAnimation.value;
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return GestureDetector(
      onTap: widget.onTap,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Transform.scale(
            scale: _scale,
            child: child,
          );
        },
        child: AnimatedContainer(
          duration: AppDimensions.durationFast,
          curve: AppDimensions.curveSnappy,
          height: 44,
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimensions.spaceMd,
            vertical: AppDimensions.spaceSm,
          ),
          decoration: BoxDecoration(
            color: widget.isSelected ? colorScheme.primary : colorScheme.surface,
            borderRadius: BorderRadius.circular(22),
            border: Border.all(
              color: widget.isSelected ? colorScheme.secondary : colorScheme.outline,
              width: widget.isSelected
                  ? AppDimensions.borderThick
                  : AppDimensions.borderMedium,
            ),
            boxShadow: widget.isSelected
                ? [
                    // Retro shadow when selected
                    BoxShadow(
                      color: colorScheme.secondary,
                      blurRadius: 0,
                      offset: const Offset(2, 2),
                    ),
                    // Subtle glow
                    BoxShadow(
                      color: colorScheme.primary.withValues(alpha: 0.3),
                      blurRadius: 8,
                      spreadRadius: 0,
                    ),
                  ]
                : null,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                widget.icon,
                style: const TextStyle(fontSize: 18),
              ),
              const SizedBox(width: AppDimensions.spaceXs),
              Text(
                widget.label,
                style: AppTypography.labelMedium.copyWith(
                  color: widget.isSelected
                      ? AppColors.textInverse
                      : colorScheme.onSurface,
                  fontWeight:
                      widget.isSelected ? FontWeight.w700 : FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
