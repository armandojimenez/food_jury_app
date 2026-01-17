import 'package:flutter/material.dart';

import '../../core/theme/theme.dart';
import '../../core/widgets/widgets.dart';

/// Developer Settings Screen
/// Showcases design system components and provides debug utilities
class DevSettingsScreen extends StatelessWidget {
  const DevSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('Developer Settings', style: AppTypography.titleLarge),
        backgroundColor: AppColors.surface,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.accent),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: AppDimensions.screenPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Text(
                'DESIGN SYSTEM SHOWCASE',
                style: AppTypography.displayMedium.copyWith(
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: AppDimensions.spaceXs),
              Text(
                'Retro Diner Courtroom Theme',
                style: AppTypography.bodyLarge.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),

              const SizedBox(height: AppDimensions.spaceXxl),

              // Color Palette Section
              _buildSection(
                title: 'COLOR PALETTE',
                child: Wrap(
                  spacing: AppDimensions.spaceSm,
                  runSpacing: AppDimensions.spaceSm,
                  children: [
                    _ColorSwatch('Primary', AppColors.primary),
                    _ColorSwatch('Primary\nDark', AppColors.primaryDark),
                    _ColorSwatch('Primary\nLight', AppColors.primaryLight),
                    _ColorSwatch('Accent', AppColors.accent),
                    _ColorSwatch('Pop', AppColors.pop),
                    _ColorSwatch('Success', AppColors.success),
                    _ColorSwatch('Warning', AppColors.warning),
                    _ColorSwatch('Error', AppColors.error),
                    _ColorSwatch('Background', AppColors.background),
                    _ColorSwatch('Surface', AppColors.surface),
                  ],
                ),
              ),

              const SizedBox(height: AppDimensions.spaceXxl),

              // Typography Section
              _buildSection(
                title: 'TYPOGRAPHY',
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _TypoExample('Display Large', AppTypography.displayLarge),
                    _TypoExample('Display Medium', AppTypography.displayMedium),
                    _TypoExample('Display Small', AppTypography.displaySmall),
                    const SizedBox(height: AppDimensions.spaceMd),
                    _TypoExample('Headline Large', AppTypography.headlineLarge),
                    _TypoExample(
                      'Headline Medium',
                      AppTypography.headlineMedium,
                    ),
                    _TypoExample('Headline Small', AppTypography.headlineSmall),
                    const SizedBox(height: AppDimensions.spaceMd),
                    _TypoExample('Title Large', AppTypography.titleLarge),
                    _TypoExample('Title Medium', AppTypography.titleMedium),
                    _TypoExample('Title Small', AppTypography.titleSmall),
                    const SizedBox(height: AppDimensions.spaceMd),
                    _TypoExample('Body Large', AppTypography.bodyLarge),
                    _TypoExample('Body Medium', AppTypography.bodyMedium),
                    _TypoExample('Body Small', AppTypography.bodySmall),
                    const SizedBox(height: AppDimensions.spaceMd),
                    _TypoExample('Label Large', AppTypography.labelLarge),
                    _TypoExample('Label Medium', AppTypography.labelMedium),
                    _TypoExample('Label Small', AppTypography.labelSmall),
                    const SizedBox(height: AppDimensions.spaceMd),
                    _buildDivider(),
                    const SizedBox(height: AppDimensions.spaceMd),
                    _TypoExample('Verdict', AppTypography.verdict),
                    _TypoExample('Food Title', AppTypography.foodTitle),
                    _TypoExample('Judge Speech', AppTypography.judgeSpeech),
                    _TypoExample('Price Tag', AppTypography.priceTag),
                  ],
                ),
              ),

              const SizedBox(height: AppDimensions.spaceXxl),

              // Buttons Section
              _buildSection(
                title: 'BUTTONS',
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Primary Button
                    ElevatedButton(
                      onPressed: () {},
                      child: const Text('PRIMARY BUTTON'),
                    ),
                    const SizedBox(height: AppDimensions.spaceMd),

                    // Secondary Button
                    OutlinedButton(
                      onPressed: () {},
                      child: const Text('SECONDARY BUTTON'),
                    ),
                    const SizedBox(height: AppDimensions.spaceMd),

                    // Disabled Button
                    ElevatedButton(
                      onPressed: null,
                      child: const Text('DISABLED BUTTON'),
                    ),
                    const SizedBox(height: AppDimensions.spaceMd),

                    // Icon Buttons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.favorite),
                          onPressed: () {},
                          color: AppColors.primary,
                        ),
                        IconButton(
                          icon: const Icon(Icons.settings),
                          onPressed: () {},
                          color: AppColors.accent,
                        ),
                        IconButton(
                          icon: const Icon(Icons.gavel),
                          onPressed: () {},
                          color: AppColors.pop,
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: AppDimensions.spaceXxl),

              // Cards Section
              _buildSection(
                title: 'CARDS',
                child: Column(
                  children: [
                    _RetroCard(),
                    const SizedBox(height: AppDimensions.spaceLg),
                    _StandardCard(),
                  ],
                ),
              ),

              const SizedBox(height: AppDimensions.spaceXxl),

              // Verdict Stamp
              _buildSection(
                title: 'VERDICT STAMP',
                child: _VerdictStampPreview(),
              ),

              const SizedBox(height: AppDimensions.spaceXxl),

              // Spacing Scale
              _buildSection(
                title: 'SPACING SCALE',
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _SpacingExample('Xxs', AppDimensions.spaceXxs),
                    _SpacingExample('Xs', AppDimensions.spaceXs),
                    _SpacingExample('Sm', AppDimensions.spaceSm),
                    _SpacingExample('Md', AppDimensions.spaceMd),
                    _SpacingExample('Lg', AppDimensions.spaceLg),
                    _SpacingExample('Xl', AppDimensions.spaceXl),
                    _SpacingExample('Xxl', AppDimensions.spaceXxl),
                  ],
                ),
              ),

              const SizedBox(height: AppDimensions.spaceXxl),

              // Border Radius
              _buildSection(
                title: 'BORDER RADIUS',
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _BorderExample('Sm', AppDimensions.radiusSm),
                    _BorderExample('Md', AppDimensions.radiusMd),
                    _BorderExample('Lg', AppDimensions.radiusLg),
                    _BorderExample('Xl', AppDimensions.radiusXl),
                  ],
                ),
              ),

              const SizedBox(height: AppDimensions.spaceXxl),

              // Shadows
              _buildSection(
                title: 'SHADOWS',
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _ShadowExample('Sm', AppDimensions.shadowSm),
                        _ShadowExample('Md', AppDimensions.shadowMd),
                      ],
                    ),
                    const SizedBox(height: AppDimensions.spaceLg),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _ShadowExample('Lg', AppDimensions.shadowLg),
                        _ShadowExample('Xl', AppDimensions.shadowXl),
                      ],
                    ),
                    const SizedBox(height: AppDimensions.spaceLg),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _ShadowExample('Retro', AppDimensions.shadowRetro),
                        _ShadowExample('Retro Sm', AppDimensions.shadowRetroSm),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: AppDimensions.spaceXxl),

              // Interactive: Snackbars
              _buildSection(
                title: 'SNACKBARS (Interactive)',
                child: Wrap(
                  spacing: AppDimensions.spaceSm,
                  runSpacing: AppDimensions.spaceSm,
                  children: [
                    AppSecondaryButton(
                      onPressed: () => AppSnackbar.showSuccess(
                        context,
                        message: 'Winner winner, chicken dinner!',
                      ),
                      label: 'Success',
                      icon: Icons.check_circle,
                      size: AppButtonSize.small,
                    ),
                    AppSecondaryButton(
                      onPressed: () => AppSnackbar.showError(
                        context,
                        message: 'Oops! Something went wrong.',
                      ),
                      label: 'Error',
                      icon: Icons.error,
                      size: AppButtonSize.small,
                    ),
                    AppSecondaryButton(
                      onPressed: () => AppSnackbar.showWarning(
                        context,
                        message: 'Are you sure about that?',
                      ),
                      label: 'Warning',
                      icon: Icons.warning,
                      size: AppButtonSize.small,
                    ),
                    AppSecondaryButton(
                      onPressed: () => AppSnackbar.showInfo(
                        context,
                        message: 'Did you know? Judge Bite loves pizza!',
                      ),
                      label: 'Info',
                      icon: Icons.info,
                      size: AppButtonSize.small,
                    ),
                    AppSecondaryButton(
                      onPressed: () => AppSnackbar.showVerdict(
                        context,
                        message: 'The court has spoken!',
                      ),
                      label: 'Verdict',
                      icon: Icons.gavel,
                      size: AppButtonSize.small,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: AppDimensions.spaceXxl),

              // Interactive: Dialogs
              _buildSection(
                title: 'DIALOGS (Interactive)',
                child: Wrap(
                  spacing: AppDimensions.spaceSm,
                  runSpacing: AppDimensions.spaceSm,
                  children: [
                    AppSecondaryButton(
                      onPressed: () => AppDialog.showConfirmation(
                        context,
                        title: 'Confirm Your Choice',
                        message:
                            'Are you sure you want to proceed with this decision?',
                        icon: Icons.help_outline,
                      ),
                      label: 'Confirmation',
                      size: AppButtonSize.small,
                    ),
                    AppSecondaryButton(
                      onPressed: () => AppDialog.showAlert(
                        context,
                        title: 'Important Notice',
                        message: 'Judge Bite reminds you to eat your veggies!',
                        icon: Icons.notifications,
                      ),
                      label: 'Alert',
                      size: AppButtonSize.small,
                    ),
                    AppSecondaryButton(
                      onPressed: () => AppDialog.showVerdict(
                        context,
                        title: 'The Verdict',
                        message:
                            'After careful deliberation, the court finds in favor of the pizza! The cheese pull alone sealed the deal.',
                      ),
                      label: 'Verdict Dialog',
                      size: AppButtonSize.small,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: AppDimensions.spaceXxl),

              // Interactive: Loading States
              _buildSection(
                title: 'LOADING STATES (Interactive)',
                child: Wrap(
                  spacing: AppDimensions.spaceSm,
                  runSpacing: AppDimensions.spaceSm,
                  children: [
                    AppSecondaryButton(
                      onPressed: () async {
                        LoadingOverlay.show(
                          context,
                          message: 'The court is in session...',
                          variant: LoadingVariant.thinking,
                        );
                        await Future.delayed(const Duration(seconds: 3));
                        if (!context.mounted) return;
                        LoadingOverlay.hide(context);
                      },
                      label: 'Thinking',
                      icon: Icons.psychology,
                      size: AppButtonSize.small,
                    ),
                    AppSecondaryButton(
                      onPressed: () async {
                        LoadingOverlay.show(
                          context,
                          message: 'Analyzing the flavors...',
                          variant: LoadingVariant.processing,
                        );
                        await Future.delayed(const Duration(seconds: 3));
                        if (!context.mounted) return;
                        LoadingOverlay.hide(context);
                      },
                      label: 'Processing',
                      icon: Icons.donut_small,
                      size: AppButtonSize.small,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: AppDimensions.spaceXxl),

              // Navigation Components
              _buildSection(
                title: 'NAVIGATION COMPONENTS',
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Back & Close Buttons:',
                      style: AppTypography.labelMedium,
                    ),
                    const SizedBox(height: AppDimensions.spaceSm),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        AppBackButton(onPressed: () {}),
                        AppCloseButton(onPressed: () {}),
                        AppBackButton(
                          onPressed: () {},
                          color: AppColors.primary,
                        ),
                        AppCloseButton(
                          onPressed: () {},
                          color: AppColors.warning,
                        ),
                      ],
                    ),
                    const SizedBox(height: AppDimensions.spaceLg),
                    Text(
                      'Floating Action Button:',
                      style: AppTypography.labelMedium,
                    ),
                    const SizedBox(height: AppDimensions.spaceSm),
                    Center(
                      child: AppFab(
                        onPressed: () => AppSnackbar.showVerdict(
                          context,
                          message: 'FAB tapped! Ready to make decisions!',
                        ),
                        icon: Icons.gavel,
                        label: 'New Decision',
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: AppDimensions.spaceXxl),

              // Bottom Sheet Demo
              _buildSection(
                title: 'BOTTOM SHEET (Interactive)',
                child: AppButton(
                  onPressed: () {
                    AppBottomSheet.show(
                      context,
                      child: Padding(
                        padding: const EdgeInsets.all(AppDimensions.spaceLg),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'BOTTOM SHEET',
                              style: AppTypography.displaySmall,
                            ),
                            const SizedBox(height: AppDimensions.spaceMd),
                            Text(
                              'This is a retro-styled bottom sheet with chunky borders and a drag handle.',
                              style: AppTypography.bodyLarge,
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: AppDimensions.spaceLg),
                            AppButton(
                              onPressed: () => Navigator.of(context).pop(),
                              label: 'Close',
                              size: AppButtonSize.small,
                            ),
                            const SizedBox(height: AppDimensions.spaceMd),
                          ],
                        ),
                      ),
                    );
                  },
                  label: 'Show Bottom Sheet',
                  size: AppButtonSize.medium,
                ),
              ),

              const SizedBox(height: AppDimensions.spaceXxl),

              // Judge Bite Poses
              _buildSection(
                title: 'JUDGE BITE POSES',
                child: Wrap(
                  spacing: AppDimensions.spaceMd,
                  runSpacing: AppDimensions.spaceMd,
                  children: [
                    _JudgeBitePreview(JudgeBitePose.idle, 'Idle'),
                    _JudgeBitePreview(JudgeBitePose.thinking, 'Thinking'),
                    _JudgeBitePreview(JudgeBitePose.excited, 'Excited'),
                    _JudgeBitePreview(JudgeBitePose.stern, 'Stern'),
                    _JudgeBitePreview(JudgeBitePose.confused, 'Confused'),
                    _JudgeBitePreview(JudgeBitePose.celebrating, 'Celebrating'),
                  ],
                ),
              ),

              const SizedBox(height: AppDimensions.spaceXxl),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSection({required String title, required Widget child}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: AppTypography.displaySmall),
        const SizedBox(height: AppDimensions.spaceMd),
        child,
      ],
    );
  }

  Widget _buildDivider() {
    return Container(
      height: 2,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primary.withValues(alpha: 0.0),
            AppColors.primary,
            AppColors.primary.withValues(alpha: 0.0),
          ],
        ),
      ),
    );
  }
}

// Color Swatch Widget
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
        border: Border.all(
          color: AppColors.accent,
          width: AppDimensions.borderMedium,
        ),
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

// Typography Example Widget
class _TypoExample extends StatelessWidget {
  const _TypoExample(this.label, this.style);

  final String label;
  final TextStyle style;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppDimensions.spaceXs),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: style),
          Text(
            '${style.fontFamily} • ${style.fontSize}px • ${style.fontWeight?.toString().split('.').last}',
            style: AppTypography.bodySmall.copyWith(color: AppColors.textMuted),
          ),
        ],
      ),
    );
  }
}

// Retro Card Example
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
                Icons.local_pizza,
                size: AppDimensions.iconSizeXl,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(width: AppDimensions.spaceMd),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('PEPPERONI PIZZA', style: AppTypography.foodTitle),
                  const SizedBox(height: AppDimensions.spaceXs),
                  Text(
                    'Classic from Mario\'s Pizzeria',
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

// Standard Card Example
class _StandardCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.spaceMd),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: AppDimensions.borderRadiusMd,
        boxShadow: AppDimensions.shadowMd,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Standard Card', style: AppTypography.titleLarge),
          const SizedBox(height: AppDimensions.spaceSm),
          Text(
            'This is a standard card with soft shadow and rounded corners.',
            style: AppTypography.bodyMedium,
          ),
        ],
      ),
    );
  }
}

// Verdict Stamp Preview
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
          child: Text('WINNER!', style: AppTypography.verdict),
        ),
      ),
    );
  }
}

// Spacing Example
class _SpacingExample extends StatelessWidget {
  const _SpacingExample(this.label, this.size);

  final String label;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppDimensions.spaceXs),
      child: Row(
        children: [
          SizedBox(
            width: 60,
            child: Text(label, style: AppTypography.labelSmall),
          ),
          Container(
            width: size,
            height: 20,
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: AppDimensions.spaceSm),
          Text(
            '${size.toInt()}px',
            style: AppTypography.bodySmall.copyWith(color: AppColors.textMuted),
          ),
        ],
      ),
    );
  }
}

// Border Radius Example
class _BorderExample extends StatelessWidget {
  const _BorderExample(this.label, this.radius);

  final String label;
  final double radius;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(radius),
          ),
        ),
        const SizedBox(height: AppDimensions.spaceXs),
        Text(label, style: AppTypography.labelSmall),
        Text(
          '${radius.toInt()}px',
          style: AppTypography.bodySmall.copyWith(color: AppColors.textMuted),
        ),
      ],
    );
  }
}

// Shadow Example
class _ShadowExample extends StatelessWidget {
  const _ShadowExample(this.label, this.shadow);

  final String label;
  final List<BoxShadow> shadow;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 80,
          height: 60,
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: AppDimensions.borderRadiusMd,
            boxShadow: shadow,
            border: Border.all(
              color: AppColors.border,
              width: AppDimensions.borderThin,
            ),
          ),
          child: Center(
            child: Text(
              label,
              style: AppTypography.labelSmall,
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ],
    );
  }
}

// Judge Bite Pose Preview Widget
class _JudgeBitePreview extends StatelessWidget {
  const _JudgeBitePreview(this.pose, this.label);

  final JudgeBitePose pose;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        JudgeBite(pose: pose, size: JudgeBiteSize.small),
        const SizedBox(height: AppDimensions.spaceXs),
        Text(label, style: AppTypography.labelSmall),
      ],
    );
  }
}
