import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../config/routes/app_router.dart';
import '../../../core/theme/theme.dart';
import '../../../core/utils/l10n_extensions.dart';
import '../../../core/widgets/widgets.dart';

/// Home screen - main landing page with Judge Bite and navigation.
///
/// Features:
/// - Time-based greeting
/// - Judge Bite mascot with idle animation
/// - New Decision CTA
/// - Recent verdicts section (empty state for now)
/// - Settings access (dev mode)
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // Custom App Bar
            SliverToBoxAdapter(
              child: Padding(
                padding: AppDimensions.screenPadding,
                child: _HomeHeader(),
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
                    _GreetingSection(),

                    const SizedBox(height: AppDimensions.spaceXxl),

                    // Judge Bite Mascot
                    const _JudgeBiteSection(),

                    const SizedBox(height: AppDimensions.spaceXxl),

                    // New Decision CTA
                    const _NewDecisionButton(),

                    const SizedBox(height: AppDimensions.spaceXxl),

                    // Recent Verdicts Section
                    const _RecentVerdictsSection(),

                    const SizedBox(height: AppDimensions.spaceLg),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Home screen header with app title and settings icon.
class _HomeHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // App Title - Enhanced with retro diner energy
        Text(
          context.l10n.appTitle.toUpperCase(),
          style: AppTypography.displayMedium.copyWith(
            color: AppColors.primary,
            fontStyle: FontStyle.italic, // Slanted for movement/energy
            letterSpacing: 2.0, // Dramatic spacing for impact
            shadows: [
              // Subtle shadow for depth (retro sign effect)
              Shadow(
                color: AppColors.accent.withValues(alpha: 0.2),
                offset: const Offset(2, 2),
                blurRadius: 1,
              ),
            ],
          ),
        ),

        // Settings Icon (dev mode only)
        IconButton(
          onPressed: () => context.push(AppRouter.devSettings),
          icon: const Icon(Icons.settings),
          color: AppColors.textSecondary,
          tooltip: context.l10n.settings_screenTitle,
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
        color: AppColors.textPrimary,
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
          // Animated Judge Bite
          JudgeBiteAnimated(
            pose: JudgeBitePose.idle,
            size: JudgeBiteSize.xlarge,
          ),

          const SizedBox(height: AppDimensions.spaceMd),

          // Tagline - Enhanced
          Text(
            context.l10n.appTagline,
            style: AppTypography.bodyLarge.copyWith(
              color: AppColors.textSecondary,
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
            color: AppColors.textPrimary,
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
                color: AppColors.textPrimary,
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: AppDimensions.spaceXs),

            // Empty message
            Text(
              context.l10n.home_emptyMessage,
              style: AppTypography.bodyMedium.copyWith(
                color: AppColors.textSecondary,
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
