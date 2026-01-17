import 'dart:io';

import 'package:flutter/material.dart';
import 'package:food_jury/core/theme/app_colors.dart';
import 'package:food_jury/core/theme/app_dimensions.dart';
import 'package:food_jury/core/widgets/app_card.dart';

class OptionCard extends StatelessWidget {
  final String name;
  final String? imagePath;
  final String? notes;
  final VoidCallback? onTap;
  final VoidCallback? onDelete;

  const OptionCard({
    super.key,
    required this.name,
    this.imagePath,
    this.notes,
    this.onTap,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return AppCard(
      onTap: onTap,
      padding:
          EdgeInsets.zero, // We want content to touch edges or custom padding
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Image Section
            Container(
              width: AppDimensions.foodCardImageSize,
              color: AppColors.primaryLight,
              child: imagePath != null
                  ? Image.file(
                      File(imagePath!),
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                          const Center(
                            child: Icon(
                              Icons.broken_image,
                              color: AppColors.textInverse,
                            ),
                          ),
                    )
                  : const Center(
                      child: Icon(
                        Icons.camera_alt,
                        color: AppColors.textInverse,
                      ),
                    ),
            ),

            // Content Section
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(AppDimensions.spaceMd),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      name.isNotEmpty ? name : "Unnamed Option",
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: name.isNotEmpty
                            ? AppColors.textPrimary
                            : AppColors.textMuted,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),

                    if (notes != null && notes!.isNotEmpty) ...[
                      const SizedBox(height: AppDimensions.spaceXs),
                      Row(
                        children: [
                          const Icon(
                            Icons.note,
                            size: AppDimensions.iconSizeSm,
                            color: AppColors.textSecondary,
                          ),
                          const SizedBox(width: AppDimensions.spaceXs),
                          Expanded(
                            child: Text(
                              notes!,
                              style: Theme.of(context).textTheme.bodySmall
                                  ?.copyWith(color: AppColors.textSecondary),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ),

            // Action Section
            if (onDelete != null)
              Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: onDelete,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppDimensions.spaceMd,
                    ),
                    alignment: Alignment.center,
                    child: const Icon(Icons.close, color: AppColors.textMuted),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
