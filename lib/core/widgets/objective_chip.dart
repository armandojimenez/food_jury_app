import 'package:flutter/material.dart';
import 'package:food_jury/core/theme/app_colors.dart';
import 'package:food_jury/core/theme/app_dimensions.dart';

class ObjectiveChip extends StatelessWidget {
  final String label;
  final String icon; // Using emoji strings as per design plan (e.g., "🎉")
  final bool isSelected;
  final VoidCallback onTap;

  const ObjectiveChip({
    super.key,
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: AppDimensions.durationFast,
        curve: AppDimensions.curveSnappy,
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.spaceMd,
          vertical: AppDimensions.spaceSm,
        ),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : AppColors.surface,
          borderRadius: AppDimensions.borderRadiusXl,
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.border,
            width: isSelected
                ? AppDimensions.borderThick
                : AppDimensions.borderMedium,
          ),
          boxShadow: isSelected ? AppDimensions.shadowSm : [],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(icon, style: const TextStyle(fontSize: 18)),
            const SizedBox(width: AppDimensions.spaceXs),
            Text(
              label,
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                color: isSelected
                    ? AppColors.textInverse
                    : AppColors.textSecondary,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
