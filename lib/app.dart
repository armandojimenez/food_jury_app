import 'package:flutter/material.dart';

import 'core/env/env.dart';
import 'core/theme/theme.dart';

class FoodJuryApp extends StatelessWidget {
  const FoodJuryApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: Env.appName,
      debugShowCheckedModeBanner: Env.isDev,
      theme: AppTheme.light,
      home: const _DesignSystemShowcase(),
    );
  }
}

/// Temporary showcase of the design system
/// Remove once real screens are implemented
class _DesignSystemShowcase extends StatelessWidget {
  const _DesignSystemShowcase();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: AppDimensions.screenPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Text(
                'FOOD JURY',
                style: AppTypography.displayLarge.copyWith(
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: AppDimensions.spaceXs),
              Text(
                'Retro Diner Courtroom',
                style: AppTypography.bodyLarge.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),

              const SizedBox(height: AppDimensions.spaceXxl),

              // Color Palette
              Text('COLOR PALETTE', style: AppTypography.displaySmall),
              const SizedBox(height: AppDimensions.spaceMd),
              Wrap(
                spacing: AppDimensions.spaceSm,
                runSpacing: AppDimensions.spaceSm,
                children: [
                  _ColorSwatch('Primary', AppColors.primary),
                  _ColorSwatch('Accent', AppColors.accent),
                  _ColorSwatch('Pop', AppColors.pop),
                  _ColorSwatch('Success', AppColors.success),
                  _ColorSwatch('Error', AppColors.error),
                ],
              ),

              const SizedBox(height: AppDimensions.spaceXxl),

              // Typography
              Text('TYPOGRAPHY', style: AppTypography.displaySmall),
              const SizedBox(height: AppDimensions.spaceMd),
              Text('Display Large', style: AppTypography.displayLarge),
              Text('Display Medium', style: AppTypography.displayMedium),
              Text('Display Small', style: AppTypography.displaySmall),
              const SizedBox(height: AppDimensions.spaceMd),
              Text('Headline Large', style: AppTypography.headlineLarge),
              Text('Body Large', style: AppTypography.bodyLarge),
              Text('Body Medium', style: AppTypography.bodyMedium),

              const SizedBox(height: AppDimensions.spaceXxl),

              // Buttons
              Text('BUTTONS', style: AppTypography.displaySmall),
              const SizedBox(height: AppDimensions.spaceMd),
              ElevatedButton(
                onPressed: () {},
                child: const Text('DELIVER VERDICT'),
              ),
              const SizedBox(height: AppDimensions.spaceMd),
              OutlinedButton(
                onPressed: () {},
                child: const Text('Add Option'),
              ),

              const SizedBox(height: AppDimensions.spaceXxl),

              // Retro Card
              Text('RETRO CARD', style: AppTypography.displaySmall),
              const SizedBox(height: AppDimensions.spaceMd),
              _RetroCard(),

              const SizedBox(height: AppDimensions.spaceXxl),

              // Verdict Stamp Preview
              Text('VERDICT STAMP', style: AppTypography.displaySmall),
              const SizedBox(height: AppDimensions.spaceMd),
              _VerdictStampPreview(),

              const SizedBox(height: AppDimensions.spaceXxl),
            ],
          ),
        ),
      ),
    );
  }
}

class _ColorSwatch extends StatelessWidget {
  const _ColorSwatch(this.name, this.color);

  final String name;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        color: color,
        borderRadius: AppDimensions.borderRadiusMd,
        boxShadow: AppDimensions.shadowRetroSm,
      ),
      child: Center(
        child: Text(
          name,
          style: AppTypography.labelSmall.copyWith(
            color: color.computeLuminance() > 0.5
                ? AppColors.textPrimary
                : AppColors.textInverse,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}

class _RetroCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: -AppDimensions.cardStackTilt,
      child: Container(
        padding: const EdgeInsets.all(AppDimensions.spaceMd),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: AppDimensions.borderRadiusMd,
          border: Border.all(
            color: AppColors.accent,
            width: AppDimensions.borderThick,
          ),
          boxShadow: AppDimensions.shadowRetro,
        ),
        child: Row(
          children: [
            Container(
              width: AppDimensions.foodCardImageSize,
              height: AppDimensions.foodCardImageSize,
              decoration: BoxDecoration(
                color: AppColors.primaryLight,
                borderRadius: AppDimensions.borderRadiusSm,
              ),
              child: const Icon(
                Icons.restaurant,
                size: AppDimensions.iconSizeXl,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(width: AppDimensions.spaceMd),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('PIZZA', style: AppTypography.foodTitle),
                  const SizedBox(height: AppDimensions.spaceXs),
                  Text(
                    'Classic pepperoni from Mario\'s',
                    style: AppTypography.bodyMedium.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _VerdictStampPreview extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Transform.rotate(
        angle: -AppDimensions.verdictTiltAngle * 2,
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimensions.spaceXl,
            vertical: AppDimensions.spaceMd,
          ),
          decoration: BoxDecoration(
            gradient: AppColors.verdictGradient,
            borderRadius: AppDimensions.borderRadiusMd,
            boxShadow: AppDimensions.shadowXl,
            border: Border.all(
              color: AppColors.pop,
              width: AppDimensions.borderChunky,
            ),
          ),
          child: Text(
            'WINNER!',
            style: AppTypography.verdict,
          ),
        ),
      ),
    );
  }
}
