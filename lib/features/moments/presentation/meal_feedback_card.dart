import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/theme.dart';
import '../../../core/utils/l10n_extensions.dart';
import '../../../core/widgets/widgets.dart';
import '../../../data/providers/database_provider.dart';
import '../data/meal_feedback_provider.dart';

/// Optional, reversible feedback for a verdict that has already been saved.
class MealFeedbackCard extends ConsumerStatefulWidget {
  const MealFeedbackCard({required this.verdictId, super.key});
  final String verdictId;
  @override
  ConsumerState<MealFeedbackCard> createState() => _MealFeedbackCardState();
}

class _MealFeedbackCardState extends ConsumerState<MealFeedbackCard> {
  bool _saving = false;
  bool _failed = false;
  Future<void> Function()? _retry;

  Future<void> _persist(Future<void> Function() action) async {
    if (_saving) return;
    setState(() {
      _saving = true;
      _failed = false;
      _retry = action;
    });
    try {
      await action();
      if (mounted) setState(() => _retry = null);
    } catch (_) {
      if (mounted) setState(() => _failed = true);
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  Future<void> _answer({required bool ate, bool? wouldAgain}) => _persist(
    () => ref
        .read(databaseProvider)
        .setMealFeedback(widget.verdictId, ate: ate, wouldAgain: wouldAgain),
  );

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final feedback = ref.watch(mealFeedbackProvider(widget.verdictId));
    return DinerTicket(
      key: const Key('meal-feedback'),
      dashed: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            l.moments_feedbackTitle,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: AppDimensions.spaceSm),
          feedback.when(
            loading: () => Text(l.moments_feedbackLoading),
            error: (_, _) => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(l.moments_feedbackLoadError),
                TextButton(
                  key: const Key('feedback-load-retry'),
                  onPressed: () =>
                      ref.invalidate(mealFeedbackProvider(widget.verdictId)),
                  child: Text(l.common_retry),
                ),
              ],
            ),
            data: (entry) => Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                DinerBusyBoundary(
                  busy: _saving,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _AnswerPair(
                        question: l.moments_feedbackChose,
                        answerKey: 'feedback-ate',
                        selected: entry?.ate,
                        onChanged: (ate) => _answer(
                          ate: ate,
                          wouldAgain: ate ? entry?.wouldAgain : null,
                        ),
                      ),
                      if (entry?.ate == true) ...[
                        const SizedBox(height: AppDimensions.spaceMd),
                        _AnswerPair(
                          question: l.moments_feedbackOrderAgain,
                          answerKey: 'feedback-again',
                          selected: entry?.wouldAgain,
                          onChanged: (again) =>
                              _answer(ate: true, wouldAgain: again),
                        ),
                      ],
                      if (entry != null)
                        Align(
                          alignment: Alignment.centerLeft,
                          child: TextButton(
                            key: const Key('feedback-clear'),
                            onPressed: () => _persist(
                              () => ref
                                  .read(databaseProvider)
                                  .deleteMealFeedback(widget.verdictId),
                            ),
                            child: Text(l.moments_feedbackClear),
                          ),
                        ),
                    ],
                  ),
                ),
                if (_saving || _failed || entry != null)
                  Semantics(
                    liveRegion: true,
                    child: Text(
                      _saving
                          ? l.moments_feedbackSaving
                          : _failed
                          ? l.moments_feedbackSaveError
                          : l.moments_feedbackSaved,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ),
                if (_failed)
                  Align(
                    alignment: Alignment.centerLeft,
                    child: TextButton(
                      key: const Key('feedback-save-retry'),
                      onPressed: _retry == null
                          ? null
                          : () => _persist(_retry!),
                      child: Text(l.common_retry),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _AnswerPair extends StatelessWidget {
  const _AnswerPair({
    required this.question,
    required this.answerKey,
    required this.selected,
    required this.onChanged,
  });
  final String question, answerKey;
  final bool? selected;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      Text(question, style: const TextStyle(fontWeight: FontWeight.w700)),
      const SizedBox(height: AppDimensions.spaceSm),
      LayoutBuilder(
        builder: (context, box) {
          final single =
              box.maxWidth < 260 ||
              MediaQuery.textScalerOf(context).scale(1) >=
                  DinerTokens.largeTextBreakpoint;
          final width = single
              ? box.maxWidth
              : (box.maxWidth - AppDimensions.spaceSm) / 2;
          return Wrap(
            spacing: AppDimensions.spaceSm,
            runSpacing: AppDimensions.spaceSm,
            children: [
              for (final answer in [true, false])
                SizedBox(
                  width: width,
                  child: DinerChoice(
                    key: Key('$answerKey-${answer ? 'yes' : 'no'}'),
                    label: answer
                        ? context.l10n.common_yes
                        : context.l10n.moments_feedbackNotThisTime,
                    selected: selected == answer,
                    onTap: () => onChanged(answer),
                  ),
                ),
            ],
          );
        },
      ),
    ],
  );
}
