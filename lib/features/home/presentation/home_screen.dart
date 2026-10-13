import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../config/routes/app_router.dart';
import '../../../core/theme/theme.dart';
import '../../../core/utils/l10n_extensions.dart';
import '../../../core/widgets/widgets.dart';
import '../../../data/providers/verdict_provider.dart';
import '../../decision/data/models/verdict.dart';
import '../../case_shelf/data/case_shelf_provider.dart';
import '../../case_shelf/presentation/case_shelf_widgets.dart';
import '../../lucky/data/court_providers.dart';
import '../../lucky/presentation/court_components.dart';
import '../../lucky/presentation/ai_allowance_ticket.dart';

/// The diner counter: one clear next action and the user's real recent cases.
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) => DinerScaffold(
    showLogo: true,
    showBack: false,
    navigationIndex: 0,
    trailing: DinerIconButton(
      icon: Icons.settings_outlined,
      label: context.l10n.settings_screenTitle,
      onPressed: () => context.push(AppRouter.settings),
    ),
    child: LayoutBuilder(
      builder: (context, constraints) {
        final wide =
            constraints.maxWidth >= DinerTokens.tabletBreakpoint &&
            MediaQuery.textScalerOf(context).scale(1) <
                DinerTokens.largeTextBreakpoint;
        final recentValue = ref.watch(recentVerdictsProvider);
        final shelf = ref.watch(caseShelfProvider).asData?.value;
        final returning =
            recentValue.asData?.value.isNotEmpty == true ||
            shelf?.draft != null ||
            shelf?.sets.isNotEmpty == true;
        final welcome = _Welcome(wide: wide, returning: returning);
        final recent = _RecentCases(
          value: recentValue,
          retry: () => ref.invalidate(recentVerdictsProvider),
        );
        if (wide) {
          return Padding(
            padding: const EdgeInsets.symmetric(
              vertical: AppDimensions.spaceXl,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(flex: 6, child: welcome),
                const SizedBox(width: DinerTokens.columnGap),
                Expanded(
                  flex: 5,
                  child: Padding(
                    padding: const EdgeInsets.only(top: AppDimensions.spaceXl),
                    child: DinerEntrance(
                      order: 2,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const CaseShelfPanel(),
                          recent,
                          const SizedBox(height: AppDimensions.spaceXxl),
                          const _HouseRules(),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        }
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            welcome,
            const SizedBox(height: AppDimensions.spaceLg),
            const CaseShelfPanel(),
            DinerEntrance(order: 2, child: recent),
          ],
        );
      },
    ),
  );
}

class _Welcome extends ConsumerWidget {
  const _Welcome({required this.wide, required this.returning});
  final bool wide;
  final bool returning;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final exhausted =
        !ref.watch(premiumAccessProvider) &&
        ref.watch(aiAllowanceProvider).asData?.value == 0;
    if (returning) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          DinerEntrance(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (MediaQuery.textScalerOf(context).scale(1) <
                    DinerTokens.largeTextBreakpoint) ...[
                  const JudgeBite(
                    pose: JudgeBitePose.bench,
                    dimension: DinerTokens.rulingJudge,
                  ),
                  const SizedBox(width: AppDimensions.spaceMd),
                ],
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      DinerHeading(context.l10n.shelf_returnTitle),
                      const SizedBox(height: AppDimensions.spaceSm),
                      Text(context.l10n.shelf_returnHint),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppDimensions.spaceMd),
          DinerButton(
            label: context.l10n.shelf_new,
            icon: Icons.add_rounded,
            style: DinerButtonStyle.mustard,
            onPressed: () => openShelfCase(context, ref),
          ),
          const SizedBox(height: AppDimensions.spaceSm),
          const _JuryEntry(),
          const SizedBox(height: AppDimensions.spaceMd),
          const AiAllowanceTicket(),
        ],
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        DinerEntrance(
          child: DinerPosterHeading(
            exhausted
                ? context.l10n.lucky_sameJudge
                : context.l10n.diner_homeTitle,
            center: true,
            large: wide,
          ),
        ),
        const SizedBox(height: AppDimensions.spaceSm),
        DinerEntrance(
          order: 1,
          child: Text(
            exhausted
                ? context.l10n.lucky_exhausted
                : context.l10n.diner_homeSubtitle,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ),
        const SizedBox(height: AppDimensions.spaceMd),
        DinerEntrance(
          order: 1,
          child: DinerCharacterStage(
            pose: exhausted ? JudgeBitePose.plate : JudgeBitePose.idle,
            large: wide,
            bubble: context.l10n.diner_welcome,
            footer: DinerButton(
              label: context.l10n.diner_startCase,
              icon: Icons.gavel_rounded,
              style: DinerButtonStyle.mustard,
              onPressed: () => openShelfCase(context, ref),
            ),
          ),
        ),
        const SizedBox(height: AppDimensions.spaceLg),
        const AiAllowanceTicket(),
        const SizedBox(height: AppDimensions.spaceMd),
        const _JuryEntry(),
      ],
    );
  }
}

class _JuryEntry extends StatelessWidget {
  const _JuryEntry();
  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      DinerButton(
        label: context.l10n.shelf_jury,
        icon: Icons.groups_outlined,
        style: DinerButtonStyle.outline,
        onPressed: () => context.push('/jury'),
      ),
      const SizedBox(height: AppDimensions.spaceXs),
      Text(
        context.l10n.shelf_juryHint,
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.bodySmall,
      ),
    ],
  );
}

class _HouseRules extends StatelessWidget {
  const _HouseRules();
  @override
  Widget build(BuildContext context) {
    final steps = [
      context.l10n.diner_houseStepOne,
      context.l10n.diner_houseStepTwo,
      context.l10n.diner_houseStepThree,
    ];
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: AppDimensions.spaceLg),
          child: DinerTicket(
            dashed: true,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ConstrainedBox(
                  constraints: const BoxConstraints(
                    minHeight: DinerTokens.thumbnail,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(
                      right: DinerTokens.thumbnail,
                    ),
                    child: DinerSection(context.l10n.diner_houseRules),
                  ),
                ),
                const SizedBox(height: AppDimensions.spaceMd),
                for (var i = 0; i < steps.length; i++)
                  Padding(
                    padding: const EdgeInsets.only(
                      bottom: AppDimensions.spaceMd,
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        DecoratedBox(
                          decoration: const BoxDecoration(
                            color: AppColors.pop,
                            shape: BoxShape.circle,
                          ),
                          child: SizedBox.square(
                            dimension: AppDimensions.spaceXl,
                            child: Center(
                              child: Text(
                                '${i + 1}',
                                style: const TextStyle(
                                  color: AppColors.accent,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: AppDimensions.spaceSm),
                        Expanded(
                          child: Text(
                            steps[i],
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ),
        const Positioned(
          top: -AppDimensions.spaceLg,
          right: -AppDimensions.spaceSm,
          child: JudgeBite(
            pose: JudgeBitePose.pointing,
            dimension: DinerTokens.rulingJudge,
          ),
        ),
      ],
    );
  }
}

class _RecentCases extends StatelessWidget {
  const _RecentCases({required this.value, required this.retry});
  final AsyncValue<List<Verdict>> value;
  final VoidCallback retry;
  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      DinerSection(
        context.l10n.diner_recent,
        action: TextButton(
          onPressed: () => context.go(AppRouter.history),
          child: Text(context.l10n.diner_viewAll),
        ),
      ),
      const SizedBox(height: AppDimensions.spaceSm),
      value.when(
        data: (cases) => cases.isEmpty
            ? DinerTicket(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      context.l10n.diner_emptyArchive,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: AppDimensions.spaceSm),
                    Text(context.l10n.diner_archiveHint),
                  ],
                ),
              )
            : Column(
                children: [
                  for (final verdict in cases.take(3))
                    VerdictHistoryRow(verdict: verdict),
                ],
              ),
        loading: () => const Padding(
          padding: EdgeInsets.all(AppDimensions.spaceLg),
          child: Center(child: AppLoadingIndicator()),
        ),
        error: (error, stack) => DinerTicket(
          child: Column(
            children: [
              Text(context.l10n.error_genericMessage),
              TextButton(
                onPressed: retry,
                child: Text(context.l10n.common_retry),
              ),
            ],
          ),
        ),
      ),
    ],
  );
}

/// Shared actual-photo history row used by the counter and the archive.
class VerdictHistoryRow extends StatelessWidget {
  const VerdictHistoryRow({
    required this.verdict,
    this.onDelete,
    this.onReopen,
    this.mealStatus,
    super.key,
  });
  final Verdict verdict;
  final VoidCallback? onDelete;
  final VoidCallback? onReopen;

  /// Optional user-reported meal experience, separate from the judge's ruling.
  final String? mealStatus;
  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context).toLanguageTag();
    final date = DateFormat.MMMd(locale).format(verdict.createdAt);
    return Padding(
      padding: const EdgeInsets.only(bottom: AppDimensions.spaceSm),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: AppDimensions.borderRadiusMd,
          onTap: () => context.push(
            AppRouter.verdict,
            extra: VerdictRouteData(
              verdict: verdict,
              showRevealAnimation: false,
              saved: true,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              vertical: AppDimensions.spaceSm,
            ),
            child: Row(
              children: [
                DinerFoodImage(
                  bytes: verdict.winner.imageBytes,
                  foodName: verdict.winner.name,
                  illustrationId: verdict.winner.illustrationId,
                  label: context.l10n.a11y_photoOf(verdict.winner.name),
                  size: DinerTokens.historyThumbnail,
                ),
                const SizedBox(width: AppDimensions.spaceMd),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        verdict.winner.name,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: AppDimensions.spaceXs),
                      Text(
                        '${verdict.isRandom ? verdict.random!.method.title(context) : context.l10n.lucky_aiLabel} · $date',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                      ),
                      if (mealStatus != null) ...[
                        const SizedBox(height: AppDimensions.spaceXs),
                        Row(
                          children: [
                            const Icon(
                              Icons.check_circle_outline,
                              size: AppDimensions.iconSizeSm,
                            ),
                            const SizedBox(width: AppDimensions.spaceXs),
                            Expanded(
                              child: Text(
                                mealStatus!,
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
                if (onDelete != null || onReopen != null)
                  PopupMenuButton<String>(
                    tooltip: context.l10n.shelf_caseActions,
                    onSelected: (action) {
                      if (action == 'reopen') onReopen?.call();
                      if (action == 'delete') onDelete?.call();
                    },
                    itemBuilder: (_) => [
                      if (onReopen != null)
                        PopupMenuItem(
                          value: 'reopen',
                          child: Text(context.l10n.shelf_reopen),
                        ),
                      if (onDelete != null)
                        PopupMenuItem(
                          value: 'delete',
                          child: Text(context.l10n.common_delete),
                        ),
                    ],
                    icon: const Icon(Icons.more_horiz_rounded),
                  )
                else
                  const Icon(Icons.chevron_right_rounded),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
