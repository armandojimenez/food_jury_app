import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../core/theme/theme.dart';
import '../../../core/utils/l10n_extensions.dart';
import '../../../core/widgets/widgets.dart';
import '../../../data/providers/verdict_provider.dart';
import '../../decision/data/models/verdict.dart';
import '../../case_shelf/data/case_shelf_models.dart';
import '../../case_shelf/presentation/case_shelf_widgets.dart';
import '../../home/presentation/home_screen.dart';
import '../../moments/data/meal_feedback_provider.dart';

/// The archive keeps real saved verdicts grouped by day with recoverable errors.
class HistoryScreen extends ConsumerStatefulWidget {
  const HistoryScreen({super.key});
  @override
  ConsumerState<HistoryScreen> createState() => _HistoryScreenState();
}

enum _CaseFilter { all, smart, lucky }

class _HistoryScreenState extends ConsumerState<HistoryScreen> {
  final _search = TextEditingController();
  String _query = '';
  _CaseFilter _filter = _CaseFilter.all;

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  bool _matches(Verdict verdict) {
    if (_filter == _CaseFilter.smart && verdict.isRandom) return false;
    if (_filter == _CaseFilter.lucky && !verdict.isRandom) return false;
    final query = _query.trim().toLowerCase();
    return query.isEmpty ||
        verdict.caseOptions.any(
          (option) => '${option.name} ${option.notes ?? ''}'
              .toLowerCase()
              .contains(query),
        );
  }

  void _clearFilters() {
    _search.clear();
    setState(() {
      _query = '';
      _filter = _CaseFilter.all;
    });
  }

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
  Widget build(BuildContext context) {
    final feedback = {
      for (final entry
          in ref.watch(allMealFeedbackProvider).asData?.value ?? [])
        entry.verdictId: entry,
    };
    return DinerScaffold(
      title: context.l10n.diner_history,
      showBack: false,
      navigationIndex: 1,
      trailing: DinerIconButton(
        icon: Icons.add_rounded,
        label: context.l10n.diner_newCase,
        onPressed: () => openShelfCase(context, ref),
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
              for (final verdict in cases.where(_matches)) {
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
                            child: DinerHeading(
                              context.l10n.diner_archiveTitle,
                            ),
                          ),
                          const SizedBox(height: AppDimensions.spaceSm),
                          Text(
                            context.l10n.diner_archiveSubtitle,
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                          if (cases.isNotEmpty) ...[
                            const SizedBox(height: AppDimensions.spaceLg),
                            TextField(
                              key: const Key('history-search'),
                              controller: _search,
                              onChanged: (value) =>
                                  setState(() => _query = value),
                              decoration: InputDecoration(
                                hintText: context.l10n.shelf_search,
                                prefixIcon: const Icon(Icons.search_rounded),
                                suffixIcon: _query.isEmpty
                                    ? null
                                    : IconButton(
                                        tooltip: context.l10n.common_close,
                                        icon: const Icon(Icons.close_rounded),
                                        onPressed: () {
                                          _search.clear();
                                          setState(() => _query = '');
                                        },
                                      ),
                              ),
                            ),
                            const SizedBox(height: AppDimensions.spaceMd),
                            Wrap(
                              spacing: AppDimensions.spaceSm,
                              runSpacing: AppDimensions.spaceSm,
                              children: [
                                for (final filter in _CaseFilter.values)
                                  ChoiceChip(
                                    key: ValueKey(
                                      'history-filter-${filter.name}',
                                    ),
                                    selected: _filter == filter,
                                    onSelected: (_) =>
                                        setState(() => _filter = filter),
                                    label: Text(switch (filter) {
                                      _CaseFilter.all => context.l10n.shelf_all,
                                      _CaseFilter.smart =>
                                        context.l10n.lucky_aiLabel,
                                      _CaseFilter.lucky =>
                                        context.l10n.lucky_randomLabel,
                                    }),
                                  ),
                              ],
                            ),
                          ],
                        ],
                      ),
                    );
                  }
                  if (entries.isEmpty && cases.isNotEmpty) {
                    return DinerTicket(
                      child: Column(
                        children: [
                          const JudgeBite(
                            pose: JudgeBitePose.confused,
                            size: JudgeBiteSize.medium,
                          ),
                          Text(
                            context.l10n.shelf_noResults,
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          const SizedBox(height: AppDimensions.spaceSm),
                          TextButton(
                            onPressed: _clearFilters,
                            child: Text(context.l10n.shelf_clearFilters),
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
                          onPressed: () => openShelfCase(context, ref),
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
                  final meal = feedback[verdict.id];
                  return VerdictHistoryRow(
                    key: ValueKey(verdict.id),
                    verdict: verdict,
                    mealStatus: meal?.ate == true
                        ? meal?.wouldAgain == true
                              ? context.l10n.moments_feedbackAgain
                              : context.l10n.moments_feedbackTried
                        : null,
                    onDelete: () => _delete(context, ref, verdict),
                    onReopen: () => openShelfCase(
                      context,
                      ref,
                      draft: CaseDraft(
                        options: verdict.caseOptions,
                        objective: verdict.objective,
                      ),
                    ),
                  );
                },
              );
            },
          ),
    );
  }
}
