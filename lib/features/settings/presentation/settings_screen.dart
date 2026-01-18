import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../config/routes/app_router.dart';
import '../../../core/env/env.dart';
import '../../../core/providers/mock_ai_provider.dart';
import '../../../core/providers/theme_provider.dart';
import '../../../core/theme/theme.dart';
import '../../../core/utils/l10n_extensions.dart';
import '../../../core/widgets/widgets.dart';
import '../../decision/data/models/verdict.dart';

/// Settings Screen - user preferences and app configuration.
///
/// Features:
/// - Judge Bite personality selector (4 tones)
/// - Theme toggle (light/dark/system)
/// - About section
/// - Judge Bite reacts to changes
class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  JudgeTone _selectedTone = JudgeTone.stern;

  void _selectTone(JudgeTone tone) {
    setState(() {
      _selectedTone = tone;
    });

    // Show feedback
    AppSnackbar.showSuccess(
      context,
      message: 'Judge Bite is now ${tone.displayName}!',
    );
  }

  void _selectTheme(ThemeMode mode) {
    ref.read(themeNotifierProvider.notifier).setThemeMode(mode);

    AppSnackbar.showSuccess(context, message: 'Theme updated!');
  }

  JudgeBitePose get _judgeBitePose {
    switch (_selectedTone) {
      case JudgeTone.stern:
        return JudgeBitePose.stern;
      case JudgeTone.sassy:
        return JudgeBitePose.thinking;
      case JudgeTone.enthusiastic:
        return JudgeBitePose.excited;
      case JudgeTone.chill:
        return JudgeBitePose.idle;
    }
  }

  @override
  Widget build(BuildContext context) {
    final selectedTheme = ref.watch(themeNotifierProvider);

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppRetroAppBar(
        title: context.l10n.settings_screenTitle,
        onBackPressed: () => context.pop(),
      ),
      body: SingleChildScrollView(
        padding: AppDimensions.screenPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: AppDimensions.spaceMd),

            // Judge Bite preview (reacts to tone selection)
            Center(
                  child: _JudgeBitePreview(
                    pose: _judgeBitePose,
                    tone: _selectedTone,
                  ),
                )
                .animate()
                .fadeIn(duration: AppDimensions.durationMedium)
                .scale(
                  begin: const Offset(0.9, 0.9),
                  end: const Offset(1.0, 1.0),
                  duration: AppDimensions.durationMedium,
                  curve: Curves.elasticOut,
                ),

            const SizedBox(height: AppDimensions.spaceXxl),

            // Judge's Personality Section
            _SectionHeader(
              title: context.l10n.settings_judgePersonality,
            ).animate().fadeIn(
              duration: AppDimensions.durationMedium,
              delay: const Duration(milliseconds: 100),
            ),

            const SizedBox(height: AppDimensions.spaceMd),

            _ToneSelector(selectedTone: _selectedTone, onSelect: _selectTone)
                .animate()
                .fadeIn(
                  duration: AppDimensions.durationMedium,
                  delay: const Duration(milliseconds: 150),
                )
                .slideY(
                  begin: 0.1,
                  end: 0.0,
                  duration: AppDimensions.durationMedium,
                  delay: const Duration(milliseconds: 150),
                ),

            const SizedBox(height: AppDimensions.spaceXxl),

            // Appearance Section
            _SectionHeader(
              title: context.l10n.settings_appearance,
            ).animate().fadeIn(
              duration: AppDimensions.durationMedium,
              delay: const Duration(milliseconds: 200),
            ),

            const SizedBox(height: AppDimensions.spaceMd),

            _ThemeSelector(selectedTheme: selectedTheme, onSelect: _selectTheme)
                .animate()
                .fadeIn(
                  duration: AppDimensions.durationMedium,
                  delay: const Duration(milliseconds: 250),
                )
                .slideY(
                  begin: 0.1,
                  end: 0.0,
                  duration: AppDimensions.durationMedium,
                  delay: const Duration(milliseconds: 250),
                ),

            const SizedBox(height: AppDimensions.spaceXxl),

            // About Section
            _AboutSection().animate().fadeIn(
              duration: AppDimensions.durationMedium,
              delay: const Duration(milliseconds: 300),
            ),

            // Dev Settings Section (only in dev mode)
            if (Env.isDev) ...[
              const SizedBox(height: AppDimensions.spaceXxl),

              _SectionHeader(
                title: context.l10n.settings_devSection,
              ).animate().fadeIn(
                duration: AppDimensions.durationMedium,
                delay: const Duration(milliseconds: 350),
              ),

              const SizedBox(height: AppDimensions.spaceMd),

              _DevSettingsSection()
                  .animate()
                  .fadeIn(
                    duration: AppDimensions.durationMedium,
                    delay: const Duration(milliseconds: 400),
                  )
                  .slideY(
                    begin: 0.1,
                    end: 0.0,
                    duration: AppDimensions.durationMedium,
                    delay: const Duration(milliseconds: 400),
                  ),
            ],

            const SizedBox(height: AppDimensions.spaceXxl),
          ],
        ),
      ),
    );
  }
}

/// Section header widget.
class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: AppTypography.labelLarge.copyWith(
        color: Theme.of(context).colorScheme.onSurfaceVariant,
        letterSpacing: 1.5,
      ),
    );
  }
}

/// Judge Bite preview that shows current tone.
class _JudgeBitePreview extends StatelessWidget {
  const _JudgeBitePreview({required this.pose, required this.tone});

  final JudgeBitePose pose;
  final JudgeTone tone;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      children: [
        JudgeBite(pose: pose, size: JudgeBiteSize.large),

        const SizedBox(height: AppDimensions.spaceMd),

        // Speech bubble with tone sample
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimensions.spaceLg,
            vertical: AppDimensions.spaceMd,
          ),
          decoration: BoxDecoration(
            color: colorScheme.surface,
            borderRadius: AppDimensions.borderRadiusLg,
            border: Border.all(
              color: colorScheme.secondary,
              width: AppDimensions.borderThick,
            ),
            boxShadow: AppDimensions.shadowRetro,
          ),
          child: Text(
            '"${tone.samplePhrase}"',
            style: AppTypography.bodyLarge.copyWith(
              color: colorScheme.onSurface,
              fontStyle: FontStyle.italic,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}

/// Tone selector cards.
class _ToneSelector extends StatelessWidget {
  const _ToneSelector({required this.selectedTone, required this.onSelect});

  final JudgeTone selectedTone;
  final Function(JudgeTone) onSelect;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: JudgeTone.values.map((tone) {
        final isSelected = tone == selectedTone;
        return Padding(
          padding: const EdgeInsets.only(bottom: AppDimensions.spaceSm),
          child: _ToneCard(
            tone: tone,
            isSelected: isSelected,
            onTap: () => onSelect(tone),
          ),
        );
      }).toList(),
    );
  }
}

/// Individual tone selection card.
class _ToneCard extends StatelessWidget {
  const _ToneCard({
    required this.tone,
    required this.isSelected,
    required this.onTap,
  });

  final JudgeTone tone;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return InkWell(
      onTap: onTap,
      borderRadius: AppDimensions.borderRadiusMd,
      child: AnimatedContainer(
        duration: AppDimensions.durationFast,
        padding: const EdgeInsets.all(AppDimensions.spaceMd),
        decoration: BoxDecoration(
          color: isSelected
              ? colorScheme.primaryContainer
              : colorScheme.surface,
          borderRadius: AppDimensions.borderRadiusMd,
          border: Border.all(
            color: isSelected ? colorScheme.primary : colorScheme.outline,
            width: isSelected
                ? AppDimensions.borderThick
                : AppDimensions.borderMedium,
          ),
          boxShadow: isSelected ? AppDimensions.shadowRetro : null,
        ),
        child: Row(
          children: [
            // Tone icon
            Text(tone.icon, style: const TextStyle(fontSize: 28)),

            const SizedBox(width: AppDimensions.spaceMd),

            // Tone info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    tone.displayName,
                    style: AppTypography.titleMedium.copyWith(
                      color: isSelected
                          ? colorScheme.primary
                          : colorScheme.onSurface,
                      fontWeight: isSelected
                          ? FontWeight.bold
                          : FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: AppDimensions.spaceXxs),
                  Text(
                    tone.samplePhrase,
                    style: AppTypography.bodySmall.copyWith(
                      color: colorScheme.onSurfaceVariant,
                      fontStyle: FontStyle.italic,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),

            // Selection indicator
            AnimatedContainer(
              duration: AppDimensions.durationFast,
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: isSelected ? colorScheme.primary : Colors.transparent,
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? colorScheme.primary : colorScheme.outline,
                  width: 2,
                ),
              ),
              child: isSelected
                  ? const Icon(Icons.check, size: 16, color: Colors.white)
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}

/// Theme selector with segmented control and retro styling.
class _ThemeSelector extends StatelessWidget {
  const _ThemeSelector({required this.selectedTheme, required this.onSelect});

  final ThemeMode selectedTheme;
  final Function(ThemeMode) onSelect;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(AppDimensions.spaceMd),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: AppDimensions.borderRadiusMd,
        border: Border.all(
          color: colorScheme.secondary,
          width: AppDimensions.borderThick,
        ),
        boxShadow: AppDimensions.shadowRetro,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.palette_outlined,
                color: colorScheme.primary,
                size: AppDimensions.iconSizeMd,
              ),
              const SizedBox(width: AppDimensions.spaceSm),
              Text(
                'Theme',
                style: AppTypography.titleSmall.copyWith(
                  color: colorScheme.onSurface,
                ),
              ),
            ],
          ),

          const SizedBox(height: AppDimensions.spaceMd),

          // Segmented control with better styling
          Row(
            children: [
              _ThemeOption(
                icon: Icons.light_mode,
                label: context.l10n.theme_light,
                isSelected: selectedTheme == ThemeMode.light,
                onTap: () => onSelect(ThemeMode.light),
              ),
              const SizedBox(width: AppDimensions.spaceSm),
              _ThemeOption(
                icon: Icons.dark_mode,
                label: context.l10n.theme_dark,
                isSelected: selectedTheme == ThemeMode.dark,
                onTap: () => onSelect(ThemeMode.dark),
              ),
              const SizedBox(width: AppDimensions.spaceSm),
              _ThemeOption(
                icon: Icons.brightness_auto,
                label: context.l10n.theme_system,
                isSelected: selectedTheme == ThemeMode.system,
                onTap: () => onSelect(ThemeMode.system),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Individual theme option button with springy animation.
class _ThemeOption extends StatefulWidget {
  const _ThemeOption({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  State<_ThemeOption> createState() => _ThemeOptionState();
}

class _ThemeOptionState extends State<_ThemeOption>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.elasticOut));
  }

  @override
  void didUpdateWidget(_ThemeOption oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isSelected && !oldWidget.isSelected) {
      _controller.forward(from: 0.0).then((_) => _controller.reverse());
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Expanded(
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedBuilder(
          animation: _scaleAnimation,
          builder: (context, child) {
            return Transform.scale(scale: _scaleAnimation.value, child: child);
          },
          child: AnimatedContainer(
            duration: AppDimensions.durationFast,
            padding: const EdgeInsets.symmetric(
              horizontal: AppDimensions.spaceSm,
              vertical: AppDimensions.spaceMd,
            ),
            decoration: BoxDecoration(
              color: widget.isSelected
                  ? colorScheme.primary
                  : colorScheme.surfaceContainerHighest,
              borderRadius: AppDimensions.borderRadiusMd,
              border: Border.all(
                color: widget.isSelected
                    ? colorScheme.secondary
                    : colorScheme.outline,
                width: widget.isSelected
                    ? AppDimensions.borderThick
                    : AppDimensions.borderMedium,
              ),
              boxShadow: widget.isSelected ? AppDimensions.shadowRetroSm : null,
            ),
            child: Column(
              children: [
                Icon(
                  widget.icon,
                  color: widget.isSelected
                      ? colorScheme.onPrimary
                      : colorScheme.onSurfaceVariant,
                  size: AppDimensions.iconSizeMd,
                ),
                const SizedBox(height: AppDimensions.spaceXs),
                Text(
                  widget.label,
                  style: AppTypography.labelSmall.copyWith(
                    color: widget.isSelected
                        ? colorScheme.onPrimary
                        : colorScheme.onSurfaceVariant,
                    fontWeight: widget.isSelected
                        ? FontWeight.w700
                        : FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// About section with app info and links - enhanced with personality.
class _AboutSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(AppDimensions.spaceMd),
      decoration: BoxDecoration(
        // Theme-aware gradient
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDark
              ? [colorScheme.surface, AppColors.surfaceDark]
              : [AppColors.surface, const Color(0xFFFFF5EB)],
        ),
        borderRadius: AppDimensions.borderRadiusMd,
        border: Border.all(
          color: colorScheme.secondary,
          width: AppDimensions.borderThick,
        ),
        boxShadow: AppDimensions.shadowRetro,
      ),
      child: Column(
        children: [
          // App branding header
          Row(
            children: [
              // Small Judge Bite
              JudgeBite(pose: JudgeBitePose.waving, size: JudgeBiteSize.small),
              const SizedBox(width: AppDimensions.spaceMd),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'FoodJury',
                      style: AppTypography.titleLarge.copyWith(
                        color: colorScheme.primary,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: AppDimensions.spaceXxs),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppDimensions.spaceSm,
                        vertical: AppDimensions.spaceXxs,
                      ),
                      decoration: BoxDecoration(
                        color: colorScheme.tertiary.withValues(alpha: 0.2),
                        borderRadius: AppDimensions.borderRadiusSm,
                      ),
                      child: Text(
                        'v1.0.0',
                        style: AppTypography.labelSmall.copyWith(
                          color: colorScheme.tertiary,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: AppDimensions.spaceMd),

          // Tagline
          Text(
            'Let the court decide your next meal!',
            style: AppTypography.bodyMedium.copyWith(
              color: colorScheme.onSurfaceVariant,
              fontStyle: FontStyle.italic,
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: AppDimensions.spaceMd),

          // Gradient divider
          Container(
            height: 3,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.transparent,
                  colorScheme.primary,
                  colorScheme.tertiary,
                  colorScheme.primary,
                  Colors.transparent,
                ],
              ),
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          const SizedBox(height: AppDimensions.spaceMd),

          // Links row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _AboutLink(
                label: context.l10n.settings_about,
                icon: Icons.info_outline,
                onTap: () {
                  AppSnackbar.showInfo(
                    context,
                    message: 'About page coming soon!',
                  );
                },
              ),
              _AboutLink(
                label: context.l10n.settings_privacy,
                icon: Icons.privacy_tip_outlined,
                onTap: () {
                  AppSnackbar.showInfo(
                    context,
                    message: 'Privacy policy coming soon!',
                  );
                },
              ),
              _AboutLink(
                label: context.l10n.settings_terms,
                icon: Icons.description_outlined,
                onTap: () {
                  AppSnackbar.showInfo(
                    context,
                    message: 'Terms of service coming soon!',
                  );
                },
              ),
            ],
          ),

          const SizedBox(height: AppDimensions.spaceMd),

          // Meet the Developer button
          SizedBox(
            width: double.infinity,
            child: AppSecondaryButton(
              label: context.l10n.about_meetDeveloper,
              onPressed: () => context.push(AppRouter.aboutDeveloper),
            ),
          ),

          const SizedBox(height: AppDimensions.spaceMd),

          // Made with love footer
          Text(
            context.l10n.settings_madeWithLove,
            style: AppTypography.bodySmall.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

/// Clickable about link with icon.
class _AboutLink extends StatelessWidget {
  const _AboutLink({required this.label, required this.onTap, this.icon});

  final String label;
  final VoidCallback onTap;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return InkWell(
      onTap: onTap,
      borderRadius: AppDimensions.borderRadiusSm,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.spaceSm,
          vertical: AppDimensions.spaceXs,
        ),
        child: Column(
          children: [
            if (icon != null) ...[
              Icon(
                icon,
                size: AppDimensions.iconSizeSm,
                color: colorScheme.primary,
              ),
              const SizedBox(height: AppDimensions.spaceXxs),
            ],
            Text(
              label,
              style: AppTypography.labelSmall.copyWith(
                color: colorScheme.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Developer settings section (only shown in dev mode).
class _DevSettingsSection extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final colorScheme = Theme.of(context).colorScheme;
    final useMockAi = ref.watch(mockAiNotifierProvider);

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.errorContainer.withValues(alpha: 0.1),
        borderRadius: AppDimensions.borderRadiusMd,
        border: Border.all(
          color: colorScheme.error.withValues(alpha: 0.3),
          width: AppDimensions.borderMedium,
        ),
      ),
      child: Column(
        children: [
          // Mock AI Toggle
          _DevSettingsTile(
            icon: Icons.smart_toy_outlined,
            title: l10n.settings_useMockAi,
            subtitle: l10n.settings_useMockAiDescription,
            trailing: Switch.adaptive(
              value: useMockAi,
              onChanged: (value) {
                ref.read(mockAiNotifierProvider.notifier).setUseMockAi(value);
                AppSnackbar.showSuccess(
                  context,
                  message: value
                      ? l10n.settings_mockAiEnabled
                      : l10n.settings_mockAiDisabled,
                );
              },
              activeTrackColor: colorScheme.primary,
              activeThumbColor: colorScheme.onPrimary,
            ),
          ),
        ],
      ),
    );
  }
}

/// Individual dev settings tile.
class _DevSettingsTile extends StatelessWidget {
  const _DevSettingsTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.trailing,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final Widget trailing;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.all(AppDimensions.spaceMd),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(AppDimensions.spaceSm),
            decoration: BoxDecoration(
              color: colorScheme.error.withValues(alpha: 0.1),
              borderRadius: AppDimensions.borderRadiusSm,
            ),
            child: Icon(
              icon,
              size: AppDimensions.iconSizeMd,
              color: colorScheme.error,
            ),
          ),
          const SizedBox(width: AppDimensions.spaceMd),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTypography.bodyLarge.copyWith(
                    fontWeight: FontWeight.w600,
                    color: colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: AppDimensions.spaceXxs),
                Text(
                  subtitle,
                  style: AppTypography.bodySmall.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          trailing,
        ],
      ),
    );
  }
}
