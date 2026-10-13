import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';

import '../../../config/routes/app_router.dart';
import '../../../core/theme/theme.dart';
import '../../../core/services/court_feedback.dart';
import '../../../core/utils/l10n_extensions.dart';
import '../../../core/widgets/widgets.dart';
import '../data/case_shelf_models.dart';
import '../data/case_shelf_provider.dart';

/// Opens a case without silently replacing a different unfinished draft.
Future<void> openShelfCase(
  BuildContext context,
  WidgetRef ref, {
  CaseDraft? draft,
}) async {
  try {
    final current = await ref.read(caseShelfProvider.future);
    if (!context.mounted) return;
    if (current.draft != null && current.draft != draft) {
      final replace = await AppDialog.showConfirmation(
        context,
        title: context.l10n.shelf_replaceTitle,
        message: context.l10n.shelf_replaceHint,
        confirmText: context.l10n.shelf_replace,
        cancelText: context.l10n.common_cancel,
      );
      if (!replace || !context.mounted) return;
    }
    final store = ref.read(caseShelfStoreProvider);
    if (draft == null) {
      await store.discardDraft();
    } else {
      await store.saveDraft(draft);
    }
    if (!context.mounted) return;
    await context.push(AppRouter.newDecision, extra: draft ?? UniqueKey());
  } catch (_) {
    if (context.mounted) {
      AppSnackbar.showError(
        context,
        message: context.l10n.error_genericMessage,
      );
    }
  }
}

/// Names and saves a reusable lineup while keeping its evidence intact.
Future<void> saveCaseSetDialog(BuildContext context, CaseDraft draft) =>
    showDialog<void>(
      context: context,
      animationStyle: reduceDinerMotion(context)
          ? AnimationStyle.noAnimation
          : null,
      builder: (_) => _SaveCaseSetDialog(draft: draft),
    );

class _SaveCaseSetDialog extends ConsumerStatefulWidget {
  const _SaveCaseSetDialog({required this.draft});
  final CaseDraft draft;
  @override
  ConsumerState<_SaveCaseSetDialog> createState() => _SaveCaseSetDialogState();
}

class _SaveCaseSetDialogState extends ConsumerState<_SaveCaseSetDialog> {
  final _name = TextEditingController();
  final _form = GlobalKey<FormState>();
  final _id = const Uuid().v4();
  bool _busy = false;
  String? _error;

  @override
  void dispose() {
    _name.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (_busy || _form.currentState?.validate() != true) return;
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      await ref
          .read(caseShelfStoreProvider)
          .saveSet(
            SavedCaseSet(id: _id, name: _name.text.trim(), draft: widget.draft),
          );
      if (!mounted) return;
      AppSnackbar.showSuccess(context, message: context.l10n.shelf_setSaved);
      Navigator.pop(context);
    } catch (_) {
      if (mounted) {
        setState(() {
          _busy = false;
          _error = context.l10n.error_genericMessage;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) => PopScope(
    canPop: !_busy,
    child: Dialog(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(AppDimensions.spaceLg),
        child: Form(
          key: _form,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              DinerHeading(context.l10n.shelf_title),
              const SizedBox(height: AppDimensions.spaceMd),
              TextFormField(
                key: const Key('case-set-name'),
                controller: _name,
                enabled: !_busy,
                autofocus: true,
                maxLength: 60,
                textCapitalization: TextCapitalization.sentences,
                decoration: InputDecoration(
                  labelText: context.l10n.shelf_setName,
                  hintText: context.l10n.shelf_setHint,
                ),
                validator: (value) => value == null || value.trim().isEmpty
                    ? context.l10n.shelf_nameRequired
                    : null,
                onFieldSubmitted: (_) => _save(),
              ),
              if (_error != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: AppDimensions.spaceMd),
                  child: Text(_error!),
                ),
              DinerButton(
                key: const Key('save-case-set'),
                label: context.l10n.shelf_saveLineup,
                style: DinerButtonStyle.mustard,
                loading: _busy,
                onPressed: _busy ? null : _save,
              ),
              TextButton(
                onPressed: _busy ? null : () => Navigator.pop(context),
                child: Text(context.l10n.common_cancel),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

/// Compact resume and reusable-lineup shelf for the home counter.
class CaseShelfPanel extends ConsumerWidget {
  const CaseShelfPanel({super.key});

  Future<void> _discard(BuildContext context, WidgetRef ref) async {
    final confirmed = await AppDialog.showConfirmation(
      context,
      title: context.l10n.shelf_discardTitle,
      message: context.l10n.shelf_discardHint,
      confirmText: context.l10n.shelf_discard,
      cancelText: context.l10n.common_cancel,
    );
    if (!confirmed || !context.mounted) return;
    try {
      await ref.read(caseShelfStoreProvider).discardDraft();
    } catch (_) {
      if (context.mounted) {
        AppSnackbar.showError(
          context,
          message: context.l10n.error_genericMessage,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) => ref
      .watch(caseShelfProvider)
      .when(
        loading: () => const SizedBox.shrink(),
        error: (_, _) => DinerTicket(
          child: Column(
            children: [
              Text(context.l10n.error_genericMessage),
              TextButton(
                onPressed: () => ref.invalidate(caseShelfProvider),
                child: Text(context.l10n.common_retry),
              ),
            ],
          ),
        ),
        data: (shelf) => Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (shelf.draft case final draft?) ...[
              DinerTicket(
                dashed: true,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.description_outlined),
                        const SizedBox(width: AppDimensions.spaceSm),
                        Expanded(
                          child: Text(
                            context.l10n.shelf_resume,
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                        ),
                        DinerIconButton(
                          icon: Icons.delete_outline,
                          label: context.l10n.shelf_discard,
                          onPressed: () => _discard(context, ref),
                        ),
                      ],
                    ),
                    Text(
                      draft.options.map((option) => option.name).join(' · '),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: AppDimensions.spaceSm),
                    Text(
                      context.l10n.shelf_draftHint,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    const SizedBox(height: AppDimensions.spaceMd),
                    DinerButton(
                      key: const Key('resume-case'),
                      label: context.l10n.shelf_resume,
                      style: DinerButtonStyle.mustard,
                      icon: Icons.arrow_forward_rounded,
                      onPressed: () =>
                          openShelfCase(context, ref, draft: draft),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppDimensions.spaceLg),
            ],
            if (shelf.sets.isNotEmpty) ...[
              DinerSection(
                context.l10n.shelf_title,
                action: TextButton(
                  onPressed: () async {
                    final selected = await showModalBottomSheet<SavedCaseSet>(
                      context: context,
                      useSafeArea: true,
                      isScrollControlled: true,
                      showDragHandle: true,
                      sheetAnimationStyle: reduceDinerMotion(context)
                          ? AnimationStyle.noAnimation
                          : null,
                      builder: (_) => const _ManageCaseSets(),
                    );
                    if (selected != null && context.mounted) {
                      await openShelfCase(context, ref, draft: selected.draft);
                    }
                  },
                  child: Text(context.l10n.shelf_manage),
                ),
              ),
              const SizedBox(height: AppDimensions.spaceSm),
              for (final value in shelf.sets.take(3)) _CaseSetRow(value: value),
              const SizedBox(height: AppDimensions.spaceLg),
            ],
          ],
        ),
      );
}

class _CaseSetRow extends ConsumerWidget {
  const _CaseSetRow({required this.value, this.onOpen});
  final SavedCaseSet value;
  final VoidCallback? onOpen;

  @override
  Widget build(BuildContext context, WidgetRef ref) => Padding(
    padding: const EdgeInsets.only(bottom: AppDimensions.spaceSm),
    child: Material(
      color: Colors.transparent,
      child: InkWell(
        key: ValueKey('case-set-${value.id}'),
        borderRadius: AppDimensions.borderRadiusMd,
        enableFeedback: false,
        onTap: () {
          CourtFeedback.play(context, ref, CourtCue.selection);
          if (onOpen != null) {
            onOpen!();
          } else {
            openShelfCase(context, ref, draft: value.draft);
          }
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: AppDimensions.spaceSm),
          child: Row(
            children: [
              DinerFoodImage(
                foodName: value.draft.options.first.name,
                bytes: value.draft.options.first.imageBytes,
                illustrationId: value.draft.options.first.illustrationId,
                size: DinerTokens.historyThumbnail,
              ),
              const SizedBox(width: AppDimensions.spaceMd),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      value.name,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    Text(
                      value.draft.options
                          .map((option) => option.name)
                          .join(' · '),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppDimensions.spaceSm),
              const Icon(Icons.chevron_right_rounded),
            ],
          ),
        ),
      ),
    ),
  );
}

class _ManageCaseSets extends ConsumerWidget {
  const _ManageCaseSets();

  Future<void> _delete(
    BuildContext context,
    WidgetRef ref,
    SavedCaseSet value,
  ) async {
    final confirmed = await AppDialog.showConfirmation(
      context,
      title: context.l10n.shelf_setDeleteTitle,
      message: context.l10n.shelf_setDeleteHint,
      confirmText: context.l10n.common_delete,
      cancelText: context.l10n.common_cancel,
    );
    if (!confirmed || !context.mounted) return;
    try {
      await ref.read(caseShelfStoreProvider).deleteSet(value.id);
    } catch (_) {
      if (context.mounted) {
        AppSnackbar.showError(
          context,
          message: context.l10n.error_genericMessage,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) => ConstrainedBox(
    constraints: BoxConstraints(
      maxHeight: (MediaQuery.sizeOf(context).height - DinerTokens.headerHeight)
          .clamp(DinerTokens.touchTarget, MediaQuery.sizeOf(context).height),
    ),
    child: ref
        .watch(caseShelfProvider)
        .when(
          loading: () => const Center(child: AppLoadingIndicator()),
          error: (_, _) => Padding(
            padding: const EdgeInsets.all(AppDimensions.spaceLg),
            child: Text(context.l10n.error_genericMessage),
          ),
          data: (shelf) => ListView.builder(
            shrinkWrap: true,
            padding: const EdgeInsets.all(AppDimensions.spaceLg),
            itemCount: shelf.sets.length + 1,
            itemBuilder: (context, index) {
              if (index == 0) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: AppDimensions.spaceLg),
                  child: DinerHeading(context.l10n.shelf_title),
                );
              }
              final value = shelf.sets[index - 1];
              return Row(
                children: [
                  Expanded(
                    child: _CaseSetRow(
                      value: value,
                      onOpen: () => Navigator.pop(context, value),
                    ),
                  ),
                  DinerIconButton(
                    icon: Icons.delete_outline,
                    label: context.l10n.common_delete,
                    onPressed: () => _delete(context, ref, value),
                  ),
                ],
              );
            },
          ),
        ),
  );
}
