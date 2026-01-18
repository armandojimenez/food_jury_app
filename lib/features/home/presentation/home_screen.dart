import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../config/routes/app_router.dart';
import '../../../core/theme/theme.dart';
import '../../../core/utils/l10n_extensions.dart';
import '../../../core/widgets/widgets.dart';
import '../../../data/providers/verdict_provider.dart';
import '../../decision/data/models/verdict.dart';

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
                  child: _HomeHeader().animate().fadeIn(
                    duration: AppDimensions.durationMedium,
                  ),
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
                      const _RecentVerdictsSection().animate().fadeIn(
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

        // Header icons row
        Row(
          children: [
            // History Icon
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
                onPressed: () => context.push(AppRouter.history),
                icon: const Icon(Icons.history),
                color: colorScheme.secondary,
                tooltip: context.l10n.history_screenTitle,
              ),
            ),

            const SizedBox(width: AppDimensions.spaceSm),

            // Settings Icon
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
/// Loads verdicts from database and shows recent history.
class _RecentVerdictsSection extends ConsumerWidget {
  const _RecentVerdictsSection();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    final recentVerdictsAsync = ref.watch(recentVerdictsProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section Header with "See All" button
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              context.l10n.home_recentVerdicts,
              style: AppTypography.titleLarge.copyWith(
                color: colorScheme.onSurface,
              ),
            ),
            recentVerdictsAsync.maybeWhen(
              data: (verdicts) => verdicts.isNotEmpty
                  ? TextButton(
                      onPressed: () => context.push(AppRouter.history),
                      child: Text(
                        'See All',
                        style: AppTypography.labelLarge.copyWith(
                          color: colorScheme.primary,
                        ),
                      ),
                    )
                  : const SizedBox.shrink(),
              orElse: () => const SizedBox.shrink(),
            ),
          ],
        ),

        const SizedBox(height: AppDimensions.spaceMd),

        // Content based on state
        recentVerdictsAsync.when(
          data: (verdicts) => verdicts.isEmpty
              ? const _EmptyVerdictsState()
              : _RecentVerdictsList(verdicts: verdicts),
          loading: () => const Center(
            child: Padding(
              padding: EdgeInsets.all(AppDimensions.spaceLg),
              child: CircularProgressIndicator(),
            ),
          ),
          error: (_, _) => const _EmptyVerdictsState(),
        ),
      ],
    );
  }
}

/// List of recent verdict cards.
class _RecentVerdictsList extends StatelessWidget {
  const _RecentVerdictsList({required this.verdicts});

  final List<Verdict> verdicts;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: verdicts.asMap().entries.map((entry) {
        final index = entry.key;
        final verdict = entry.value;
        return Padding(
          padding: const EdgeInsets.only(bottom: AppDimensions.spaceMd),
          child: _RecentVerdictCard(verdict: verdict)
              .animate()
              .fadeIn(
                duration: AppDimensions.durationMedium,
                delay: Duration(milliseconds: index * 100),
              )
              .slideX(
                begin: 0.1,
                end: 0.0,
                duration: AppDimensions.durationMedium,
                delay: Duration(milliseconds: index * 100),
              ),
        );
      }).toList(),
    );
  }
}

/// Individual recent verdict card.
class _RecentVerdictCard extends StatelessWidget {
  const _RecentVerdictCard({required this.verdict});

  final Verdict verdict;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return InkWell(
      onTap: () => context.push(
        AppRouter.verdict,
        extra: VerdictRouteData(verdict: verdict, showRevealAnimation: false),
      ),
      borderRadius: AppDimensions.borderRadiusMd,
      child: Container(
        padding: const EdgeInsets.all(AppDimensions.spaceMd),
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: AppDimensions.borderRadiusMd,
          border: Border.all(
            color: colorScheme.secondary,
            width: AppDimensions.borderMedium,
          ),
          boxShadow: AppDimensions.shadowRetroSm,
        ),
        child: Row(
          children: [
            // Trophy icon
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppColors.primary, AppColors.primaryDark],
                ),
                borderRadius: AppDimensions.borderRadiusSm,
                border: Border.all(color: AppColors.pop, width: 2),
              ),
              child: const Center(
                child: Text('\uD83C\uDFC6', style: TextStyle(fontSize: 24)),
              ),
            ),

            const SizedBox(width: AppDimensions.spaceMd),

            // Verdict info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    verdict.winner.name,
                    style: AppTypography.titleSmall.copyWith(
                      color: colorScheme.onSurface,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: AppDimensions.spaceXxs),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppDimensions.spaceXs,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: verdict.objective.color.withValues(
                            alpha: 0.15,
                          ),
                          borderRadius: AppDimensions.borderRadiusSm,
                        ),
                        child: Text(
                          '${verdict.objective.icon} ${verdict.objective.getLabel(context)}',
                          style: AppTypography.labelSmall.copyWith(
                            color: verdict.objective.color,
                          ),
                        ),
                      ),
                      const SizedBox(width: AppDimensions.spaceSm),
                      Text(
                        _formatDate(verdict.createdAt),
                        style: AppTypography.bodySmall.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Chevron
            Icon(Icons.chevron_right, color: colorScheme.onSurfaceVariant),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final dateOnly = DateTime(date.year, date.month, date.day);

    if (dateOnly == today) {
      final hour = date.hour > 12
          ? date.hour - 12
          : (date.hour == 0 ? 12 : date.hour);
      final amPm = date.hour >= 12 ? 'PM' : 'AM';
      final minute = date.minute.toString().padLeft(2, '0');
      return '$hour:$minute $amPm';
    }

    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return '${months[date.month - 1]} ${date.day}';
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
