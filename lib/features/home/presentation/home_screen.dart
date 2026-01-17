import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';

import '../../../config/routes/app_router.dart';
import '../../../core/theme/theme.dart';
import '../../../core/utils/l10n_extensions.dart';
import '../../../core/widgets/widgets.dart';

/// Home screen - main landing page with Judge Bite and navigation.
///
/// Features:
/// - Warm gradient background
/// - Time-based greeting
/// - Judge Bite mascot with idle animation
/// - New Decision CTA
/// - Recent verdicts section (empty state for now)
/// - Settings access
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: isDark
                ? [
                    AppColors.backgroundDark,
                    const Color(0xFF1E1E35),
                    const Color(0xFF151525),
                  ]
                : [
                    AppColors.background,
                    const Color(0xFFFFF5EB),
                    const Color(0xFFFFEDD8),
                  ],
            stops: const [0.0, 0.5, 1.0],
          ),
        ),
        child: SafeArea(
          child: CustomScrollView(
            slivers: [
              // Custom App Bar
              SliverToBoxAdapter(
                child: Padding(
                  padding: AppDimensions.screenPadding,
                  child: _HomeHeader()
                      .animate()
                      .fadeIn(duration: AppDimensions.durationMedium),
                ),
              ),

              // Main Content
              SliverToBoxAdapter(
                child: Padding(
                  padding: AppDimensions.screenPadding,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: AppDimensions.spaceLg),

                      // Time-based Greeting
                      _GreetingSection()
                          .animate()
                          .fadeIn(
                            duration: AppDimensions.durationMedium,
                            delay: const Duration(milliseconds: 100),
                          )
                          .slideY(
                            begin: 0.2,
                            end: 0.0,
                            duration: AppDimensions.durationMedium,
                            delay: const Duration(milliseconds: 100),
                          ),

                      const SizedBox(height: AppDimensions.spaceXxl),

                      // Judge Bite Mascot
                      const _JudgeBiteSection(),

                      const SizedBox(height: AppDimensions.spaceXxl),

                      // New Decision CTA
                      const _NewDecisionButton()
                          .animate()
                          .fadeIn(
                            duration: AppDimensions.durationMedium,
                            delay: const Duration(milliseconds: 400),
                          )
                          .scale(
                            begin: const Offset(0.9, 0.9),
                            end: const Offset(1.0, 1.0),
                            duration: AppDimensions.durationMedium,
                            delay: const Duration(milliseconds: 400),
                            curve: Curves.elasticOut,
                          ),

                      const SizedBox(height: AppDimensions.spaceXxl),

                      // Recent Verdicts Section
                      const _RecentVerdictsSection()
                          .animate()
                          .fadeIn(
                            duration: AppDimensions.durationMedium,
                            delay: const Duration(milliseconds: 500),
                          ),

                      const SizedBox(height: AppDimensions.spaceLg),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Home screen header with app title and settings icon.
class _HomeHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // App Title - Enhanced with retro diner energy
        Text(
          context.l10n.appTitle.toUpperCase(),
          style: AppTypography.displayMedium.copyWith(
            color: colorScheme.primary,
            fontStyle: FontStyle.italic, // Slanted for movement/energy
            letterSpacing: 2.0, // Dramatic spacing for impact
            shadows: [
              // Subtle shadow for depth (retro sign effect)
              Shadow(
                color: colorScheme.secondary.withValues(alpha: 0.2),
                offset: const Offset(2, 2),
                blurRadius: 1,
              ),
            ],
          ),
        ),

        // Settings Icon with retro styling
        Container(
          decoration: BoxDecoration(
            color: colorScheme.surface,
            shape: BoxShape.circle,
            border: Border.all(
              color: colorScheme.secondary,
              width: AppDimensions.borderMedium,
            ),
            boxShadow: AppDimensions.shadowRetroSm,
          ),
          child: IconButton(
            onPressed: () => context.push(AppRouter.settings),
            icon: const Icon(Icons.settings_outlined),
            color: colorScheme.secondary,
            tooltip: context.l10n.settings_screenTitle,
          ),
        ),
      ],
    );
  }
}

/// Greeting section with time-based message.
class _GreetingSection extends StatelessWidget {
  /// Gets the appropriate greeting based on current time.
  String _getGreeting(BuildContext context) {
    final hour = DateTime.now().hour;

    if (hour < 12) {
      return context.l10n.greeting_morning;
    } else if (hour < 17) {
      return context.l10n.greeting_afternoon;
    } else if (hour < 21) {
      return context.l10n.greeting_evening;
    } else {
      return context.l10n.greeting_night;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      _getGreeting(context),
      style: AppTypography.headlineLarge.copyWith(
        color: Theme.of(context).colorScheme.onSurface,
        letterSpacing: 0.5, // Slight spacing for elegance
        height: 1.3, // Better line height
      ),
      textAlign: TextAlign.center,
    );
  }
}

/// Judge Bite mascot section with floating animation.
class _JudgeBiteSection extends StatelessWidget {
  const _JudgeBiteSection();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          // Animated Judge Bite (Large for hero section, XLarge reserved for splash)
          JudgeBiteAnimated(
            pose: JudgeBitePose.idle,
            size: JudgeBiteSize.large,
          ),

          const SizedBox(height: AppDimensions.spaceMd),

          // Tagline - Enhanced
          Text(
            context.l10n.appTagline,
            style: AppTypography.bodyLarge.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
              fontStyle: FontStyle.italic,
              letterSpacing: 0.3,
              height: 1.4,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

/// New Decision CTA button with gradient and glow.
class _NewDecisionButton extends StatelessWidget {
  const _NewDecisionButton();

  @override
  Widget build(BuildContext context) {
    return AppGradientButton(
      label: context.l10n.home_newDecision,
      icon: Icons.gavel,
      onPressed: () => context.push(AppRouter.newDecision),
    );
  }
}

/// Recent verdicts section.
/// Shows empty state for now since we haven't implemented decision storage yet.
class _RecentVerdictsSection extends StatelessWidget {
  const _RecentVerdictsSection();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section Header
        Text(
          context.l10n.home_recentVerdicts,
          style: AppTypography.titleLarge.copyWith(
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),

        const SizedBox(height: AppDimensions.spaceMd),

        // Content: Empty state for now (Phase 4: load from database)
        const _EmptyVerdictsState(),
      ],
    );
  }
}

/// Empty state when there are no verdicts yet.
class _EmptyVerdictsState extends StatelessWidget {
  const _EmptyVerdictsState();

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return AppCard(
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.spaceLg),
        child: Column(
          children: [
            // Small Judge Bite confused
            JudgeBite(pose: JudgeBitePose.confused, size: JudgeBiteSize.medium),

            const SizedBox(height: AppDimensions.spaceMd),

            // Empty title
            Text(
              context.l10n.home_emptyTitle,
              style: AppTypography.titleMedium.copyWith(
                color: colorScheme.onSurface,
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: AppDimensions.spaceXs),

            // Empty message
            Text(
              context.l10n.home_emptyMessage,
              style: AppTypography.bodyMedium.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: AppDimensions.spaceMd),

            // CTA
            AppSecondaryButton(
              label: context.l10n.home_emptyAction,
              onPressed: () => context.push(AppRouter.newDecision),
            ),
          ],
        ),
      ),
    );
  }
}
