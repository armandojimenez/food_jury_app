import 'package:flutter/material.dart';
import 'package:food_jury/core/theme/app_colors.dart';
import 'package:food_jury/core/theme/app_dimensions.dart';

class AppTextField extends StatelessWidget {
  final String? label;
  final String? hint;
  final TextEditingController? controller;
  final int? maxLines;
  final TextInputType? keyboardType;
  final String? errorText;
  final ValueChanged<String>? onChanged;

  const AppTextField({
    super.key,
    this.label,
    this.hint,
    this.controller,
    this.maxLines = 1,
    this.keyboardType,
    this.errorText,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (label != null) ...[
          Text(
            label!,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
              color: AppColors.textSecondary,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: AppDimensions.spaceXs),
        ],
        TextField(
          controller: controller,
          maxLines: maxLines,
          keyboardType: keyboardType,
          onChanged: onChanged,
          style: Theme.of(
            context,
          ).textTheme.bodyLarge?.copyWith(color: AppColors.textPrimary),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: AppColors.textMuted),
            filled: true,
            fillColor: AppColors.surface,
            contentPadding: const EdgeInsets.all(AppDimensions.spaceMd),
            border: OutlineInputBorder(
              borderRadius: AppDimensions.borderRadiusMd,
              borderSide: const BorderSide(
                color: AppColors.border,
                width: AppDimensions.borderMedium,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: AppDimensions.borderRadiusMd,
              borderSide: const BorderSide(
                color: AppColors.border,
                width: AppDimensions.borderMedium,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: AppDimensions.borderRadiusMd,
              borderSide: const BorderSide(
                color: AppColors.primary,
                width: AppDimensions.borderThick,
              ),
            ),
            errorText: errorText,
            errorBorder: OutlineInputBorder(
              borderRadius: AppDimensions.borderRadiusMd,
              borderSide: const BorderSide(
                color: AppColors.error,
                width: AppDimensions.borderMedium,
              ),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: AppDimensions.borderRadiusMd,
              borderSide: const BorderSide(
                color: AppColors.error,
                width: AppDimensions.borderThick,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
