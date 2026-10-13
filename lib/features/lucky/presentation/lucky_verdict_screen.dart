import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../config/routes/app_router.dart';
import '../../../core/theme/theme.dart';
import '../../../core/services/court_feedback.dart';
import '../../../core/utils/l10n_extensions.dart';
import '../../../core/widgets/widgets.dart';
import '../../moments/presentation/verdict_receipt.dart';
import '../../moments/presentation/case_objection.dart';
import '../../moments/presentation/saved_case_moment.dart';
import '../../moments/presentation/meal_feedback_card.dart';
import '../../case_shelf/presentation/case_shelf_widgets.dart';
import '../../../data/providers/verdict_provider.dart';
import '../../decision/data/models/verdict.dart';
import '../data/court_providers.dart';
import '../data/decision_case.dart';
import 'court_components.dart';
import 'lucky_draw_screen.dart';
import 'winner_hero.dart';

/// An honest random verdict: saved banter, original case, no invented analysis.
class LuckyVerdictScreen extends ConsumerStatefulWidget {
  const LuckyVerdictScreen({
    required this.verdict,
    this.saved = false,
    this.animate = true,
    this.previousWinnerId,
    super.key,
  });
  final Verdict verdict;
  final bool saved, animate;
  final String? previousWinnerId;
  @override
  ConsumerState<LuckyVerdictScreen> createState() => _LuckyVerdictScreenState();
}

class _LuckyVerdictScreenState extends ConsumerState<LuckyVerdictScreen>
    with SingleTickerProviderStateMixin {
  late bool _saved = widget.saved;
  bool _busy = false, _sharing = false, _started = false;
  bool _justSaved = false;
  String? _error;
  final _shareKey = GlobalKey();
  late final _celebration = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1400),
  );
  DecisionCase get _case => DecisionCase(
    options: widget.verdict.caseOptions,
    objective: widget.verdict.objective,
  );
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (reduceDinerMotion(context) || !widget.animate) {
      _celebration.stop();
      _celebration.value = 1;
    } else if (!_started) {
      _started = true;
      _celebration.forward();
    }
  }

  @override
  void dispose() {
    _celebration.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (_saved || _busy) return;
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      await ref
          .read(verdictNotifierProvider.notifier)
          .saveVerdict(widget.verdict);
      if (mounted) {
        setState(() {
          _saved = true;
          _justSaved = true;
          _busy = false;
        });
        CourtFeedback.play(context, ref, CourtCue.file);
      }
    } catch (_) {
      if (mounted) {
        setState(() {
          _busy = false;
          _error = context.l10n.lucky_saveError;
        });
      }
    }
  }

  Future<void> _reroll() async {
    if (_busy) return;
    setState(() => _busy = true);
    try {
      final verdict = await ref
          .read(luckyCourtProvider)
          .draw(
            caseData: _case,
            method: widget.verdict.random!.method,
            tone: widget.verdict.judgeTone,
            locale: Localizations.localeOf(context),
          );
      if (!mounted) return;
      setState(() => _busy = false);
      context.pushReplacement(
        AppRouter.draw,
        extra: DrawRouteData(
          verdict: verdict,
          repeat: true,
          previousWinnerId: widget.verdict.winner.id,
        ),
      );
    } catch (_) {
      if (mounted) {
        setState(() {
          _busy = false;
          _error = context.l10n.lucky_drawError;
        });
      }
    }
  }

  Future<void> _share() async {
    if (_sharing) return;
    setState(() => _sharing = true);
    try {
      await showVerdictReceipt(context, widget.verdict);
    } finally {
      if (mounted) setState(() => _sharing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n, verdict = widget.verdict;
    return PopScope(
      canPop: !_busy,
      child: DinerBusyBoundary(
        busy: _busy,
        child: Stack(
          children: [
            DinerScaffold(
              title: l.lucky_randomLabel,
              bottomAction: _saved
                  ? SavedCaseMoment(animate: _justSaved, compact: true)
                  : DinerButton(
                      key: const Key('save-lucky'),
                      label: _saved ? l.lucky_saved : l.lucky_save,
                      loading: _busy,
                      style: DinerButtonStyle.mustard,
                      icon: _saved
                          ? Icons.check_circle_outline
                          : Icons.bookmark_add_outlined,
                      onPressed: _saved ? null : _save,
                    ),
              child: LayoutBuilder(
                builder: (context, box) {
                  final wide =
                      box.maxWidth >= DinerTokens.tabletBreakpoint &&
                      MediaQuery.textScalerOf(context).scale(1) <
                          DinerTokens.largeTextBreakpoint;
                  final hero = Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      DinerEntrance(
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: DinerStamp(l.lucky_closed),
                        ),
                      ),
                      const SizedBox(height: AppDimensions.spaceMd),
                      DinerEntrance(
                        order: 1,
                        child: Semantics(
                          liveRegion: true,
                          container: true,
                          excludeSemantics: true,
                          label:
                              '${verdict.winner.name}. ${verdict.random!.method.title(context)}. ${verdict.displayRuling}. ${l.lucky_equalOdds}',
                          child: DinerPosterHeading(
                            '${verdict.winner.name} ${l.lucky_winner}',
                            large: wide,
                            center: true,
                          ),
                        ),
                      ),
                      const SizedBox(height: AppDimensions.spaceSm),
                      DinerEntrance(
                        order: 2,
                        child: Hero(
                          tag: 'winner-${verdict.id}',
                          child: WinnerHero(option: verdict.winner),
                        ),
                      ),
                      const SizedBox(height: AppDimensions.spaceMd),
                    ],
                  );
                  final ruling = Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      if (widget.previousWinnerId == verdict.winner.id) ...[
                        JudgeAside(
                          moment: JudgeMoment.repeatWinner,
                          eventId: verdict.id,
                          compact: true,
                        ),
                        const SizedBox(height: AppDimensions.spaceMd),
                      ],
                      DinerEntrance(
                        order: 3,
                        child: DinerVoucher(
                          child: Column(
                            children: [
                              Text(
                                '“${verdict.displayRuling}”',
                                textAlign: TextAlign.center,
                                style: Theme.of(context).textTheme.titleLarge,
                              ),
                              const Divider(height: AppDimensions.spaceLg),
                              Text(
                                verdict.random!.method.title(context),
                                textAlign: TextAlign.center,
                                style: Theme.of(context).textTheme.labelLarge,
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: AppDimensions.spaceLg),
                      if (_error != null)
                        Padding(
                          padding: const EdgeInsets.only(
                            bottom: AppDimensions.spaceMd,
                          ),
                          child: Semantics(
                            liveRegion: true,
                            child: Text(_error!),
                          ),
                        ),
                      DinerButton(
                        key: _shareKey,
                        label: l.diner_share,
                        icon: Icons.ios_share_rounded,
                        style: DinerButtonStyle.outline,
                        onPressed: _sharing ? null : _share,
                      ),
                      const SizedBox(height: AppDimensions.spaceMd),
                      Wrap(
                        alignment: WrapAlignment.spaceEvenly,
                        spacing: AppDimensions.spaceSm,
                        runSpacing: AppDimensions.spaceSm,
                        children: [
                          TextButton(
                            key: const Key('replay-lucky'),
                            onPressed: () => context.push(
                              AppRouter.draw,
                              extra: DrawRouteData(
                                verdict: verdict,
                                replay: true,
                              ),
                            ),
                            child: Text(l.lucky_replay),
                          ),
                          TextButton(
                            key: const Key('reroll-lucky'),
                            onPressed: _reroll,
                            child: Text(l.lucky_reroll),
                          ),
                        ],
                      ),
                      Text(
                        l.lucky_rerollNote,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      const SizedBox(height: AppDimensions.spaceMd),
                      DinerButton(
                        key: const Key('objection-lucky'),
                        label: l.moments_objection,
                        icon: Icons.gavel_rounded,
                        style: DinerButtonStyle.outline,
                        onPressed: () {
                          CourtFeedback.play(context, ref, CourtCue.objection);
                          showCaseObjection(context, ref, verdict);
                        },
                      ),
                      const SizedBox(height: AppDimensions.spaceMd),
                      DinerButton(
                        label: l.lucky_otherMethod,
                        style: DinerButtonStyle.outline,
                        onPressed: () =>
                            context.push(AppRouter.methods, extra: _case),
                      ),
                      const SizedBox(height: AppDimensions.spaceMd),
                      DinerButton(
                        label: l.lucky_newCase,
                        onPressed: () => openShelfCase(context, ref),
                      ),
                      if (_saved) ...[
                        const SizedBox(height: AppDimensions.spaceLg),
                        MealFeedbackCard(verdictId: verdict.id),
                      ],
                      const SizedBox(height: AppDimensions.spaceLg),
                      DinerSection(l.lucky_caseDetails),
                      const SizedBox(height: AppDimensions.spaceMd),
                      for (final option in verdict.caseOptions)
                        Padding(
                          padding: const EdgeInsets.only(
                            bottom: AppDimensions.spaceMd,
                          ),
                          child: Row(
                            children: [
                              DinerFoodImage(
                                bytes: option.imageBytes,
                                foodName: option.name,
                                illustrationId: option.illustrationId,
                                size: DinerTokens.historyThumbnail,
                              ),
                              const SizedBox(width: AppDimensions.spaceMd),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      option.name,
                                      style: Theme.of(
                                        context,
                                      ).textTheme.titleMedium,
                                    ),
                                    if (option.notes?.isNotEmpty == true)
                                      Text(option.notes!),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  );
                  if (wide) {
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(flex: 6, child: hero),
                        const SizedBox(width: DinerTokens.columnGap),
                        Expanded(flex: 5, child: ruling),
                      ],
                    );
                  }
                  return Column(children: [hero, ruling]);
                },
              ),
            ),
            Positioned.fill(
              child: IgnorePointer(
                child: AnimatedBuilder(
                  animation: _celebration,
                  builder: (context, _) => CustomPaint(
                    painter: _CelebrationPainter(_celebration.value),
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

class _CelebrationPainter extends CustomPainter {
  const _CelebrationPainter(this.progress);
  final double progress;
  @override
  void paint(Canvas canvas, Size size) {
    if (progress == 0 || progress >= 1) return;
    for (var i = 0; i < 24; i++) {
      final angle = i * 2.39996;
      final spread = progress * (100 + i * 13);
      final origin = Offset(
        size.width / 2 + math.cos(angle) * spread,
        size.height * .25 +
            math.sin(angle) * spread +
            progress * progress * 240,
      );
      canvas.save();
      canvas.translate(origin.dx, origin.dy);
      canvas.rotate(angle + progress * 5);
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          const Rect.fromLTWH(-3, -6, 6, 12),
          const Radius.circular(2),
        ),
        Paint()
          ..color = [
            AppColors.primary,
            AppColors.pop,
            AppColors.success,
          ][i % 3].withValues(alpha: 1 - progress),
      );
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(_CelebrationPainter old) => old.progress != progress;
}
