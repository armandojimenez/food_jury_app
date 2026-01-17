import 'package:flutter/material.dart';

import '../theme/theme.dart';

/// Objective selector chip (Fun, Healthy, Fit, Quick)
class ObjectiveChip extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: AppDimensions.durationFast,
        curve: AppDimensions.curveSnappy,
        height: 40,
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.spaceMd,
          vertical: AppDimensions.spaceSm,
        ),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : AppColors.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? AppColors.primaryDark : AppColors.accent,
            width: AppDimensions.borderMedium,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(icon, style: const TextStyle(fontSize: 20)),
            const SizedBox(width: AppDimensions.spaceXs),
            Text(
              label,
              style: AppTypography.labelMedium.copyWith(
                color: isSelected
                    ? AppColors.textInverse
                    : AppColors.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
