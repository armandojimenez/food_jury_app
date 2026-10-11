import 'package:flutter/material.dart';

import '../theme/theme.dart';

/// Retro diner style card with chunky border and hard shadow.
///
/// Includes proper accessibility support when tappable.
class AppCard extends StatelessWidget {
  const AppCard({
    required this.child,
    this.tilt = false,
    this.padding,
    this.onTap,
    this.semanticLabel,
    super.key,
  });

  final Widget child;
  final bool tilt;
  final EdgeInsets? padding;
  final VoidCallback? onTap;

  /// Semantic label for screen readers when the card is tappable.
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    final card = Container(
      padding: padding ?? const EdgeInsets.all(AppDimensions.spaceMd),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: AppDimensions.borderRadiusMd,
        border: Border.all(
          color: colorScheme.secondary,
          width: AppDimensions.borderThick,
        ),
        boxShadow: AppDimensions.shadowRetro,
      ),
      child: child,
    );

    final rotated = tilt
        ? Transform.rotate(angle: -AppDimensions.cardStackTilt, child: card)
        : card;

    if (onTap != null) {
      return Semantics(
        button: true,
        label: semanticLabel,
        child: InkWell(
          onTap: onTap,
          borderRadius: AppDimensions.borderRadiusMd,
          child: rotated,
        ),
      );
    }

    return rotated;
  }
}

/// Standard modern card with soft shadow.
///
/// Includes proper accessibility support when tappable.
class AppModernCard extends StatelessWidget {
  const AppModernCard({
    required this.child,
    this.padding,
    this.onTap,
    this.semanticLabel,
    super.key,
  });

  final Widget child;
  final EdgeInsets? padding;
  final VoidCallback? onTap;

  /// Semantic label for screen readers when the card is tappable.
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    final card = Container(
      padding: padding ?? const EdgeInsets.all(AppDimensions.spaceMd),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: AppDimensions.borderRadiusMd,
        boxShadow: AppDimensions.shadowMd,
      ),
      child: child,
    );

    if (onTap != null) {
      return Semantics(
        button: true,
        label: semanticLabel,
        child: InkWell(
          onTap: onTap,
          borderRadius: AppDimensions.borderRadiusMd,
          child: card,
        ),
      );
    }

    return card;
  }
}

/// Food option card with image, title, and notes
class FoodCard extends StatelessWidget {
  const FoodCard({
    required this.title,
    this.description,
    this.imageUrl,
    this.imagePlaceholder,
    this.onTap,
    this.tilt = true,
    super.key,
  });

  final String title;
  final String? description;
  final String? imageUrl;
  final Widget? imagePlaceholder;
  final VoidCallback? onTap;
  final bool tilt;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return AppCard(
      tilt: tilt,
      onTap: onTap,
      child: Row(
        children: [
          // Image
          Container(
            width: AppDimensions.foodCardImageSize,
            height: AppDimensions.foodCardImageSize,
            decoration: BoxDecoration(
              color: colorScheme.primaryContainer,
              borderRadius: AppDimensions.borderRadiusSm,
              image: imageUrl != null
                  ? DecorationImage(
                      image: NetworkImage(imageUrl!),
                      fit: BoxFit.cover,
                    )
                  : null,
            ),
            child: imageUrl == null
                ? (imagePlaceholder ??
                      Icon(
                        Icons.restaurant,
                        size: AppDimensions.iconSizeXl,
                        color: colorScheme.primary,
                      ))
                : null,
          ),
          const SizedBox(width: AppDimensions.spaceMd),

          // Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title.toUpperCase(),
                  style: AppTypography.foodTitle.copyWith(
                    color: colorScheme.onSurface,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                if (description != null) ...[
                  const SizedBox(height: AppDimensions.spaceXs),
                  Text(
                    description!,
                    style: AppTypography.bodyMedium.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Verdict winner card with gradient and crown
class VerdictCard extends StatelessWidget {
  const VerdictCard({
    required this.title,
    this.imageUrl,
    this.imagePlaceholder,
    super.key,
  });

  final String title;
  final String? imageUrl;
  final Widget? imagePlaceholder;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Transform.rotate(
      angle: -AppDimensions.verdictTiltAngle * 2,
      child: Container(
        padding: const EdgeInsets.all(AppDimensions.spaceLg),
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
            // Crown icon
            const Icon(
              Icons.emoji_events,
              size: AppDimensions.iconSizeXl,
              color: AppColors.pop,
            ),
            const SizedBox(height: AppDimensions.spaceMd),

            // Winner image
            if (imageUrl != null || imagePlaceholder != null)
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: colorScheme.surface,
                  borderRadius: AppDimensions.borderRadiusMd,
                  border: Border.all(
                    color: AppColors.pop,
                    width: AppDimensions.borderMedium,
                  ),
                  image: imageUrl != null
                      ? DecorationImage(
                          image: NetworkImage(imageUrl!),
                          fit: BoxFit.cover,
                        )
                      : null,
                ),
                child: imageUrl == null ? imagePlaceholder : null,
              ),
            const SizedBox(height: AppDimensions.spaceMd),

            // Winner name
            Text(
              title.toUpperCase(),
              style: AppTypography.displaySmall.copyWith(
                color: AppColors.textInverse,
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: AppDimensions.spaceSm),

            // Winner stamp
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppDimensions.spaceMd,
                vertical: AppDimensions.spaceXs,
              ),
              decoration: BoxDecoration(
                color: AppColors.pop,
                borderRadius: AppDimensions.borderRadiusSm,
              ),
              child: Text(
                'WINNER!',
                style: AppTypography.labelLarge.copyWith(
                  color: colorScheme.secondary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
