import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:share_plus/share_plus.dart';

import '../../../config/routes/app_router.dart';
import '../../../core/theme/theme.dart';
import '../../../core/utils/l10n_extensions.dart';
import '../../../core/widgets/widgets.dart';
import '../data/models/verdict.dart';

/// A staged courtroom reveal followed by an immediately useful verdict ticket.
class VerdictScreen extends StatefulWidget {
  const VerdictScreen({
    required this.verdict,
    this.showRevealAnimation = true,
    super.key,
  });
  final Verdict verdict;
  final bool showRevealAnimation;
  @override
  State<VerdictScreen> createState() => _VerdictScreenState();
}

class _VerdictScreenState extends State<VerdictScreen>
    with TickerProviderStateMixin {
  late final _reveal = AnimationController(
    vsync: this,
    duration: DinerTokens.reveal,
  );
  late final _confetti = AnimationController(
    vsync: this,
    duration: DinerTokens.confetti,
  );
  bool _started = false;
  bool _showRankings = false;
  bool _sharing = false;
  final _shareKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _reveal.addStatusListener((status) {
      if (status == AnimationStatus.completed &&
          _started &&
          mounted &&
          !reduceDinerMotion(context)) {
        _confetti.forward(from: 0);
        HapticFeedback.mediumImpact();
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (reduceDinerMotion(context) || !widget.showRevealAnimation) {
      _reveal.value = 1;
      _confetti.stop();
      _confetti.value = 1;
    } else if (!_started) {
      _reveal.forward();
    }
    _started = true;
  }

  @override
  void dispose() {
    _reveal.dispose();
    _confetti.dispose();
    super.dispose();
  }

  Future<void> _share() async {
    if (_sharing) return;
    setState(() => _sharing = true);
    final l10n = context.l10n;
    final box = _shareKey.currentContext?.findRenderObject() as RenderBox?;
    try {
      await SharePlus.instance.share(
        ShareParams(
          title: 'FoodJury',
          text:
              '${l10n.diner_wins(widget.verdict.winner.name)}\n\n${widget.verdict.reasoning}\n\nFoodJury · ${l10n.diner_welcome}',
          sharePositionOrigin: box == null
              ? null
              : box.localToGlobal(Offset.zero) & box.size,
        ),
      );
    } catch (error) {
      if (mounted) {
        AppSnackbar.showError(context, message: l10n.error_genericMessage);
      }
    } finally {
      if (mounted) setState(() => _sharing = false);
    }
  }

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
    animation: _reveal,
    builder: (context, child) {
      final revealing = _reveal.value < 1;
      return Stack(
        children: [
          DinerBusyBoundary(
            busy: revealing,
            child: IgnorePointer(
              ignoring: revealing,
              child: DinerScaffold(
                title: context.l10n.diner_verdict,
                child: LayoutBuilder(
                  builder: (context, box) {
                    final wide =
                        box.maxWidth >= DinerTokens.tabletBreakpoint &&
                        MediaQuery.textScalerOf(context).scale(1) <
                            DinerTokens.largeTextBreakpoint;
                    final winner = _Winner(verdict: widget.verdict, wide: wide);
                    final details = Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _RulingTicket(verdict: widget.verdict),
                        const SizedBox(height: AppDimensions.spaceMd),
                        if (widget.verdict.rankings.length > 1) ...[
                          OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Theme.of(
                                context,
                              ).colorScheme.onSurface,
                              padding: const EdgeInsets.all(
                                AppDimensions.spaceMd,
                              ),
                              shape: const RoundedRectangleBorder(
                                borderRadius: AppDimensions.borderRadiusMd,
                              ),
                            ),
                            onPressed: () =>
                                setState(() => _showRankings = !_showRankings),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(context.l10n.diner_otherOptions),
                                ),
                                Icon(
                                  _showRankings
                                      ? Icons.expand_less
                                      : Icons.expand_more,
                                ),
                              ],
                            ),
                          ),
                          AnimatedSize(
                            duration: reduceDinerMotion(context)
                                ? Duration.zero
                                : AppDimensions.durationMedium,
                            alignment: Alignment.topCenter,
                            child: !_showRankings
                                ? const SizedBox(width: double.infinity)
                                : Column(
                                    children: [
                                      for (final option
                                          in widget.verdict.rankings.where(
                                            (o) =>
                                                o.id !=
                                                widget.verdict.winner.id,
                                          ))
                                        Padding(
                                          padding: const EdgeInsets.only(
                                            top: AppDimensions.spaceSm,
                                          ),
                                          child: DinerTicket(
                                            child: Row(
                                              children: [
                                                DinerFoodImage(
                                                  bytes: option.imageBytes,
                                                  foodName: option.name,
                                                  size: AppDimensions
                                                      .avatarSizeMd,
                                                ),
                                                const SizedBox(
                                                  width: AppDimensions.spaceMd,
                                                ),
                                                Expanded(
                                                  child: Text(
                                                    option.name,
                                                    style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.w800,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                    ],
                                  ),
                          ),
                          const SizedBox(height: AppDimensions.spaceMd),
                        ],
                        DinerButton(
                          key: _shareKey,
                          label: context.l10n.diner_share,
                          icon: Icons.ios_share_rounded,
                          style: DinerButtonStyle.mustard,
                          loading: _sharing,
                          onPressed: _share,
                        ),
                        const SizedBox(height: AppDimensions.spaceSm),
                        TextButton(
                          onPressed: () => context.go(AppRouter.newDecision),
                          child: Text(context.l10n.diner_anotherCase),
                        ),
                        if (!reduceDinerMotion(context))
                          TextButton.icon(
                            onPressed: () {
                              _confetti.reset();
                              _reveal.forward(from: 0);
                            },
                            icon: const Icon(Icons.replay_rounded),
                            label: Text(context.l10n.diner_replay),
                          ),
                        if (widget.verdict.bonus?.isNotEmpty == true) ...[
                          const SizedBox(height: AppDimensions.spaceLg),
                          DinerSection(context.l10n.diner_bonus),
                          const SizedBox(height: AppDimensions.spaceSm),
                          DinerTicket(child: Text(widget.verdict.bonus!)),
                        ],
                      ],
                    );
                    if (wide) {
                      return Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(flex: 6, child: winner),
                          const SizedBox(width: DinerTokens.columnGap),
                          Expanded(
                            flex: 5,
                            child: Padding(
                              padding: const EdgeInsets.only(
                                top: AppDimensions.spaceLg,
                              ),
                              child: details,
                            ),
                          ),
                        ],
                      );
                    }
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        winner,
                        const SizedBox(height: AppDimensions.spaceLg),
                        details,
                      ],
                    );
                  },
                ),
              ),
            ),
          ),
          if (revealing)
            Positioned.fill(
              child: _RevealCurtain(
                progress: _reveal.value,
                onSkip: () => _reveal.animateTo(1, duration: DinerTokens.press),
              ),
            ),
          if (!revealing && !reduceDinerMotion(context))
            Positioned.fill(
              child: IgnorePointer(
                child: ExcludeSemantics(
                  child: AnimatedBuilder(
                    animation: _confetti,
                    builder: (context, child) =>
                        CustomPaint(painter: _ConfettiPainter(_confetti.value)),
                  ),
                ),
              ),
            ),
        ],
      );
    },
  );
}

class _RulingTicket extends StatelessWidget {
  const _RulingTicket({required this.verdict});
  final Verdict verdict;
  @override
  Widget build(BuildContext context) {
    final largeText =
        MediaQuery.textScalerOf(context).scale(1) >=
        DinerTokens.largeTextBreakpoint;
    final text = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          context.l10n.diner_ruling,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: AppDimensions.spaceXs),
        Text(verdict.reasoning, style: Theme.of(context).textTheme.bodyLarge),
        const SizedBox(height: AppDimensions.spaceSm),
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimensions.spaceSm,
            vertical: AppDimensions.spaceXs,
          ),
          decoration: const BoxDecoration(
            color: AppColors.pop,
            borderRadius: AppDimensions.borderRadiusSm,
          ),
          child: Text(
            context.l10n.diner_bestFor(verdict.objective.getLabel(context)),
            style: const TextStyle(
              color: AppColors.accent,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
      ],
    );
    return Stack(
      clipBehavior: Clip.none,
      children: [
        DinerTicket(
          dashed: true,
          child: Padding(
            padding: EdgeInsets.only(
              left: largeText ? 0 : DinerTokens.rulingInset,
            ),
            child: text,
          ),
        ),
        if (!largeText)
          const Positioned(
            left: -14,
            top: -20,
            child: JudgeBiteAnimated(
              pose: JudgeBitePose.celebrating,
              dimension: DinerTokens.rulingJudge,
            ),
          ),
      ],
    );
  }
}

class _Winner extends StatelessWidget {
  const _Winner({required this.verdict, required this.wide});
  final Verdict verdict;
  final bool wide;
  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      Align(
        alignment: Alignment.centerLeft,
        child: DinerStamp(context.l10n.diner_caseClosed),
      ),
      const SizedBox(height: AppDimensions.spaceMd),
      DinerHeading(context.l10n.diner_wins(verdict.winner.name), large: wide),
      const SizedBox(height: AppDimensions.spaceMd),
      Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: AppDimensions.borderRadiusMd,
              border: Border.all(
                color: Theme.of(context).colorScheme.onSurface,
                width: DinerTokens.border,
              ),
            ),
            child: ClipRRect(
              borderRadius: AppDimensions.borderRadiusMd,
              child: AspectRatio(
                aspectRatio: 1.45,
                child: verdict.winner.hasImage
                    ? Image.memory(
                        verdict.winner.imageBytes!,
                        fit: BoxFit.cover,
                        semanticLabel: context.l10n.a11y_photoOf(
                          verdict.winner.name,
                        ),
                        errorBuilder: (context, error, stack) =>
                            _WinnerPlaceholder(name: verdict.winner.name),
                      )
                    : _WinnerPlaceholder(name: verdict.winner.name),
              ),
            ),
          ),
          Positioned(
            right: AppDimensions.spaceSm,
            bottom: -AppDimensions.spaceSm,
            child: DinerStamp(context.l10n.diner_approved, orange: true),
          ),
        ],
      ),
    ],
  );
}

class _WinnerPlaceholder extends StatelessWidget {
  const _WinnerPlaceholder({required this.name});
  final String name;
  @override
  Widget build(BuildContext context) => ColoredBox(
    color: AppColors.pop,
    child: Stack(
      children: [
        const Positioned.fill(child: DinerSunburst()),
        Center(
          child: Padding(
            padding: const EdgeInsets.all(AppDimensions.spaceMd),
            child: FoodIllustration(name: name, size: DinerTokens.tabletJudge),
          ),
        ),
      ],
    ),
  );
}

class _RevealCurtain extends StatelessWidget {
  const _RevealCurtain({required this.progress, required this.onSkip});
  final double progress;
  final VoidCallback onSkip;
  @override
  Widget build(BuildContext context) {
    final slam = Curves.easeOutBack.transform(
      ((progress - .42) / .28).clamp(0, 1),
    );
    final exit = Curves.easeInCubic.transform(
      ((progress - .88) / .12).clamp(0, 1),
    );
    return Opacity(
      opacity: 1 - exit,
      child: DinerNightSurface(
        child: Stack(
          children: [
            Positioned.fill(
              child: Transform.rotate(
                angle: progress * .22,
                child: const DinerSunburst(color: AppColors.pop, opacity: .09),
              ),
            ),
            SafeArea(
              child: Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(AppDimensions.spaceLg),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(
                      maxWidth: DinerTokens.readingWidth,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Transform.translate(
                          offset: Offset(0, (1 - slam) * 18),
                          child: Transform.rotate(
                            angle: (1 - slam) * -.12,
                            child: JudgeBite(
                              pose: progress < .42
                                  ? JudgeBitePose.stern
                                  : JudgeBitePose.celebrating,
                              dimension:
                                  DinerTokens.heroJudge + AppDimensions.spaceLg,
                            ),
                          ),
                        ),
                        const SizedBox(height: AppDimensions.spaceLg),
                        Transform.scale(
                          scale: 1.7 - .7 * slam,
                          child: Opacity(
                            opacity: slam.clamp(0, 1),
                            child: DinerSignText(
                              context.l10n.diner_reveal,
                              size: DinerTokens.headline,
                            ),
                          ),
                        ),
                        const SizedBox(height: AppDimensions.spaceLg),
                        if (progress > .68)
                          Transform.rotate(
                            angle: -.09,
                            child: DinerStamp(context.l10n.diner_caseClosed),
                          ),
                        const SizedBox(height: AppDimensions.spaceMd),
                        TextButton(
                          onPressed: onSkip,
                          style: TextButton.styleFrom(
                            foregroundColor: AppColors.background,
                          ),
                          child: Text(context.l10n.diner_revealNow),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ConfettiPainter extends CustomPainter {
  _ConfettiPainter(this.progress);
  final double progress;
  @override
  void paint(Canvas canvas, Size size) {
    if (progress <= 0 || progress >= 1) return;
    final random = math.Random(42);
    for (var i = 0; i < 42; i++) {
      final x = random.nextDouble() * size.width;
      final delay = random.nextDouble() * .25;
      final t = ((progress - delay) / (1 - delay)).clamp(0.0, 1.0);
      if (t <= 0) continue;
      final y = -24 + t * (size.height + 72);
      final sway = math.sin(t * math.pi * 3 + i) * 35;
      final color = [AppColors.primary, AppColors.pop, AppColors.accent][i % 3];
      canvas.save();
      canvas.translate(x + sway, y);
      canvas.rotate(t * 7 + i);
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          const Rect.fromLTWH(-4, -7, 8, 14),
          const Radius.circular(2),
        ),
        Paint()..color = color.withValues(alpha: (1 - t * t).clamp(0, 1)),
      );
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(covariant _ConfettiPainter oldDelegate) =>
      progress != oldDelegate.progress;
}
