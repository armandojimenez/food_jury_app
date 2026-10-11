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
import '../../home/presentation/home_screen.dart';

/// The archive keeps real saved verdicts grouped by day with recoverable errors.
class HistoryScreen extends ConsumerWidget {
  const HistoryScreen({super.key});

  Future<void> _delete(
    BuildContext context,
    WidgetRef ref,
    Verdict verdict,
  ) async {
    final confirmed = await AppDialog.showConfirmation(
      context,
      title: context.l10n.diner_deleteCase,
      message: context.l10n.diner_deleteCaseHint,
      confirmText: context.l10n.common_delete,
      cancelText: context.l10n.common_cancel,
    );
    if (!confirmed || !context.mounted) return;
    try {
      await ref
          .read(verdictNotifierProvider.notifier)
          .deleteVerdict(verdict.id);
      if (context.mounted) {
        AppSnackbar.showSuccess(
          context,
          message: context.l10n.snackbar_decisionDeleted,
        );
      }
    } catch (error) {
      if (context.mounted) {
        AppSnackbar.showError(
          context,
          message: context.l10n.error_genericMessage,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) => DinerScaffold(
    title: context.l10n.diner_history,
    showBack: false,
    navigationIndex: 1,
    trailing: DinerIconButton(
      icon: Icons.add_rounded,
      label: context.l10n.diner_newCase,
      onPressed: () => context.push(AppRouter.newDecision),
    ),
    maxWidth: DinerTokens.readingWidth,
    scrollable: false,
    padding: const EdgeInsets.symmetric(horizontal: DinerTokens.pageInset),
    child: ref
        .watch(verdictsProvider)
        .when(
          loading: () => const Center(child: AppLoadingIndicator()),
          error: (error, stack) => ListView(
            children: [
              const SizedBox(height: AppDimensions.spaceLg),
              DinerHeading(context.l10n.diner_archiveTitle),
              const JudgeBite(
                pose: JudgeBitePose.confused,
                size: JudgeBiteSize.large,
              ),
              Text(context.l10n.error_genericMessage),
              DinerButton(
                label: context.l10n.common_retry,
                onPressed: () => ref.invalidate(verdictsProvider),
              ),
            ],
          ),
          data: (cases) {
            final entries = <Object>[];
            DateTime? previousDay;
            for (final verdict in cases) {
              final date = verdict.createdAt.toLocal();
              final day = DateTime(date.year, date.month, date.day);
              if (day != previousDay) entries.add(day);
              entries.add(verdict);
              previousDay = day;
            }
            return ListView.builder(
              padding: const EdgeInsets.symmetric(
                vertical: DinerTokens.pageInset,
              ),
              itemCount: entries.isEmpty ? 2 : entries.length + 1,
              itemBuilder: (context, index) {
                if (index == 0) {
                  return Padding(
                    padding: const EdgeInsets.only(
                      bottom: AppDimensions.spaceLg,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        DinerEntrance(
                          child: DinerHeading(context.l10n.diner_archiveTitle),
                        ),
                        const SizedBox(height: AppDimensions.spaceSm),
                        Text(
                          context.l10n.diner_archiveSubtitle,
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                      ],
                    ),
                  );
                }
                if (entries.isEmpty) {
                  return Column(
                    children: [
                      const JudgeBiteAnimated(
                        pose: JudgeBitePose.sleeping,
                        dimension: DinerTokens.heroJudge,
                      ),
                      const SizedBox(height: AppDimensions.spaceLg),
                      Text(
                        context.l10n.diner_emptyArchive,
                        style: Theme.of(context).textTheme.titleMedium,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: AppDimensions.spaceSm),
                      Text(
                        context.l10n.diner_archiveHint,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: AppDimensions.spaceLg),
                      DinerButton(
                        label: context.l10n.diner_startCase,
                        style: DinerButtonStyle.mustard,
                        onPressed: () => context.push(AppRouter.newDecision),
                      ),
                    ],
                  );
                }
                final entry = entries[index - 1];
                if (entry is DateTime) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: AppDimensions.spaceSm,
                    ),
                    child: DinerSection(
                      DateFormat.yMMMd(
                        Localizations.localeOf(context).toLanguageTag(),
                      ).format(entry),
                    ),
                  );
                }
                final verdict = entry as Verdict;
                return VerdictHistoryRow(
                  key: ValueKey(verdict.id),
                  verdict: verdict,
                  onDelete: () => _delete(context, ref, verdict),
                );
              },
            );
          },
        ),
  );
}
