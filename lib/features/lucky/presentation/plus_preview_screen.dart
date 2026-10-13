import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../config/routes/app_router.dart';
import '../../../core/theme/theme.dart';
import '../../../core/utils/l10n_extensions.dart';
import '../../../core/widgets/widgets.dart';
import '../../onboarding/presentation/complete_onboarding.dart';

/// Approved price presentation. Purchasing is deliberately not simulated.
class PlusPreviewScreen extends ConsumerStatefulWidget {
  const PlusPreviewScreen({this.fromOnboarding = false, super.key});

  /// Final first-run offer; every exit continues the real or resumed case.
  final bool fromOnboarding;
  @override
  ConsumerState<PlusPreviewScreen> createState() => _PlusPreviewScreenState();
}

class _PlusPreviewScreenState extends ConsumerState<PlusPreviewScreen> {
  bool _yearly = true, _continuing = false;

  Future<void> _continue() async {
    if (_continuing) return;
    if (!widget.fromOnboarding) {
      context.canPop() ? context.pop() : context.go(AppRouter.home);
      return;
    }
    setState(() => _continuing = true);
    try {
      await completeOnboarding(context, ref);
    } catch (_) {
      if (mounted) {
        setState(() => _continuing = false);
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
    return PopScope(
      canPop: !widget.fromOnboarding && !_continuing,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop && widget.fromOnboarding && !_continuing) _continue();
      },
      child: DinerScaffold(
        title: l.plus_hint,
        showBack: !widget.fromOnboarding,
        trailing: widget.fromOnboarding
            ? IconButton(
                key: const Key('welcome-offer-close'),
                tooltip: l.common_close,
                onPressed: _continuing ? null : _continue,
                icon: const Icon(Icons.close_rounded, color: AppColors.accent),
              )
            : null,
        maxWidth: DinerTokens.readingWidth,
        bottomAction: widget.fromOnboarding
            ? DinerButton(
                key: const Key('welcome-offer-continue'),
                label: l.plus_continueFree,
                style: DinerButtonStyle.mustard,
                loading: _continuing,
                onPressed: _continuing ? null : _continue,
              )
            : null,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            DinerEntrance(child: DinerHeading(l.plus_title)),
            const SizedBox(height: AppDimensions.spaceMd),
            if (widget.fromOnboarding) ...[
              Text(
                l.plus_preview,
                style: const TextStyle(fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: AppDimensions.spaceSm),
              Text(l.plus_notConnected),
              const SizedBox(height: AppDimensions.spaceMd),
            ],
            JudgeBite(
              pose: JudgeBitePose.pointing,
              dimension: widget.fromOnboarding
                  ? DinerTokens.rulingJudge
                  : DinerTokens.heroJudge,
            ),
            DinerTicket(
              dashed: true,
              child: Column(
                children: [
                  if (widget.fromOnboarding)
                    DinerSection(l.plus_unlimited)
                  else
                    DinerHeading(l.plus_unlimited),
                  const SizedBox(height: AppDimensions.spaceMd),
                  Text(l.plus_details, textAlign: TextAlign.center),
                ],
              ),
            ),
            const SizedBox(height: AppDimensions.spaceLg),
            DinerChoice(
              label: '${l.plus_year}\n${l.plus_value}',
              selected: _yearly,
              onTap: () => setState(() => _yearly = true),
            ),
            const SizedBox(height: AppDimensions.spaceMd),
            DinerChoice(
              label: l.plus_month,
              selected: !_yearly,
              onTap: () => setState(() => _yearly = false),
            ),
            const SizedBox(height: AppDimensions.spaceLg),
            if (!widget.fromOnboarding)
              DinerTicket(
                child: Column(
                  children: [
                    Text(
                      l.plus_preview,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: AppDimensions.spaceSm),
                    Text(l.plus_notConnected, textAlign: TextAlign.center),
                  ],
                ),
              ),
            const SizedBox(height: AppDimensions.spaceLg),
            if (!widget.fromOnboarding)
              DinerButton(
                key: const Key('welcome-offer-continue'),
                label: l.plus_continueFree,
                style: DinerButtonStyle.mustard,
                loading: _continuing,
                onPressed: _continuing ? null : _continue,
              ),
          ],
        ),
      ),
    );
  }
}
