import 'dart:math' as math;
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../config/routes/app_router.dart';
import '../../../core/theme/theme.dart';
import '../../../core/services/court_feedback.dart';
import '../../../core/utils/l10n_extensions.dart';
import '../../../core/widgets/widgets.dart';
import '../../decision/data/models/food_option.dart';
import '../../decision/data/models/verdict.dart';
import '../data/decision_case.dart';
import 'court_components.dart';
import 'winner_hero.dart';

/// A draw is chosen before this route opens. Replays never call an RNG or AI.
class DrawRouteData {
  const DrawRouteData({
    required this.verdict,
    this.replay = false,
    this.repeat = false,
    this.previousWinnerId,
  });
  final Verdict verdict;
  final bool replay, repeat;
  final String? previousWinnerId;
}

/// A short coin toss and a slower wheel get their own dramatic pacing.
Duration ritualDuration(RandomMethod method, {bool repeat = false}) {
  final milliseconds = switch (method) {
    RandomMethod.wheel => 3300,
    RandomMethod.ticket => 2700,
    RandomMethod.cloche => 2400,
    RandomMethod.coin => 2100,
  };
  return Duration(
    milliseconds: repeat ? (milliseconds * .65).round() : milliseconds,
  );
}

class LuckyDrawScreen extends ConsumerStatefulWidget {
  const LuckyDrawScreen({required this.data, super.key});
  final DrawRouteData data;
  @override
  ConsumerState<LuckyDrawScreen> createState() => _LuckyDrawScreenState();
}

class _LuckyDrawScreenState extends ConsumerState<LuckyDrawScreen>
    with SingleTickerProviderStateMixin {
  late final _controller = AnimationController(
    vsync: this,
    duration: ritualDuration(
      widget.data.verdict.random!.method,
      repeat: widget.data.repeat || widget.data.replay,
    ),
  );
  bool _started = false, _finished = false;
  @override
  void initState() {
    super.initState();
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) _finish();
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (reduceDinerMotion(context)) {
      _controller.stop();
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) _finish();
      });
    } else if (!_started) {
      _started = true;
      _controller.forward();
    }
  }

  void _finish() {
    if (_finished || !mounted || ModalRoute.of(context)?.isCurrent != true) {
      return;
    }
    _finished = true;
    CourtFeedback.play(context, ref, CourtCue.verdict);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || ModalRoute.of(context)?.isCurrent != true) return;
      if (widget.data.replay) {
        context.pop();
      } else {
        context.replace(
          AppRouter.verdict,
          extra: VerdictRouteData(
            verdict: widget.data.verdict,
            showRevealAnimation: true,
            previousWinnerId: widget.data.previousWinnerId,
          ),
        );
      }
    });
  }

  void _cancelAnimation() {
    _finished = true;
    _controller.stop();
  }

  void _cancel() {
    _cancelAnimation();
    if (context.canPop()) {
      context.pop();
    } else {
      context.go(AppRouter.home);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final method = widget.data.verdict.random!.method;
    final l = context.l10n;
    return PopScope(
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) _cancelAnimation();
      },
      child: DinerScaffold(
        title: method.title(context),
        maxWidth: DinerTokens.contentWidth,
        child: LayoutBuilder(
          builder: (context, box) {
            final wide =
                box.maxWidth >= DinerTokens.tabletBreakpoint &&
                MediaQuery.textScalerOf(context).scale(1) <
                    DinerTokens.largeTextBreakpoint;
            final scene = Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  l.lucky_stageHint,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: AppDimensions.spaceMd),
                Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(
                      maxWidth: CourtTokens.stage,
                    ),
                    child: AspectRatio(
                      aspectRatio: 1,
                      child: AnimatedBuilder(
                        animation: _controller,
                        builder: (context, _) {
                          final arrival = ((_controller.value - .84) / .13)
                              .clamp(0.0, 1.0);
                          return Stack(
                            alignment: Alignment.center,
                            children: [
                              Opacity(
                                opacity: 1 - arrival,
                                child: RitualStage(
                                  verdict: widget.data.verdict,
                                  progress: _controller.value,
                                ),
                              ),
                              if (arrival > 0)
                                Opacity(
                                  opacity: arrival,
                                  child: Transform.scale(
                                    scale:
                                        .88 +
                                        .12 *
                                            Curves.easeOutCubic.transform(
                                              arrival,
                                            ),
                                    child: Hero(
                                      tag: 'winner-${widget.data.verdict.id}',
                                      child: WinnerHero(
                                        option: widget.data.verdict.winner,
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ],
            );
            final controls = Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: AppDimensions.spaceLg),
                DinerVoucher(
                  child: Column(
                    children: [
                      Text(
                        l.lucky_equalOdds,
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontWeight: FontWeight.w800),
                      ),
                      const SizedBox(height: AppDimensions.spaceMd),
                      Wrap(
                        alignment: WrapAlignment.center,
                        spacing: AppDimensions.spaceSm,
                        runSpacing: AppDimensions.spaceSm,
                        children: [
                          for (final option in widget.data.verdict.caseOptions)
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              child: Text(
                                method == RandomMethod.coin
                                    ? '${widget.data.verdict.caseOptions.first.id == option.id ? l.lucky_heads : l.lucky_tails}: ${option.name}'
                                    : '${widget.data.verdict.caseOptions.indexOf(option) + 1}. ${option.name}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppDimensions.spaceLg),
                DinerButton(
                  key: const Key('skip-lucky'),
                  label: l.lucky_skip,
                  style: DinerButtonStyle.mustard,
                  onPressed: _finish,
                ),
                const SizedBox(height: AppDimensions.spaceSm),
                DinerButton(
                  label: l.lucky_cancel,
                  style: DinerButtonStyle.outline,
                  onPressed: _cancel,
                ),
              ],
            );
            if (wide) {
              return Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(flex: 6, child: scene),
                  const SizedBox(width: DinerTokens.columnGap),
                  Expanded(flex: 4, child: controls),
                ],
              );
            }
            return Column(children: [scene, controls]);
          },
        ),
      ),
    );
  }
}

/// Animation is a pure function of progress and an immutable result.
class RitualStage extends StatelessWidget {
  const RitualStage({required this.verdict, required this.progress, super.key});
  final Verdict verdict;
  final double progress;
  @override
  Widget build(BuildContext context) {
    final method = verdict.random!.method;
    final index = verdict.caseOptions.indexWhere(
      (o) => o.id == verdict.winner.id,
    );
    return Semantics(
      label: method.title(context),
      image: true,
      excludeSemantics: true,
      child: LayoutBuilder(
        builder: (context, box) {
          final side = box.maxWidth;
          return Stack(
            clipBehavior: Clip.none,
            children: [
              Positioned(
                right: side * .02,
                top: side * .03,
                child: DinerStar(size: side * .12),
              ),
              Positioned(
                left: 0,
                top: side * .18,
                child: DinerRays(size: side * .075),
              ),
              Positioned(
                left: side * .05,
                bottom: side * .08,
                child: DinerStar(size: side * .065),
              ),
              Positioned(
                left: side * .015,
                right: side * .06,
                top: side * .045,
                bottom: side * .09,
                child: switch (method) {
                  RandomMethod.wheel => _Plate(
                    options: verdict.caseOptions,
                    winner: index,
                    progress: progress,
                  ),
                  RandomMethod.ticket => _TicketDraw(
                    number: index + 1,
                    option: verdict.winner,
                    progress: progress,
                  ),
                  RandomMethod.cloche => _ClocheDraw(
                    option: verdict.winner,
                    progress: progress,
                  ),
                  RandomMethod.coin => _CoinDraw(
                    options: verdict.caseOptions,
                    winner: index,
                    progress: progress,
                  ),
                },
              ),
              Positioned(
                right: -side * .025,
                bottom: -side * .035,
                child: Transform.rotate(
                  angle: progress > .65
                      ? math.sin((progress - .65) * math.pi * 5) * .05
                      : 0,
                  child: JudgeBite(
                    pose: progress > .80
                        ? JudgeBitePose.celebrating
                        : progress > .60
                        ? JudgeBitePose.excited
                        : method == RandomMethod.ticket
                        ? JudgeBitePose.ticket
                        : method == RandomMethod.cloche
                        ? JudgeBitePose.whispering
                        : JudgeBitePose.inspecting,
                    dimension: side * .32,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _Plate extends StatelessWidget {
  const _Plate({
    required this.options,
    required this.winner,
    required this.progress,
  });
  final List<FoodOption> options;
  final int winner;
  final double progress;
  @override
  Widget build(BuildContext context) {
    final sweep = 2 * math.pi / options.length;
    // Segment zero starts at twelve o'clock. Its center lands under the pointer.
    final target = 2 * math.pi * CourtTokens.plateTurns - (winner + .5) * sweep;
    final t = Curves.easeOutCubic.transform((progress / .87).clamp(0, 1));
    return LayoutBuilder(
      builder: (context, box) => Stack(
        alignment: Alignment.center,
        children: [
          Transform.rotate(
            angle: target * t,
            child: AspectRatio(
              aspectRatio: 1,
              child: LayoutBuilder(
                builder: (context, c) {
                  final size = math.min(c.maxWidth, c.maxHeight);
                  return CustomPaint(
                    painter: _WheelPainter(options.length),
                    child: Stack(
                      children: [
                        for (var i = 0; i < options.length; i++)
                          Positioned(
                            left:
                                size / 2 +
                                math.cos(-math.pi / 2 + (i + .5) * sweep) *
                                    size *
                                    .29 -
                                size * .14,
                            top:
                                size / 2 +
                                math.sin(-math.pi / 2 + (i + .5) * sweep) *
                                    size *
                                    .29 -
                                size * .14,
                            child: Transform.rotate(
                              angle: -target * t,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  _RitualFood(
                                    bytes: options[i].imageBytes,
                                    foodName: options[i].name,
                                    illustrationId: options[i].illustrationId,
                                    size: size * .24,
                                  ),
                                  Text(
                                    '${i + 1}',
                                    textScaler: TextScaler.noScaling,
                                    style: TextStyle(
                                      fontFamily: 'Bangers',
                                      fontSize: size * .055,
                                      color: AppColors.accent,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
          const Align(
            alignment: Alignment.topCenter,
            child: SizedBox(
              width: 36,
              height: 44,
              child: CustomPaint(painter: _PointerPainter()),
            ),
          ),
        ],
      ),
    );
  }
}

class _WheelPainter extends CustomPainter {
  _WheelPainter(this.count);
  final int count;
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2),
        r = math.min(size.width, size.height) / 2 - 5;
    final bounds = Rect.fromCircle(center: center, radius: r - 15);
    canvas.drawCircle(
      center + const Offset(0, 7),
      r,
      Paint()..color = AppColors.porcelainShadow,
    );
    canvas.drawCircle(center, r, Paint()..color = AppColors.background);
    canvas.drawCircle(
      center,
      r - 4,
      Paint()
        ..color = AppColors.porcelainRim
        ..style = PaintingStyle.stroke
        ..strokeWidth = 5,
    );
    const colors = [
      AppColors.primary,
      AppColors.pop,
      AppColors.sage,
      AppColors.peach,
      AppColors.oat,
    ];
    for (var i = 0; i < count; i++) {
      canvas.drawArc(
        bounds,
        -math.pi / 2 + i * 2 * math.pi / count,
        2 * math.pi / count,
        true,
        Paint()..color = colors[i],
      );
      canvas.drawArc(
        bounds,
        -math.pi / 2 + i * 2 * math.pi / count,
        2 * math.pi / count,
        true,
        Paint()
          ..color = AppColors.accent
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2,
      );
    }
    canvas.drawCircle(
      center,
      r,
      Paint()
        ..color = AppColors.accent
        ..style = PaintingStyle.stroke
        ..strokeWidth = 4,
    );
    canvas.drawCircle(center, 12, Paint()..color = AppColors.accent);
    canvas.drawCircle(center, 6, Paint()..color = AppColors.background);
  }

  @override
  bool shouldRepaint(_WheelPainter old) => old.count != count;
}

class _TicketDraw extends StatelessWidget {
  const _TicketDraw({
    required this.option,
    required this.progress,
    required this.number,
  });
  final int number;
  final FoodOption option;
  final double progress;
  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, box) {
      final reveal = Curves.easeOutBack.transform(
        ((progress - .52) / .35).clamp(0, 1),
      );
      final shake = progress < .52 ? math.sin(progress * 90) * .03 : 0.0;
      return Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            left: box.maxWidth * .25,
            right: box.maxWidth * .25,
            top: box.maxHeight * .08,
            child: Opacity(
              opacity: (1 - reveal).clamp(0, 1),
              child: Transform.translate(
                offset: Offset(0, math.sin(progress * 35) * 10),
                child: Transform.rotate(
                  angle: -.12 + shake,
                  child: MethodEmblem(
                    RandomMethod.ticket,
                    size: box.maxWidth * .48,
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            top: box.maxHeight * .06,
            bottom: box.maxHeight * .17,
            left: box.maxWidth * .22,
            right: box.maxWidth * .22,
            child: Transform.translate(
              offset: Offset(0, (1 - reveal) * box.maxHeight * .4),
              child: Opacity(
                opacity: reveal.clamp(0, 1),
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: AppColors.background,
                    border: Border.all(color: AppColors.accent, width: 3),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '№ ${number.toString().padLeft(2, '0')}',
                        style: TextStyle(
                          fontFamily: 'Bangers',
                          fontSize: 24,
                          color: AppColors.accent,
                        ),
                      ),
                      const Divider(
                        color: AppColors.accent,
                        indent: 16,
                        endIndent: 16,
                      ),
                      _RitualFood(
                        bytes: option.imageBytes,
                        foodName: option.name,
                        illustrationId: option.illustrationId,
                        size: box.maxWidth * .34,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            left: box.maxWidth * .09,
            right: box.maxWidth * .09,
            bottom: box.maxHeight * .03,
            height: box.maxHeight * .36,
            child: Transform.rotate(
              angle: shake,
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  border: Border.all(color: AppColors.accent, width: 4),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: AppDimensions.shadowRetroSm,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: 8,
                      margin: const EdgeInsets.symmetric(horizontal: 25),
                      color: AppColors.accent,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      context.l10n.lucky_orderUp,
                      textScaler: TextScaler.noScaling,
                      style: TextStyle(
                        fontFamily: 'Bangers',
                        fontSize: 28,
                        color: AppColors.accent,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      );
    },
  );
}

class _ClocheDraw extends StatelessWidget {
  const _ClocheDraw({required this.option, required this.progress});
  final FoodOption option;
  final double progress;
  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, box) {
      final lift = Curves.easeInOutCubic.transform(
        ((progress - .5) / .35).clamp(0, 1),
      );
      return Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            left: box.maxWidth * .16,
            right: box.maxWidth * .16,
            bottom: box.maxHeight * .06,
            height: box.maxHeight * .66,
            child: Opacity(
              opacity: (lift * 2).clamp(0, 1),
              child: Center(
                child: _RitualFood(
                  bytes: option.imageBytes,
                  foodName: option.name,
                  illustrationId: option.illustrationId,
                  size: box.maxWidth * .55,
                ),
              ),
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: box.maxHeight * .02,
            height: box.maxHeight * .82,
            child: Transform.translate(
              offset: Offset(0, -lift * box.maxHeight * .52),
              child: Opacity(
                opacity: 1 - lift,
                child: CustomPaint(
                  painter: const MethodPainter(RandomMethod.cloche),
                ),
              ),
            ),
          ),
        ],
      );
    },
  );
}

class _CoinDraw extends StatelessWidget {
  const _CoinDraw({
    required this.options,
    required this.winner,
    required this.progress,
  });
  final List<FoodOption> options;
  final int winner;
  final double progress;
  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, box) {
      final t = Curves.easeOutCubic.transform((progress / .87).clamp(0, 1));
      final angle =
          (CourtTokens.coinTurns * 2 * math.pi + winner * math.pi) * t;
      final front = math.cos(angle) >= 0;
      final option = options[front ? 0 : 1];
      final scale = math.cos(angle).abs().clamp(.035, 1.0);
      return Center(
        child: Transform.translate(
          offset: Offset(0, -math.sin(t * math.pi) * box.maxHeight * .15),
          child: Transform.scale(
            scaleX: scale,
            child: Container(
              width: box.maxWidth * .78,
              height: box.maxWidth * .78,
              decoration: BoxDecoration(
                color: AppColors.pop,
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.accent, width: 5),
                boxShadow: const [
                  BoxShadow(color: AppColors.primary, offset: Offset(7, 7)),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.accent, width: 2),
                  ),
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          front
                              ? context.l10n.lucky_heads
                              : context.l10n.lucky_tails,
                          textScaler: TextScaler.noScaling,
                          style: const TextStyle(
                            fontFamily: 'Bangers',
                            fontSize: 24,
                            color: AppColors.accent,
                          ),
                        ),
                        _RitualFood(
                          bytes: option.imageBytes,
                          foodName: option.name,
                          illustrationId: option.illustrationId,
                          size: box.maxWidth * .38,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    },
  );
}

/// Decorative art is transparent; user photos keep a deliberate rounded frame.
class _RitualFood extends StatelessWidget {
  const _RitualFood({
    required this.foodName,
    required this.size,
    this.bytes,
    this.illustrationId,
  });
  final String foodName;
  final double size;
  final Uint8List? bytes;
  final String? illustrationId;
  @override
  Widget build(BuildContext context) => bytes != null && bytes!.isNotEmpty
      ? DinerFoodImage(
          bytes: bytes,
          foodName: foodName,
          illustrationId: illustrationId,
          size: size,
        )
      : FoodIllustration(
          name: foodName,
          illustrationId: illustrationId,
          size: size,
        );
}

class _PointerPainter extends CustomPainter {
  const _PointerPainter();
  @override
  void paint(Canvas canvas, Size size) {
    final p = Path()
      ..moveTo(4, 3)
      ..lineTo(size.width - 4, 3)
      ..quadraticBezierTo(size.width, 3, size.width - 2, 8)
      ..lineTo(size.width / 2 + 3, size.height - 3)
      ..quadraticBezierTo(
        size.width / 2,
        size.height,
        size.width / 2 - 3,
        size.height - 3,
      )
      ..lineTo(2, 8)
      ..quadraticBezierTo(0, 3, 4, 3)
      ..close();
    canvas.drawPath(p, Paint()..color = AppColors.accent);
    canvas.drawPath(
      p,
      Paint()
        ..color = AppColors.background
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2,
    );
  }

  @override
  bool shouldRepaint(_PointerPainter old) => false;
}
