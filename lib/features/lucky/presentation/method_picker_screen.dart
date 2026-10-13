import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../config/routes/app_router.dart';
import '../../../core/providers/judge_tone_provider.dart';
import '../../../core/providers/ai_consent_provider.dart';
import '../../../core/services/ai_gateway_service.dart';
import '../../../core/widgets/ai_consent_sheet.dart';
import '../../../core/theme/theme.dart';
import '../../../core/services/court_feedback.dart';
import '../../moments/presentation/smart_error_copy.dart';
import '../../case_shelf/data/case_shelf_models.dart';
import '../../case_shelf/presentation/case_shelf_widgets.dart';
import '../../../core/utils/l10n_extensions.dart';
import '../../../core/widgets/widgets.dart';
import '../../../data/database/app_database.dart';
import '../../decision/data/models/verdict.dart';
import '../../decision/presentation/new_decision_screen.dart';
import '../data/court_providers.dart';
import '../data/decision_case.dart';
import 'court_components.dart';
import 'lucky_draw_screen.dart';

/// Explicit navigation origin: a historical case has no live editor to pop to.
class MethodRouteData {
  const MethodRouteData(this.caseData, {this.returnToEditor = false});
  final DecisionCase caseData;
  final bool returnToEditor;
}

/// Keeps the whole case intact while choosing AI or a free offline ritual.
class MethodPickerScreen extends ConsumerStatefulWidget {
  const MethodPickerScreen({
    required this.caseData,
    this.returnToEditor = false,
    super.key,
  });
  final DecisionCase caseData;
  final bool returnToEditor;
  @override
  ConsumerState<MethodPickerScreen> createState() => _MethodPickerScreenState();
}

class _MethodPickerScreenState extends ConsumerState<MethodPickerScreen> {
  RandomMethod _method = RandomMethod.wheel;
  bool _busy = false, _selectionTouched = false, _aiBusy = false;
  AiAttempt? _attempt;
  String? _error;
  bool _failedSmart = false;
  @override
  void initState() {
    super.initState();
    _loadMethod();
  }

  Future<void> _loadMethod() async {
    final prefs = await SharedPreferences.getInstance();
    final stored = prefs.getString('lucky_method');
    final method = RandomMethod.values
        .where((m) => m.name == stored)
        .firstOrNull;
    if (mounted && !_selectionTouched && method != null && _available(method)) {
      setState(() => _method = method);
    }
  }

  bool _available(RandomMethod m) =>
      m != RandomMethod.coin || widget.caseData.options.length == 2;
  Future<void> _select(RandomMethod m) async {
    if (!_available(m) || _busy) return;
    setState(() {
      _selectionTouched = true;
      _method = m;
    });
    CourtFeedback.play(context, ref, CourtCue.selection);
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('lucky_method', m.name);
    } catch (_) {
      // The selection remains usable if persisting this preference fails.
    }
  }

  Future<void> _draw() async {
    if (_busy) return;
    setState(() {
      _busy = true;
      _error = null;
      _failedSmart = false;
    });
    try {
      await ref.read(judgeToneProvider.notifier).ready;
      if (!mounted) return;
      final verdict = await ref
          .read(luckyCourtProvider)
          .draw(
            caseData: widget.caseData,
            method: _method,
            tone: ref.read(judgeToneProvider),
            locale: Localizations.localeOf(context),
          );
      if (!mounted) return;
      setState(() => _busy = false);
      await context.push(
        AppRouter.draw,
        extra: DrawRouteData(verdict: verdict),
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

  Future<void> _askAi() async {
    if (_busy) return;
    setState(() {
      _busy = true;
      _error = null;
      _failedSmart = false;
    });
    final permitted = await ensureAiDataConsent(context, ref);
    if (!mounted) return;
    if (!permitted) {
      setState(() => _busy = false);
      return;
    }
    if (!ref.read(premiumAccessProvider) &&
        ref.read(aiAllowanceProvider).asData?.value == 1) {
      final confirmed = await AppDialog.showConfirmation(
        context,
        title: context.l10n.lucky_lastAi,
        message: context.l10n.lucky_lastConfirm,
        confirmText: context.l10n.lucky_useLast,
        cancelText: context.l10n.lucky_useFree,
      );
      if (!mounted) return;
      if (!confirmed) {
        setState(() => _busy = false);
        return;
      }
    }
    setState(() => _aiBusy = true);
    _attempt ??= AiAttempt(widget.caseData, Localizations.localeOf(context));
    try {
      final verdict = await ref.read(aiCourtProvider).decide(_attempt!);
      if (!mounted) return;
      _attempt = null;
      setState(() {
        _busy = false;
        _aiBusy = false;
      });
      await context.push(AppRouter.verdict, extra: verdict);
    } on AiAllowanceExhausted {
      if (mounted) {
        ref.invalidate(aiAllowanceProvider);
        setState(() {
          _busy = false;
          _aiBusy = false;
        });
      }
    } catch (error) {
      final needsConsent =
          error is AiGatewayException &&
          (error.code == AiGatewayError.consentRequired ||
              error.code == AiGatewayError.consentOutdated);
      if (needsConsent && mounted) {
        try {
          await ref.read(aiConsentProvider.notifier).revoke();
        } catch (_) {
          // The notifier still blocks new requests; the next sheet can retry.
        }
      }
      if (mounted) {
        setState(() {
          _busy = false;
          _aiBusy = false;
          _failedSmart = true;
          _error = needsConsent
              ? context.l10n.consent_updated
              : smartRulingError(context.l10n, error);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final allowance = ref.watch(aiAllowanceProvider);
    final premium = ref.watch(premiumAccessProvider);
    final remaining = allowance.asData?.value;
    // A result may already be saved while its secure usage mirror needs repair.
    // Retrying that operation stays available; AiCourt still checks quota before
    // generating anything new and returns an existing result without charging.
    final retryAttempt = _failedSmart && _attempt != null;
    final exhausted = !premium && remaining == 0 && !retryAttempt;
    return PopScope(
      canPop: !_busy,
      child: Stack(
        children: [
          DinerBusyBoundary(
            busy: _busy,
            child: DinerScaffold(
              title: l.lucky_title,
              bottomAction: DinerButton(
                key: const Key('start-lucky'),
                label: _method.title(context),
                icon: Icons.arrow_forward_rounded,
                style: DinerButtonStyle.mustard,
                onPressed: _draw,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  DinerEntrance(child: DinerPosterHeading(l.lucky_chooseTitle)),
                  const SizedBox(height: AppDimensions.spaceSm),
                  Text(l.moments_chooseHint),
                  const SizedBox(height: AppDimensions.spaceLg),
                  DinerEntrance(
                    order: 1,
                    child: DinerTicket(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              JudgeBite(
                                pose: exhausted
                                    ? JudgeBitePose.stern
                                    : JudgeBitePose.thinking,
                                dimension: DinerTokens.historyThumbnail,
                              ),
                              const SizedBox(width: AppDimensions.spaceMd),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      l.moments_smartHeading,
                                      style: Theme.of(
                                        context,
                                      ).textTheme.titleLarge,
                                    ),
                                    Text(
                                      exhausted
                                          ? l.lucky_exhausted
                                          : l.moments_smartHint,
                                    ),
                                    if (!premium && remaining != null)
                                      Padding(
                                        padding: const EdgeInsets.only(
                                          top: AppDimensions.spaceSm,
                                        ),
                                        child: Text(
                                          remaining == 1
                                              ? l.lucky_lastAi
                                              : l.lucky_remaining(remaining),
                                          style: const TextStyle(
                                            fontWeight: FontWeight.w800,
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: AppDimensions.spaceMd),
                          if (!premium &&
                              allowance.hasError &&
                              !retryAttempt) ...[
                            Text(l.moments_allowanceUnavailable),
                            const SizedBox(height: AppDimensions.spaceSm),
                            DinerButton(
                              label: l.common_retry,
                              style: DinerButtonStyle.outline,
                              onPressed: () =>
                                  ref.invalidate(aiAllowanceProvider),
                            ),
                          ] else
                            DinerButton(
                              key: const Key('ask-ai'),
                              label: retryAttempt
                                  ? l.common_retry
                                  : exhausted
                                  ? l.plus_explore
                                  : l.lucky_aiButton,
                              icon: exhausted
                                  ? Icons.auto_awesome
                                  : Icons.gavel_rounded,
                              style: DinerButtonStyle.outline,
                              onPressed: exhausted
                                  ? () => context.push(AppRouter.plus)
                                  : (retryAttempt ||
                                        premium ||
                                        remaining != null)
                                  ? _askAi
                                  : null,
                            ),
                          if (_failedSmart && _error != null) ...[
                            const SizedBox(height: AppDimensions.spaceMd),
                            Semantics(liveRegion: true, child: Text(_error!)),
                            const SizedBox(height: AppDimensions.spaceSm),
                            DinerButton(
                              key: const Key('recover-lucky'),
                              label: l.moments_recoverLucky,
                              style: DinerButtonStyle.mustard,
                              onPressed: _draw,
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: AppDimensions.spaceLg),
                  DinerSection(l.lucky_freeTitle),
                  const SizedBox(height: AppDimensions.spaceSm),
                  Text(
                    l.moments_luckyHint,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontWeight: FontWeight.w800),
                  ),
                  const SizedBox(height: AppDimensions.spaceLg),
                  LayoutBuilder(
                    builder: (context, box) {
                      final single =
                          box.maxWidth < CourtTokens.minimumPairWidth ||
                          MediaQuery.textScalerOf(context).scale(1) >=
                              DinerTokens.largeTextBreakpoint;
                      final columns = single
                          ? 1
                          : box.maxWidth >= DinerTokens.tabletBreakpoint
                          ? 4
                          : 2;
                      final width =
                          (box.maxWidth -
                              (columns - 1) * AppDimensions.spaceMd) /
                          columns;
                      return Wrap(
                        spacing: AppDimensions.spaceMd,
                        runSpacing: AppDimensions.spaceMd,
                        children: [
                          for (final method in RandomMethod.values)
                            SizedBox(
                              width: width,
                              child: Semantics(
                                button: true,
                                selected: _method == method,
                                enabled: _available(method),
                                child: Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                    key: ValueKey('method-${method.name}'),
                                    borderRadius: AppDimensions.borderRadiusMd,
                                    onTap: _available(method)
                                        ? () => _select(method)
                                        : null,
                                    child: DinerTicket(
                                      raised: true,
                                      color: _method == method
                                          ? AppColors.pop
                                          : null,
                                      child: DefaultTextStyle.merge(
                                        style: _method == method
                                            ? const TextStyle(
                                                color: AppColors.accent,
                                              )
                                            : null,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                MethodEmblem(method, size: 48),
                                                const Spacer(),
                                                if (_method == method)
                                                  const Icon(
                                                    Icons.check_rounded,
                                                    color: AppColors.accent,
                                                  ),
                                              ],
                                            ),
                                            const SizedBox(
                                              height: AppDimensions.spaceSm,
                                            ),
                                            Text(
                                              method.title(context),
                                              style: TextStyle(
                                                fontFamily: 'Bangers',
                                                fontSize:
                                                    DinerTokens.sectionType,
                                                color: _method == method
                                                    ? AppColors.accent
                                                    : null,
                                              ),
                                            ),
                                            const SizedBox(
                                              height: AppDimensions.spaceSm,
                                            ),
                                            Text(
                                              _available(method)
                                                  ? _methodHint(context, method)
                                                  : l.lucky_coinNeedsTwo,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                        ],
                      );
                    },
                  ),
                  const SizedBox(height: AppDimensions.spaceLg),
                  DropdownButtonFormField<JudgeTone>(
                    initialValue: ref.watch(judgeToneProvider),
                    isExpanded: true,
                    decoration: InputDecoration(
                      labelText: l.settings_judgePersonality,
                    ),
                    items: [
                      for (final tone in JudgeTone.values)
                        DropdownMenuItem(
                          value: tone,
                          child: Text(_toneName(context, tone)),
                        ),
                    ],
                    onChanged: (tone) {
                      if (tone != null) {
                        ref.read(judgeToneProvider.notifier).select(tone);
                      }
                    },
                  ),
                  const SizedBox(height: AppDimensions.spaceMd),
                  Text(
                    l.lucky_goalNote,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  if (_error != null && !_failedSmart)
                    Padding(
                      padding: const EdgeInsets.only(
                        top: AppDimensions.spaceMd,
                      ),
                      child: Semantics(liveRegion: true, child: Text(_error!)),
                    ),
                  const SizedBox(height: AppDimensions.spaceLg),
                  DinerButton(
                    label: l.lucky_editCase,
                    style: DinerButtonStyle.outline,
                    onPressed: () => widget.returnToEditor && context.canPop()
                        ? context.pop()
                        : openShelfCase(
                            context,
                            ref,
                            draft: CaseDraft.fromCase(widget.caseData),
                          ),
                  ),
                ],
              ),
            ),
          ),
          if (_aiBusy) const Positioned.fill(child: DinerDeliberation()),
        ],
      ),
    );
  }

  String _methodHint(BuildContext context, RandomMethod method) =>
      switch (method) {
        RandomMethod.wheel => context.l10n.moments_wheelHint,
        RandomMethod.ticket => context.l10n.moments_ticketHint,
        RandomMethod.cloche => context.l10n.moments_clocheHint,
        RandomMethod.coin => context.l10n.moments_coinHint,
      };

  String _toneName(BuildContext context, JudgeTone tone) {
    final l = context.l10n;
    return switch (tone) {
      JudgeTone.stern => l.tone_stern,
      JudgeTone.sassy => l.tone_sassy,
      JudgeTone.enthusiastic => l.tone_enthusiastic,
      JudgeTone.chill => l.tone_chill,
    };
  }
}
