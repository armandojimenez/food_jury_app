import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../config/routes/app_router.dart';
import '../../../core/providers/judge_tone_provider.dart';
import '../../../core/services/court_feedback.dart';
import '../../../core/theme/theme.dart';
import '../../../core/utils/l10n_extensions.dart';
import '../../../core/widgets/widgets.dart';
import '../../decision/data/models/verdict.dart';
import '../../lucky/data/court_providers.dart';
import '../data/onboarding_store.dart';
import 'complete_onboarding.dart';

/// A short, skippable introduction with a local, clearly labeled demonstration.
class OnboardingScreen extends ConsumerStatefulWidget {
  /// Creates the welcome flow. Replays use the same harmless demonstration.
  const OnboardingScreen({this.replay = false, super.key});

  /// Settings replays teach the flow without showing the first-run offer again.
  final bool replay;

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen>
    with SingleTickerProviderStateMixin {
  int _step = 0;
  bool _smart = false, _evidence = false, _saving = false;
  String? _demoWinner;
  JudgeTone? _selectedTone;
  bool _demoRunning = false;
  late final AnimationController _demo =
      AnimationController(vsync: this, duration: DinerTokens.entrance * 2)
        ..addStatusListener((status) {
          if (status == AnimationStatus.completed && _demoRunning && mounted) {
            setState(() => _demoRunning = false);
            CourtFeedback.play(context, ref, CourtCue.verdict);
          }
        });

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_demoRunning && reduceDinerMotion(context)) {
      _demo.value = 1;
    }
  }

  @override
  void dispose() {
    _demo.dispose();
    super.dispose();
  }

  void _tryDemo() {
    if (_demoRunning || _saving) return;
    final reduced = reduceDinerMotion(context);
    setState(() {
      _demoWinner = _smart || Random().nextBool() ? 'Tacos' : 'Pizza';
      _demoRunning = !reduced;
    });
    if (reduced) {
      _demo.value = 1;
    } else {
      _demo.forward(from: 0);
    }
  }

  void _changeMethod() {
    _demo.stop();
    setState(() {
      _demoRunning = false;
      _demoWinner = null;
    });
  }

  Future<void> _finish({bool skip = false}) async {
    if (_saving) return;
    _demo.stop();
    setState(() {
      _saving = true;
      _demoRunning = false;
    });
    try {
      if (_selectedTone != null) {
        await ref.read(judgeToneProvider.notifier).select(_selectedTone!);
      }
      if (!mounted) return;
      if (widget.replay && skip) {
        context.canPop() ? context.pop() : context.go(AppRouter.home);
      } else if (widget.replay || ref.read(premiumAccessProvider)) {
        await completeOnboarding(context, ref);
      } else {
        context.go(AppRouter.plus, extra: const OnboardingOfferRouteData());
      }
    } catch (_) {
      if (mounted) {
        setState(() => _saving = false);
        AppSnackbar.showError(
          context,
          message: context.l10n.error_genericMessage,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final JudgeTone savedTone = ref.watch(judgeToneProvider);
    final JudgeTone tone = _selectedTone ?? savedTone;
    final labels = [
      l.tone_stern,
      l.tone_sassy,
      l.tone_enthusiastic,
      l.tone_chill,
    ];
    final previews = [
      l.welcome_sternPreview,
      l.welcome_sassyPreview,
      l.welcome_enthusiasticPreview,
      l.welcome_chillPreview,
    ];
    final poses = [
      JudgeBitePose.stern,
      JudgeBitePose.whispering,
      JudgeBitePose.excited,
      JudgeBitePose.idle,
    ];
    return AnimatedBuilder(
      animation: _demo,
      builder: (context, _) => DinerScaffold(
        // Each step starts at its heading, including after a scrolled demo.
        key: ValueKey(_step),
        title: l.welcome_title,
        showBack: false,
        maxWidth: DinerTokens.readingWidth,
        trailing: TextButton(
          key: const Key('welcome-skip'),
          onPressed: _saving ? null : () => _finish(skip: true),
          style: TextButton.styleFrom(foregroundColor: AppColors.accent),
          child: Text(l.welcome_skip),
        ),
        bottomAction: DinerButton(
          key: Key(
            _step == 0 && (_demoWinner == null || _demoRunning)
                ? 'welcome-try-demo'
                : 'welcome-next',
          ),
          label: _step == 0 && (_demoWinner == null || _demoRunning)
              ? (_demoRunning ? l.welcome_deliberating : l.welcome_tryDemo)
              : _step == 2
              ? l.welcome_start
              : l.welcome_next,
          style: DinerButtonStyle.mustard,
          loading: _saving || _demoRunning,
          icon: _step == 0 && _demoWinner == null || _step == 2
              ? Icons.gavel_rounded
              : Icons.arrow_forward_rounded,
          onPressed: _saving || _demoRunning
              ? null
              : () {
                  if (_step == 0 && _demoWinner == null) {
                    _tryDemo();
                  } else if (_step < 2) {
                    setState(() => _step++);
                  } else {
                    _finish();
                  }
                },
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              l.welcome_step(_step + 1),
              style: Theme.of(context).textTheme.labelLarge,
            ),
            const SizedBox(height: AppDimensions.spaceSm),
            LinearProgressIndicator(
              value: (_step + 1) / 3,
              color: AppColors.primary,
            ),
            const SizedBox(height: AppDimensions.spaceMd),
            AnimatedSwitcher(
              duration: reduceDinerMotion(context)
                  ? Duration.zero
                  : DinerTokens.press,
              child: Column(
                key: ValueKey(_step),
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  LayoutBuilder(
                    builder: (context, box) {
                      final heading = DinerHeading(switch (_step) {
                        0 => l.welcome_methodsTitle,
                        1 => l.welcome_evidenceTitle,
                        _ => l.welcome_toneTitle,
                      });
                      final judge = JudgeBite(
                        pose: _step == 0
                            ? _demoWinner == null
                                  ? JudgeBitePose.bench
                                  : _demoRunning && _demo.value < .5
                                  ? JudgeBitePose.thinking
                                  : JudgeBitePose.bell
                            : _step == 1
                            ? JudgeBitePose.inspecting
                            : poses[tone.index],
                        dimension: _step == 0
                            ? DinerTokens.rulingInset
                            : DinerTokens.rulingJudge,
                      );
                      if (MediaQuery.textScalerOf(context).scale(1) >=
                          DinerTokens.largeTextBreakpoint) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            heading,
                            Center(child: judge),
                          ],
                        );
                      }
                      return Row(
                        children: [
                          Expanded(child: heading),
                          const SizedBox(width: AppDimensions.spaceSm),
                          judge,
                        ],
                      );
                    },
                  ),
                  const SizedBox(height: AppDimensions.spaceMd),
                  if (_step == 0) ...[
                    Text(l.welcome_methodsBody),
                    const SizedBox(height: AppDimensions.spaceMd),
                    if (_demoWinner == null) ...[
                      DinerChoice(
                        key: const Key('welcome-lucky'),
                        label: l.welcome_lucky,
                        selected: !_smart,
                        onTap: () => setState(() => _smart = false),
                      ),
                      const SizedBox(height: AppDimensions.spaceSm),
                      DinerChoice(
                        key: const Key('welcome-smart'),
                        label: l.welcome_smart,
                        selected: _smart,
                        onTap: () => setState(() => _smart = true),
                      ),
                    ] else
                      Text(
                        _smart ? l.welcome_smart : l.welcome_lucky,
                        style: const TextStyle(fontWeight: FontWeight.w800),
                      ),
                    const SizedBox(height: AppDimensions.spaceMd),
                    _practiceCard(context),
                  ] else if (_step == 1) ...[
                    Text(l.welcome_evidenceBody),
                    const SizedBox(height: AppDimensions.spaceMd),
                    DinerChoice(
                      key: const Key('welcome-evidence'),
                      label: l.welcome_evidenceToggle,
                      selected: _evidence,
                      onTap: () => setState(() => _evidence = !_evidence),
                    ),
                    const SizedBox(height: AppDimensions.spaceMd),
                    DinerTicket(
                      dashed: true,
                      child: Text(
                        _evidence
                            ? l.welcome_evidenceExample
                            : l.welcome_evidenceEmpty,
                      ),
                    ),
                    const SizedBox(height: AppDimensions.spaceMd),
                    Text(
                      l.welcome_photoPrivacy,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ] else ...[
                    Text(l.welcome_toneBody),
                    const SizedBox(height: AppDimensions.spaceMd),
                    LayoutBuilder(
                      builder: (context, box) {
                        final single =
                            MediaQuery.textScalerOf(context).scale(1) >=
                            DinerTokens.largeTextBreakpoint;
                        return Wrap(
                          spacing: AppDimensions.spaceSm,
                          runSpacing: AppDimensions.spaceSm,
                          children: [
                            for (final value in JudgeTone.values)
                              SizedBox(
                                width: single
                                    ? box.maxWidth
                                    : (box.maxWidth - AppDimensions.spaceSm) /
                                          2,
                                child: DinerChoice(
                                  key: ValueKey('welcome-tone-${value.name}'),
                                  label: labels[value.index],
                                  selected: tone == value,
                                  onTap: () =>
                                      setState(() => _selectedTone = value),
                                ),
                              ),
                          ],
                        );
                      },
                    ),
                    const SizedBox(height: AppDimensions.spaceMd),
                    DinerTicket(
                      dashed: true,
                      child: Semantics(
                        liveRegion: true,
                        child: Text(previews[tone.index]),
                      ),
                    ),
                    const SizedBox(height: AppDimensions.spaceMd),
                    Text(l.welcome_readyMessage),
                  ],
                ],
              ),
            ),
            if (_step > 0)
              Padding(
                padding: const EdgeInsets.only(top: AppDimensions.spaceMd),
                child: TextButton(
                  onPressed: _saving ? null : () => setState(() => _step--),
                  child: Text(l.common_back),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _practiceCard(BuildContext context) {
    final l = context.l10n;
    final progress = _demoWinner == null
        ? 0.0
        : _demoRunning
        ? _demo.value
        : 1.0;
    final revealed = _demoWinner != null && progress >= .45;
    final stamped = _demoWinner != null && progress >= .8;
    return DinerTicket(
      dashed: true,
      padding: const EdgeInsets.all(AppDimensions.spaceMd),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            l.welcome_demo,
            style: const TextStyle(fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: AppDimensions.spaceSm),
          if (_demoWinner == null) ...[
            Text(l.welcome_demoGoal),
            const SizedBox(height: AppDimensions.spaceMd),
            Row(
              children: [
                Expanded(
                  child: _demoFood('Pizza', l.welcome_waitTime, 'pizza'),
                ),
                const SizedBox(width: AppDimensions.spaceSm),
                Expanded(
                  child: _demoFood('Tacos', l.welcome_readyNow, 'tacos'),
                ),
              ],
            ),
          ] else if (!revealed)
            SizedBox(
              height: DinerTokens.rulingJudge,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Transform.rotate(
                    angle: sin(progress * pi * 6) * .18,
                    child: const Icon(
                      Icons.gavel_rounded,
                      size: DinerTokens.touchTarget,
                    ),
                  ),
                  const SizedBox(height: AppDimensions.spaceSm),
                  Semantics(
                    liveRegion: true,
                    child: Text(l.welcome_deliberating),
                  ),
                ],
              ),
            )
          else ...[
            Center(
              child: Transform.scale(
                scale: reduceDinerMotion(context)
                    ? 1
                    : .8 +
                          .2 *
                              Curves.easeOutBack.transform(
                                ((progress - .45) / .35).clamp(0.0, 1.0),
                              ),
                child: FoodIllustration(
                  name: _demoWinner!,
                  illustrationId: _demoWinner == 'Tacos' ? 'tacos' : 'pizza',
                  size: DinerTokens.rulingInset,
                ),
              ),
            ),
            const SizedBox(height: AppDimensions.spaceMd),
            if (stamped)
              Semantics(
                key: const Key('welcome-demo-result'),
                liveRegion: true,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    DinerStamp(l.welcome_demoWinner(_demoWinner!)),
                    const SizedBox(height: AppDimensions.spaceMd),
                    Text(
                      _smart
                          ? l.welcome_smartDemo
                          : l.welcome_luckyDemo(_demoWinner!),
                    ),
                  ],
                ),
              ),
            if (!_demoRunning) ...[
              const SizedBox(height: AppDimensions.spaceSm),
              Wrap(
                alignment: WrapAlignment.center,
                spacing: AppDimensions.spaceSm,
                children: [
                  TextButton.icon(
                    key: const Key('welcome-replay-demo'),
                    onPressed: _saving ? null : _tryDemo,
                    icon: const Icon(Icons.replay_rounded),
                    label: Text(l.welcome_replayDemo),
                  ),
                  TextButton(
                    key: const Key('welcome-change-method'),
                    onPressed: _saving ? null : _changeMethod,
                    child: Text(l.welcome_changeMethod),
                  ),
                ],
              ),
            ],
          ],
        ],
      ),
    );
  }

  Widget _demoFood(String name, String note, String illustrationId) => Column(
    children: [
      FoodIllustration(
        name: name,
        illustrationId: illustrationId,
        size: DinerTokens.thumbnail,
      ),
      Text(name, style: const TextStyle(fontWeight: FontWeight.w800)),
      Text(
        note,
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.bodySmall,
      ),
    ],
  );
}
