import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';

import '../../../config/routes/app_router.dart';
import '../../../core/theme/theme.dart';
import '../../../core/utils/l10n_extensions.dart';
import '../../../core/widgets/widgets.dart';
import '../../decision/data/models/objective.dart';
import '../../decision/data/models/verdict.dart';

/// History Screen - displays past verdicts grouped by date.
///
/// Features:
/// - Grouped list (Today, Yesterday, This Week, Earlier)
/// - Winner thumbnail, objective badge, date
/// - Empty state with sleeping Judge Bite
/// - Tap to view full verdict
class HistoryScreen extends StatelessWidget {
  const HistoryScreen({
    required this.verdicts,
    super.key,
  });

  /// List of past verdicts to display.
  final List<Verdict> verdicts;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppRetroAppBar(
        title: context.l10n.history_screenTitle,
        onBackPressed: () => context.pop(),
      ),
      body: verdicts.isEmpty
          ? const _EmptyState()
          : _VerdictsList(verdicts: verdicts),
    );
  }
}

/// Empty state when no verdicts exist.
class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Center(
      child: Padding(
        padding: AppDimensions.screenPadding,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Sleeping Judge Bite
            JudgeBite(
              pose: JudgeBitePose.sleeping,
              size: JudgeBiteSize.large,
            )
                .animate()
                .fadeIn(duration: AppDimensions.durationMedium)
                .scale(
                  begin: const Offset(0.9, 0.9),
                  end: const Offset(1.0, 1.0),
                  duration: AppDimensions.durationMedium,
                  curve: Curves.elasticOut,
                ),

            const SizedBox(height: AppDimensions.spaceLg),

            // Empty title
            Text(
              context.l10n.history_emptyTitle,
              style: AppTypography.headlineMedium.copyWith(
                color: colorScheme.onSurface,
              ),
              textAlign: TextAlign.center,
            )
                .animate()
                .fadeIn(
                  duration: AppDimensions.durationMedium,
                  delay: const Duration(milliseconds: 200),
                ),

            const SizedBox(height: AppDimensions.spaceSm),

            // Empty message
            Text(
              context.l10n.history_emptyMessage,
              style: AppTypography.bodyLarge.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            )
                .animate()
                .fadeIn(
                  duration: AppDimensions.durationMedium,
                  delay: const Duration(milliseconds: 300),
                ),

            const SizedBox(height: AppDimensions.spaceXxl),

            // CTA to start first decision
            AppButton(
              label: context.l10n.home_emptyAction,
              icon: Icons.gavel,
              onPressed: () => context.go(AppRouter.newDecision),
            )
                .animate()
                .fadeIn(
                  duration: AppDimensions.durationMedium,
                  delay: const Duration(milliseconds: 400),
                )
                .slideY(
                  begin: 0.2,
                  end: 0.0,
                  duration: AppDimensions.durationMedium,
                  delay: const Duration(milliseconds: 400),
                ),
          ],
        ),
      ),
    );
  }
}

/// List of verdicts grouped by date.
class _VerdictsList extends StatelessWidget {
  const _VerdictsList({required this.verdicts});

  final List<Verdict> verdicts;

  @override
  Widget build(BuildContext context) {
    // Group verdicts by date
    final grouped = _groupVerdictsByDate(verdicts, context);

    return ListView.builder(
      padding: AppDimensions.screenPadding,
      itemCount: grouped.length,
      itemBuilder: (context, index) {
        final group = grouped[index];
        return _DateGroup(
          title: group.title,
          verdicts: group.verdicts,
          animationDelay: index * 100,
        );
      },
    );
  }

  List<_VerdictGroup> _groupVerdictsByDate(
    List<Verdict> verdicts,
    BuildContext context,
  ) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final weekAgo = today.subtract(const Duration(days: 7));

    final todayVerdicts = <Verdict>[];
    final yesterdayVerdicts = <Verdict>[];
    final thisWeekVerdicts = <Verdict>[];
    final earlierVerdicts = <Verdict>[];

    for (final verdict in verdicts) {
      final date = DateTime(
        verdict.createdAt.year,
        verdict.createdAt.month,
        verdict.createdAt.day,
      );

      if (date == today) {
        todayVerdicts.add(verdict);
      } else if (date == yesterday) {
        yesterdayVerdicts.add(verdict);
      } else if (date.isAfter(weekAgo)) {
        thisWeekVerdicts.add(verdict);
      } else {
        earlierVerdicts.add(verdict);
      }
    }

    final groups = <_VerdictGroup>[];

    if (todayVerdicts.isNotEmpty) {
      groups.add(_VerdictGroup(
        title: context.l10n.history_today,
        verdicts: todayVerdicts,
      ));
    }
    if (yesterdayVerdicts.isNotEmpty) {
      groups.add(_VerdictGroup(
        title: context.l10n.history_yesterday,
        verdicts: yesterdayVerdicts,
      ));
    }
    if (thisWeekVerdicts.isNotEmpty) {
      groups.add(_VerdictGroup(
        title: context.l10n.history_thisWeek,
        verdicts: thisWeekVerdicts,
      ));
    }
    if (earlierVerdicts.isNotEmpty) {
      groups.add(_VerdictGroup(
        title: 'Earlier',
        verdicts: earlierVerdicts,
      ));
    }

    return groups;
  }
}

/// Helper class for grouping verdicts.
class _VerdictGroup {
  const _VerdictGroup({
    required this.title,
    required this.verdicts,
  });

  final String title;
  final List<Verdict> verdicts;
}

/// A group of verdicts with a date header.
class _DateGroup extends StatelessWidget {
  const _DateGroup({
    required this.title,
    required this.verdicts,
    required this.animationDelay,
  });

  final String title;
  final List<Verdict> verdicts;
  final int animationDelay;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Date header
        Padding(
          padding: const EdgeInsets.only(
            top: AppDimensions.spaceLg,
            bottom: AppDimensions.spaceMd,
          ),
          child: Text(
            title,
            style: AppTypography.labelLarge.copyWith(
              color: colorScheme.onSurfaceVariant,
              letterSpacing: 1.2,
            ),
          ),
        )
            .animate()
            .fadeIn(
              duration: AppDimensions.durationMedium,
              delay: Duration(milliseconds: animationDelay),
            ),

        // Verdict cards
        ...verdicts.asMap().entries.map((entry) {
          final index = entry.key;
          final verdict = entry.value;
          return Padding(
            padding: const EdgeInsets.only(bottom: AppDimensions.spaceMd),
            child: _VerdictCard(verdict: verdict)
                .animate()
                .fadeIn(
                  duration: AppDimensions.durationMedium,
                  delay: Duration(milliseconds: animationDelay + (index * 50)),
                )
                .slideX(
                  begin: 0.1,
                  end: 0.0,
                  duration: AppDimensions.durationMedium,
                  delay: Duration(milliseconds: animationDelay + (index * 50)),
                ),
          );
        }),
      ],
    );
  }
}

/// Individual verdict card in the history list with enhanced styling.
class _VerdictCard extends StatelessWidget {
  const _VerdictCard({required this.verdict});

  final Verdict verdict;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return InkWell(
      onTap: () => context.push(AppRouter.verdict, extra: verdict),
      borderRadius: AppDimensions.borderRadiusMd,
      child: Container(
        padding: const EdgeInsets.all(AppDimensions.spaceMd),
        decoration: BoxDecoration(
          // Subtle gradient background
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              colorScheme.surface,
              (isDark ? colorScheme.surfaceContainerHighest : colorScheme.surfaceContainerLowest).withValues(alpha: 0.5),
            ],
          ),
          borderRadius: AppDimensions.borderRadiusMd,
          border: Border.all(
            color: colorScheme.secondary,
            width: AppDimensions.borderThick,
          ),
          boxShadow: AppDimensions.shadowRetroSm,
        ),
        child: Row(
          children: [
            // Winner badge with gradient and crown
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppColors.primary,
                    AppColors.primaryDark,
                  ],
                ),
                borderRadius: AppDimensions.borderRadiusMd,
                border: Border.all(
                  color: AppColors.pop,
                  width: AppDimensions.borderMedium,
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.pop.withValues(alpha: 0.3),
                    blurRadius: 6,
                    spreadRadius: 0,
                  ),
                ],
              ),
              child: const Center(
                child: Text(
                  '\uD83C\uDFC6', // Trophy emoji
                  style: TextStyle(fontSize: 28),
                ),
              ),
            ),

            const SizedBox(width: AppDimensions.spaceMd),

            // Verdict info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Winner name with emphasis
                  Text(
                    verdict.winner.name,
                    style: AppTypography.titleMedium.copyWith(
                      color: colorScheme.onSurface,
                      fontWeight: FontWeight.w700,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),

                  const SizedBox(height: AppDimensions.spaceXs),

                  // Objective badge and date row
                  Row(
                    children: [
                      // Objective chip with icon color coding
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppDimensions.spaceSm,
                          vertical: AppDimensions.spaceXxs,
                        ),
                        decoration: BoxDecoration(
                          color: _getObjectiveColor(verdict.objective)
                              .withValues(alpha: 0.15),
                          borderRadius: AppDimensions.borderRadiusSm,
                          border: Border.all(
                            color: _getObjectiveColor(verdict.objective)
                                .withValues(alpha: 0.5),
                            width: 1,
                          ),
                        ),
                        child: Text(
                          '${verdict.objective.icon} ${verdict.objective.getLabel(context)}',
                          style: AppTypography.labelSmall.copyWith(
                            color: _getObjectiveColor(verdict.objective),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),

                      const SizedBox(width: AppDimensions.spaceSm),

                      // Date with icon
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.schedule,
                            size: 12,
                            color: colorScheme.onSurfaceVariant,
                          ),
                          const SizedBox(width: 4),
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
                ],
              ),
            ),

            // Retro styled chevron
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: colorScheme.surfaceContainerHighest,
                shape: BoxShape.circle,
                border: Border.all(
                  color: colorScheme.outline,
                  width: AppDimensions.borderMedium,
                ),
              ),
              child: Center(
                child: Icon(
                  Icons.arrow_forward_ios,
                  color: colorScheme.onSurfaceVariant,
                  size: 14,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getObjectiveColor(Objective objective) {
    switch (objective) {
      case Objective.fun:
        return AppColors.pop;
      case Objective.healthy:
        return AppColors.success;
      case Objective.fit:
        return AppColors.info;
      case Objective.quick:
        return AppColors.primary;
    }
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final dateOnly = DateTime(date.year, date.month, date.day);

    if (dateOnly == today) {
      // Format time as "2:15 PM"
      final hour = date.hour > 12 ? date.hour - 12 : (date.hour == 0 ? 12 : date.hour);
      final amPm = date.hour >= 12 ? 'PM' : 'AM';
      final minute = date.minute.toString().padLeft(2, '0');
      return '$hour:$minute $amPm';
    }

    // Format as "Jan 15"
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return '${months[date.month - 1]} ${date.day}';
  }
}
