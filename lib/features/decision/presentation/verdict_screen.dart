import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';

import '../../../config/routes/app_router.dart';
import '../../../core/theme/theme.dart';
import '../../../core/utils/l10n_extensions.dart';
import '../../../core/widgets/widgets.dart';
import '../data/models/food_option.dart';
import '../data/models/verdict.dart';

/// Verdict Screen - the dramatic reveal of Judge Bite's decision.
///
/// This is THE showstopper screen with:
/// - Dramatic overlay that dims the screen
/// - "THE VERDICT IS IN" text slamming down
/// - Winner card flying up with golden glow
/// - Confetti celebration
/// - Judge Bite celebrating
/// - Reasoning in Judge's voice
class VerdictScreen extends StatefulWidget {
  const VerdictScreen({
    required this.verdict,
    this.showRevealAnimation = true,
    super.key,
  });

  /// The verdict to display.
  final Verdict verdict;

  /// Whether to play the dramatic reveal animation.
  /// Set to false when viewing from history.
  final bool showRevealAnimation;

  @override
  State<VerdictScreen> createState() => _VerdictScreenState();
}

class _VerdictScreenState extends State<VerdictScreen>
    with TickerProviderStateMixin {
  /// Controls whether we show the post-reveal content.
  late bool _showFullContent;

  /// Controls confetti animation.
  late bool _showConfetti;

  @override
  void initState() {
    super.initState();
    // Skip animation if viewing from history
    if (widget.showRevealAnimation) {
      _showFullContent = false;
      _showConfetti = false;
      _startRevealSequence();
    } else {
      _showFullContent = true;
      _showConfetti = false; // No confetti when viewing from history
    }
  }

  Future<void> _startRevealSequence() async {
    // Wait for initial animations, then show full content
    await Future.delayed(const Duration(milliseconds: 2200));
    if (mounted) {
      setState(() {
        _showConfetti = true;
      });
    }

    await Future.delayed(const Duration(milliseconds: 300));
    if (mounted) {
      setState(() {
        _showFullContent = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: isDark
                ? [
                    const Color(0xFF1A1A2E), // Dark navy at top
                    const Color(0xFF2D2D44), // Softer navy
                    const Color(0xFF3D3D54), // Lighter navy
                    colorScheme.surface, // Dark surface at bottom
                  ]
                : [
                    const Color(0xFF2D2D44), // Softer navy at top
                    const Color(0xFF4A4A5E), // Warm gray
                    const Color(0xFFFFE8D6), // Soft peachy transition
                    AppColors.background, // Cream at bottom
                  ],
            stops: const [0.0, 0.25, 0.45, 0.65],
          ),
        ),
        child: SafeArea(
          child: Stack(
            children: [
              // Main content
              SingleChildScrollView(
                padding: AppDimensions.screenPadding,
                child: Column(
                  children: [
                    const SizedBox(height: AppDimensions.spaceXxl),

                    // "THE VERDICT IS IN" - slams down from top (clean slide only)
                    _VerdictTitle()
                        .animate()
                        .slideY(
                          begin: -3.0,
                          end: 0.0,
                          duration: const Duration(milliseconds: 700),
                          curve: Curves.easeOutBack,
                        )
                        .fadeIn(duration: const Duration(milliseconds: 400)),

                    const SizedBox(height: AppDimensions.spaceXxl),

                    // Winner Card - flies up from bottom
                    _WinnerCard(winner: widget.verdict.winner)
                        .animate()
                        .slideY(
                          begin: 3.0,
                          end: 0.0,
                          duration: const Duration(milliseconds: 800),
                          curve: Curves.elasticOut,
                          delay: const Duration(milliseconds: 800),
                        )
                        .fadeIn(
                          duration: const Duration(milliseconds: 400),
                          delay: const Duration(milliseconds: 800),
                        ),

                    const SizedBox(height: AppDimensions.spaceLg),

                    // Judge Bite Celebrating
                    if (_showFullContent)
                      JudgeBite(
                        pose: JudgeBitePose.celebrating,
                        size: JudgeBiteSize.large,
                      ).animate().scale(
                        begin: const Offset(0.0, 0.0),
                        end: const Offset(1.0, 1.0),
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.elasticOut,
                      ),

                    const SizedBox(height: AppDimensions.spaceLg),

                    // Judge's Reasoning
                    if (_showFullContent)
                      _JudgeReasoning(
                            reasoning: widget.verdict.reasoning,
                            tone: widget.verdict.judgeTone,
                          )
                          .animate()
                          .fadeIn(duration: AppDimensions.durationMedium)
                          .slideY(
                            begin: 0.2,
                            end: 0.0,
                            duration: AppDimensions.durationMedium,
                          ),

                    // Bonus content (joke, tip, fun fact, story)
                    if (_showFullContent && widget.verdict.bonus != null)
                      Padding(
                            padding: const EdgeInsets.only(
                              top: AppDimensions.spaceLg,
                            ),
                            child: _BonusSection(
                              bonus: widget.verdict.bonus!,
                              bonusType: widget.verdict.bonusType,
                            ),
                          )
                          .animate()
                          .fadeIn(
                            duration: AppDimensions.durationMedium,
                            delay: const Duration(milliseconds: 100),
                          )
                          .slideY(
                            begin: 0.2,
                            end: 0.0,
                            duration: AppDimensions.durationMedium,
                          ),

                    const SizedBox(height: AppDimensions.spaceLg),

                    // Other Rankings (if more than 1 option)
                    if (_showFullContent && widget.verdict.rankings.length > 1)
                      _OtherRankings(
                        rankings: widget.verdict.rankings,
                        winner: widget.verdict.winner,
                      ).animate().fadeIn(
                        duration: AppDimensions.durationMedium,
                        delay: const Duration(milliseconds: 200),
                      ),

                    const SizedBox(height: AppDimensions.spaceXxl),

                    // Action Buttons
                    if (_showFullContent)
                      _ActionButtons()
                          .animate()
                          .fadeIn(
                            duration: AppDimensions.durationMedium,
                            delay: const Duration(milliseconds: 400),
                          )
                          .slideY(
                            begin: 0.3,
                            end: 0.0,
                            duration: AppDimensions.durationMedium,
                            delay: const Duration(milliseconds: 400),
                          ),

                    const SizedBox(height: AppDimensions.spaceXxl),
                  ],
                ),
              ),

              // Confetti overlay
              if (_showConfetti) const _ConfettiOverlay(),
            ],
          ),
        ),
      ),
    );
  }
}

/// "THE VERDICT IS IN" dramatic title.
class _VerdictTitle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Main verdict text with glow
        Text(
          context.l10n.verdict_theVerdictIsIn.toUpperCase(),
          style: AppTypography.displayLarge.copyWith(
            color: AppColors.pop,
            fontSize: 36,
            letterSpacing: 3.0,
            shadows: [
              Shadow(
                color: AppColors.pop.withValues(alpha: 0.8),
                blurRadius: 20,
              ),
              Shadow(
                color: AppColors.primary.withValues(alpha: 0.6),
                blurRadius: 40,
              ),
            ],
          ),
          textAlign: TextAlign.center,
        ),

        const SizedBox(height: AppDimensions.spaceSm),

        // Decorative line
        Container(
          width: 200,
          height: 4,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [
                Colors.transparent,
                AppColors.pop,
                AppColors.primary,
                AppColors.pop,
                Colors.transparent,
              ],
            ),
            borderRadius: BorderRadius.circular(2),
            boxShadow: [
              BoxShadow(
                color: AppColors.pop.withValues(alpha: 0.5),
                blurRadius: 10,
                spreadRadius: 2,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// Winner card with golden glow and crown.
class _WinnerCard extends StatelessWidget {
  const _WinnerCard({required this.winner});

  final FoodOption winner;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.spaceLg),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.primary, AppColors.primaryDark],
        ),
        borderRadius: AppDimensions.borderRadiusLg,
        border: Border.all(
          color: AppColors.pop,
          width: AppDimensions.borderChunky,
        ),
        boxShadow: [
          // Golden glow
          BoxShadow(
            color: AppColors.pop.withValues(alpha: 0.4),
            blurRadius: 30,
            spreadRadius: 5,
          ),
          // Hard shadow
          const BoxShadow(
            color: AppColors.accent,
            offset: Offset(6, 6),
            blurRadius: 0,
          ),
        ],
      ),
      child: Column(
        children: [
          // Crown icon with gentle float
          Text(
                '\uD83D\uDC51', // Crown emoji
                style: const TextStyle(fontSize: 48),
              )
              .animate(onPlay: (controller) => controller.repeat(reverse: true))
              .scale(
                begin: const Offset(1.0, 1.0),
                end: const Offset(1.08, 1.08),
                duration: const Duration(milliseconds: 1200),
                curve: Curves.easeInOut,
              ),

          const SizedBox(height: AppDimensions.spaceMd),

          // Winner badge with mustard highlight
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppDimensions.spaceMd,
              vertical: AppDimensions.spaceXs,
            ),
            decoration: BoxDecoration(
              color: AppColors.pop,
              borderRadius: AppDimensions.borderRadiusXl,
              border: Border.all(
                color: AppColors.accent,
                width: AppDimensions.borderThick,
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.pop.withValues(alpha: 0.5),
                  blurRadius: 8,
                  spreadRadius: 0,
                ),
              ],
            ),
            child: Text(
              context.l10n.verdict_winner.toUpperCase(),
              style: AppTypography.labelLarge.copyWith(
                color: AppColors.accent,
                letterSpacing: 2.0,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),

          const SizedBox(height: AppDimensions.spaceMd),

          // Winner name
          Text(
            winner.name.toUpperCase(),
            style: AppTypography.displayMedium.copyWith(
              color: AppColors.surface,
              letterSpacing: 1.5,
            ),
            textAlign: TextAlign.center,
          ),

          if (winner.notes != null && winner.notes!.isNotEmpty) ...[
            const SizedBox(height: AppDimensions.spaceSm),
            Text(
              winner.notes!,
              style: AppTypography.bodyMedium.copyWith(
                color: AppColors.surface.withValues(alpha: 0.9),
                fontStyle: FontStyle.italic,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ],
      ),
    );
  }
}

/// Judge's reasoning section with enhanced styling.
class _JudgeReasoning extends StatelessWidget {
  const _JudgeReasoning({required this.reasoning, required this.tone});

  final String reasoning;
  final JudgeTone tone;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(AppDimensions.spaceLg),
      decoration: BoxDecoration(
        // Subtle warm gradient background
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDark
              ? [
                  colorScheme.surface,
                  colorScheme.surfaceContainerHighest,
                  colorScheme.surfaceContainerHigh,
                ]
              : [
                  colorScheme.surface,
                  AppColors.background,
                  const Color(0xFFFFF5EB), // Warm cream
                ],
        ),
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
          // Header with tone badge
          Row(
            children: [
              JudgeBite(pose: JudgeBitePose.stern, size: JudgeBiteSize.small),
              const SizedBox(width: AppDimensions.spaceMd),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      context.l10n.verdict_judgesNotes,
                      style: AppTypography.titleLarge.copyWith(
                        color: colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: AppDimensions.spaceXxs),
                    // Tone badge with color
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppDimensions.spaceSm,
                        vertical: AppDimensions.spaceXxs,
                      ),
                      decoration: BoxDecoration(
                        color: colorScheme.primary.withValues(alpha: 0.15),
                        borderRadius: AppDimensions.borderRadiusSm,
                        border: Border.all(
                          color: colorScheme.primary.withValues(alpha: 0.5),
                          width: 1,
                        ),
                      ),
                      child: Text(
                        '${tone.icon} ${tone.displayName}',
                        style: AppTypography.labelSmall.copyWith(
                          color: colorScheme.primary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: AppDimensions.spaceMd),

          // Decorative divider with gradient
          Container(
            height: 3,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [AppColors.primary, AppColors.pop, AppColors.primary],
              ),
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          const SizedBox(height: AppDimensions.spaceMd),

          // Reasoning text with quote marks
          Text(
            '"$reasoning"',
            style: AppTypography.bodyLarge.copyWith(
              color: colorScheme.onSurface,
              fontStyle: FontStyle.italic,
              height: 1.7,
            ),
          ),
        ],
      ),
    );
  }
}

/// Bonus content section (joke, tip, fun fact, story).
class _BonusSection extends StatelessWidget {
  const _BonusSection({required this.bonus, this.bonusType});

  final String bonus;
  final BonusType? bonusType;

  String _getLocalizedTitle(BuildContext context) {
    final l10n = context.l10n;
    switch (bonusType ?? BonusType.funFact) {
      case BonusType.joke:
        return l10n.verdict_bonusJoke;
      case BonusType.funFact:
        return l10n.verdict_bonusFunFact;
      case BonusType.tip:
        return l10n.verdict_bonusTip;
      case BonusType.story:
        return l10n.verdict_bonusStory;
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final type = bonusType ?? BonusType.funFact;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppDimensions.spaceMd),
      decoration: BoxDecoration(
        color: colorScheme.tertiary.withValues(alpha: 0.1),
        borderRadius: AppDimensions.borderRadiusMd,
        border: Border.all(
          color: colorScheme.tertiary.withValues(alpha: 0.3),
          width: AppDimensions.borderMedium,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with icon and type
          Row(
            children: [
              Text(type.icon, style: const TextStyle(fontSize: 24)),
              const SizedBox(width: AppDimensions.spaceSm),
              Text(
                _getLocalizedTitle(context).toUpperCase(),
                style: AppTypography.labelLarge.copyWith(
                  color: colorScheme.tertiary,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.5,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppDimensions.spaceSm),

          // Bonus content
          Text(
            bonus,
            style: AppTypography.bodyMedium.copyWith(
              color: colorScheme.onSurface,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}

/// Other rankings (collapsed view).
class _OtherRankings extends StatefulWidget {
  const _OtherRankings({required this.rankings, required this.winner});

  final List<FoodOption> rankings;
  final FoodOption winner;

  @override
  State<_OtherRankings> createState() => _OtherRankingsState();
}

class _OtherRankingsState extends State<_OtherRankings> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final otherOptions = widget.rankings
        .where((o) => o.id != widget.winner.id)
        .toList();

    if (otherOptions.isEmpty) return const SizedBox.shrink();

    return Column(
      children: [
        // Expand/collapse button
        InkWell(
          onTap: () => setState(() => _isExpanded = !_isExpanded),
          borderRadius: AppDimensions.borderRadiusMd,
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppDimensions.spaceMd,
              vertical: AppDimensions.spaceSm,
            ),
            decoration: BoxDecoration(
              color: colorScheme.surface,
              borderRadius: AppDimensions.borderRadiusMd,
              border: Border.all(
                color: colorScheme.outline,
                width: AppDimensions.borderMedium,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  _isExpanded
                      ? Icons.keyboard_arrow_up
                      : Icons.keyboard_arrow_down,
                  color: colorScheme.onSurfaceVariant,
                ),
                const SizedBox(width: AppDimensions.spaceXs),
                Text(
                  _isExpanded
                      ? context.l10n.verdict_hideRankings
                      : context.l10n.verdict_seeAllRankings,
                  style: AppTypography.labelMedium.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ),

        // Expanded rankings list
        if (_isExpanded) ...[
          const SizedBox(height: AppDimensions.spaceMd),
          ...otherOptions.asMap().entries.map((entry) {
            final index = entry.key;
            final option = entry.value;
            final rank = index + 2; // +2 because winner is #1

            return Padding(
              padding: const EdgeInsets.only(bottom: AppDimensions.spaceSm),
              child: _RankingItem(option: option, rank: rank),
            );
          }),
        ],
      ],
    );
  }
}

/// Single ranking item.
class _RankingItem extends StatelessWidget {
  const _RankingItem({required this.option, required this.rank});

  final FoodOption option;
  final int rank;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(AppDimensions.spaceMd),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: AppDimensions.borderRadiusMd,
        border: Border.all(
          color: colorScheme.outline,
          width: AppDimensions.borderMedium,
        ),
      ),
      child: Row(
        children: [
          // Rank badge
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainerHighest,
              shape: BoxShape.circle,
              border: Border.all(
                color: colorScheme.onSurfaceVariant,
                width: AppDimensions.borderMedium,
              ),
            ),
            child: Center(
              child: Text(
                '#$rank',
                style: AppTypography.labelSmall.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ),
          ),

          const SizedBox(width: AppDimensions.spaceMd),

          // Option name
          Expanded(
            child: Text(
              option.name,
              style: AppTypography.titleSmall.copyWith(
                color: colorScheme.onSurface,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Action buttons at the bottom.
class _ActionButtons extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Primary CTA - New Decision
        AppButton(
          label: context.l10n.verdict_newDecision,
          icon: Icons.gavel,
          onPressed: () => context.go(AppRouter.home),
        ),

        const SizedBox(height: AppDimensions.spaceMd),

        // Secondary actions row
        Row(
          children: [
            Expanded(
              child: AppSecondaryButton(
                label: context.l10n.verdict_share,
                onPressed: () {
                  // TODO: Implement share functionality
                  AppSnackbar.showInfo(context, message: 'Share coming soon!');
                },
              ),
            ),
          ],
        ),
      ],
    );
  }
}

/// Confetti celebration overlay.
class _ConfettiOverlay extends StatelessWidget {
  const _ConfettiOverlay();

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: Stack(
          children: List.generate(30, (index) {
            final random = index * 17 % 13;
            final left = (index * 31 % 100).toDouble();
            final delay = (index * 50) % 500;
            final color = _getConfettiColor(index);

            return Positioned(
              left: left.toDouble() * MediaQuery.of(context).size.width / 100,
              top: -50,
              child: _ConfettiPiece(color: color)
                  .animate()
                  .slideY(
                    begin: 0,
                    end: 15 + random.toDouble(),
                    duration: Duration(milliseconds: 2000 + (random * 100)),
                    curve: Curves.easeIn,
                    delay: Duration(milliseconds: delay),
                  )
                  .rotate(
                    begin: 0,
                    end: (random % 2 == 0 ? 2 : -2).toDouble(),
                    duration: Duration(milliseconds: 2000 + (random * 100)),
                    delay: Duration(milliseconds: delay),
                  )
                  .fadeOut(
                    duration: const Duration(milliseconds: 500),
                    delay: Duration(milliseconds: 1500 + delay),
                  ),
            );
          }),
        ),
      ),
    );
  }

  Color _getConfettiColor(int index) {
    final colors = [
      AppColors.primary,
      AppColors.pop,
      AppColors.success,
      AppColors.info,
      const Color(0xFFFF6B6B), // Coral
      const Color(0xFF4ECDC4), // Teal
    ];
    return colors[index % colors.length];
  }
}

/// Single confetti piece with varied sizes.
class _ConfettiPiece extends StatelessWidget {
  const _ConfettiPiece({required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) {
    // Varied size between 6-10px for visual interest
    final size = 6.0 + (color.hashCode % 5);
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(size / 4),
        boxShadow: [
          BoxShadow(color: color.withValues(alpha: 0.4), blurRadius: 3),
        ],
      ),
    );
  }
}
