import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';

import '../../../config/routes/app_router.dart';
import '../../../core/providers/ai_service_provider.dart';
import '../../../core/providers/judge_tone_provider.dart';
import '../../../core/providers/mock_ai_provider.dart';
import '../../../core/theme/theme.dart';
import '../../../core/utils/l10n_extensions.dart';
import '../../../core/widgets/widgets.dart';
import '../../../data/providers/verdict_provider.dart';
import '../data/models/food_option.dart';
import '../data/models/objective.dart';

/// Build a case from two to five food options with an explicit objective.
class NewDecisionScreen extends ConsumerStatefulWidget {
  const NewDecisionScreen({super.key});
  @override
  ConsumerState<NewDecisionScreen> createState() => _NewDecisionScreenState();
}

class _NewDecisionScreenState extends ConsumerState<NewDecisionScreen> {
  final List<FoodOption> _options = [];
  Objective? _objective;
  bool _submitting = false;
  bool get _ready => _options.length >= 2 && _objective != null && !_submitting;

  Future<void> _editOption([FoodOption? original]) async {
    if (_submitting || (original == null && _options.length >= 5)) return;
    final result = await showModalBottomSheet<FoodOption>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      sheetAnimationStyle: reduceDinerMotion(context)
          ? AnimationStyle.noAnimation
          : null,
      builder: (context) => _OptionEditor(original: original),
    );
    if (!mounted || result == null) return;
    setState(() {
      if (original == null) {
        _options.add(result);
      } else {
        final index = _options.indexWhere((o) => o.id == original.id);
        if (index >= 0) _options[index] = result;
      }
    });
  }

  Future<void> _submit() async {
    if (!_ready) return;
    setState(() => _submitting = true);
    try {
      await ref.read(judgeToneProvider.notifier).ready;
      await ref.read(mockAiNotifierProvider.notifier).ready;
      if (!mounted) return;
      final service = ref.read(aiServiceProvider);
      final verdict = await service.generateVerdict(
        options: List.unmodifiable(_options),
        objective: _objective!,
        tone: ref.read(judgeToneProvider),
        locale: Localizations.localeOf(context),
      );
      if (!mounted) return;
      await ref.read(verdictNotifierProvider.notifier).saveVerdict(verdict);
      if (!mounted) return;
      setState(() => _submitting = false);
      await context.push(AppRouter.verdict, extra: verdict);
    } catch (error) {
      if (!mounted) return;
      setState(() => _submitting = false);
      AppSnackbar.showError(
        context,
        message: context.l10n.error_genericMessage,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.watch(judgeToneProvider);
    ref.watch(mockAiNotifierProvider);
    return PopScope(
      canPop: !_submitting,
      child: Stack(
        children: [
          DinerBusyBoundary(
            busy: _submitting,
            child: DinerScaffold(
              title: context.l10n.diner_newCase,
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final wide =
                      constraints.maxWidth >= DinerTokens.tabletBreakpoint &&
                      MediaQuery.textScalerOf(context).scale(1) <
                          DinerTokens.largeTextBreakpoint;
                  final menu = Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      DinerEntrance(
                        child: DinerHeading(
                          context.l10n.diner_menuTitle,
                          large: wide,
                        ),
                      ),
                      const SizedBox(height: AppDimensions.spaceSm),
                      Text(
                        context.l10n.diner_menuHint,
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      const SizedBox(height: AppDimensions.spaceLg),
                      if (_options.isEmpty)
                        DinerEntrance(
                          order: 1,
                          child: DinerTicket(
                            child: Column(
                              children: [
                                const JudgeBite(
                                  pose: JudgeBitePose.confused,
                                  size: JudgeBiteSize.large,
                                ),
                                const SizedBox(height: AppDimensions.spaceMd),
                                Text(
                                  context.l10n.diner_emptyMenu,
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        ),
                      for (final option in _options)
                        Padding(
                          key: ValueKey(option.id),
                          padding: const EdgeInsets.only(
                            bottom: AppDimensions.spaceMd,
                          ),
                          child: DinerEntrance(
                            child: _OptionCard(
                              option: option,
                              onEdit: () => _editOption(option),
                              onRemove: () => setState(
                                () => _options.removeWhere(
                                  (o) => o.id == option.id,
                                ),
                              ),
                            ),
                          ),
                        ),
                      const SizedBox(height: AppDimensions.spaceMd),
                      if (_options.length < 5)
                        DinerButton(
                          key: const Key('add-option'),
                          label: context.l10n.diner_addAnother,
                          icon: Icons.add_rounded,
                          style: DinerButtonStyle.outline,
                          onPressed: () => _editOption(),
                        )
                      else
                        Text(
                          context.l10n.diner_maxOptions,
                          textAlign: TextAlign.center,
                        ),
                    ],
                  );
                  final choices = Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      DinerSection(context.l10n.diner_mood),
                      const SizedBox(height: AppDimensions.spaceMd),
                      LayoutBuilder(
                        builder: (context, box) {
                          final single =
                              MediaQuery.textScalerOf(context).scale(1) >= 1.7;
                          return Wrap(
                            spacing: AppDimensions.spaceSm,
                            runSpacing: AppDimensions.spaceSm,
                            children: [
                              for (final objective in Objective.values)
                                SizedBox(
                                  width: single
                                      ? box.maxWidth
                                      : (box.maxWidth - AppDimensions.spaceSm) /
                                            2,
                                  child: DinerChoice(
                                    label: objective.getLabel(context),
                                    selected: _objective == objective,
                                    onTap: () =>
                                        setState(() => _objective = objective),
                                  ),
                                ),
                            ],
                          );
                        },
                      ),
                      const SizedBox(height: AppDimensions.spaceLg),
                      AnimatedSwitcher(
                        duration: reduceDinerMotion(context)
                            ? Duration.zero
                            : DinerTokens.press,
                        child: Row(
                          key: ValueKey(_ready),
                          children: [
                            JudgeBite(
                              pose: _ready
                                  ? JudgeBitePose.excited
                                  : JudgeBitePose.thinking,
                              size: JudgeBiteSize.small,
                            ),
                            const SizedBox(width: AppDimensions.spaceSm),
                            Expanded(
                              child: Text(
                                _options.length < 2
                                    ? context.l10n.decision_addMoreOptions(
                                        2 - _options.length,
                                      )
                                    : _objective == null
                                    ? context.l10n.decision_pickYourGoal
                                    : context.l10n.decision_readyForVerdict,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: AppDimensions.spaceMd),
                      DinerButton(
                        key: const Key('submit-case'),
                        label: context.l10n.decision_letJudgeDecide,
                        icon: Icons.gavel_rounded,
                        onPressed: _ready ? _submit : null,
                      ),
                    ],
                  );
                  if (wide) {
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(flex: 6, child: menu),
                        const SizedBox(width: DinerTokens.columnGap),
                        Expanded(
                          flex: 4,
                          child: DinerEntrance(
                            order: 2,
                            child: DinerTicket(child: choices),
                          ),
                        ),
                      ],
                    );
                  }
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      menu,
                      const SizedBox(height: AppDimensions.spaceLg),
                      DinerEntrance(order: 2, child: choices),
                    ],
                  );
                },
              ),
            ),
          ),
          if (_submitting) const Positioned.fill(child: DinerDeliberation()),
        ],
      ),
    );
  }
}

class _OptionCard extends StatelessWidget {
  const _OptionCard({
    required this.option,
    required this.onEdit,
    required this.onRemove,
  });
  final FoodOption option;
  final VoidCallback onEdit;
  final VoidCallback onRemove;
  @override
  Widget build(BuildContext context) => Stack(
    clipBehavior: Clip.none,
    children: [
      Padding(
        padding: const EdgeInsets.only(top: DinerTokens.touchTarget / 2),
        child: DinerTicket(
          padding: const EdgeInsets.all(AppDimensions.spaceSm),
          child: Row(
            children: [
              DinerFoodImage(
                bytes: option.imageBytes,
                foodName: option.name,
                label: context.l10n.a11y_photoOf(option.name),
                size: MediaQuery.textScalerOf(context).scale(1) >= 1.7
                    ? DinerTokens.touchTarget
                    : DinerTokens.thumbnail,
              ),
              const SizedBox(width: AppDimensions.spaceMd),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      option.name,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    if (option.notes?.isNotEmpty == true) Text(option.notes!),
                  ],
                ),
              ),
              const SizedBox(width: AppDimensions.spaceSm),
              IconButton(
                onPressed: onEdit,
                tooltip: context.l10n.diner_editOption,
                style: IconButton.styleFrom(
                  side: BorderSide(
                    color: Theme.of(context).colorScheme.onSurface,
                    width: AppDimensions.borderMedium,
                  ),
                  shape: const RoundedRectangleBorder(
                    borderRadius: AppDimensions.borderRadiusSm,
                  ),
                ),
                icon: const Icon(Icons.edit_outlined),
              ),
            ],
          ),
        ),
      ),
      Positioned(
        top: 0,
        right: 0,
        child: IconButton(
          constraints: const BoxConstraints.tightFor(
            width: DinerTokens.touchTarget,
            height: DinerTokens.touchTarget,
          ),
          onPressed: onRemove,
          tooltip: context.l10n.a11y_removeOption(option.name),
          icon: DecoratedBox(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              shape: BoxShape.circle,
              border: Border.all(
                color: Theme.of(context).colorScheme.onSurface,
                width: DinerTokens.badgeBorder,
              ),
            ),
            child: const Padding(
              padding: EdgeInsets.all(DinerTokens.badgeInset),
              child: Icon(Icons.close_rounded, size: AppDimensions.iconSizeSm),
            ),
          ),
        ),
      ),
    ],
  );
}

class _OptionEditor extends StatefulWidget {
  const _OptionEditor({this.original});
  final FoodOption? original;
  @override
  State<_OptionEditor> createState() => _OptionEditorState();
}

class _OptionEditorState extends State<_OptionEditor> {
  final _form = GlobalKey<FormState>();
  late final _name = TextEditingController(text: widget.original?.name);
  late final _notes = TextEditingController(text: widget.original?.notes);
  late Uint8List? _bytes = widget.original?.imageBytes;
  @override
  void dispose() {
    _name.dispose();
    _notes.dispose();
    super.dispose();
  }

  void _save() {
    if (_form.currentState?.validate() != true) return;
    Navigator.pop(
      context,
      FoodOption(
        id: widget.original?.id ?? const Uuid().v4(),
        name: _name.text.trim(),
        notes: _notes.text.trim().isEmpty ? null : _notes.text.trim(),
        imageBytes: _bytes,
      ),
    );
  }

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
    padding: EdgeInsets.fromLTRB(
      AppDimensions.spaceLg,
      AppDimensions.spaceLg,
      AppDimensions.spaceLg,
      MediaQuery.viewInsetsOf(context).bottom + AppDimensions.spaceLg,
    ),
    child: Form(
      key: _form,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Expanded(
                child: DinerHeading(
                  widget.original == null
                      ? context.l10n.decision_addToYourCase
                      : context.l10n.diner_editOption,
                ),
              ),
              IconButton(
                onPressed: () => Navigator.pop(context),
                tooltip: context.l10n.common_close,
                icon: const Icon(Icons.close_rounded),
              ),
            ],
          ),
          const SizedBox(height: AppDimensions.spaceMd),
          FoodImagePicker(
            imageBytes: _bytes,
            onImageSelected: (bytes) => setState(() => _bytes = bytes),
            onImageRemoved: () => setState(() => _bytes = null),
          ),
          const SizedBox(height: AppDimensions.spaceMd),
          TextFormField(
            key: const Key('option-name'),
            controller: _name,
            textCapitalization: TextCapitalization.sentences,
            maxLength: 80,
            textInputAction: TextInputAction.next,
            decoration: InputDecoration(
              labelText: context.l10n.option_nameLabel,
              hintText: context.l10n.option_nameHint,
            ),
            validator: (value) => value == null || value.trim().isEmpty
                ? context.l10n.validation_pleaseEnterName
                : value.trim().length > 80
                ? context.l10n.diner_nameLimit
                : null,
          ),
          const SizedBox(height: AppDimensions.spaceSm),
          TextFormField(
            key: const Key('option-notes'),
            controller: _notes,
            maxLines: 2,
            maxLength: 500,
            textCapitalization: TextCapitalization.sentences,
            decoration: InputDecoration(
              labelText: context.l10n.option_notesLabel,
              hintText: context.l10n.option_notesHint,
            ),
            validator: (value) => (value?.length ?? 0) > 500
                ? context.l10n.diner_notesLimit
                : null,
          ),
          const SizedBox(height: AppDimensions.spaceMd),
          DinerButton(
            key: const Key('save-option'),
            label: widget.original == null
                ? context.l10n.option_addToCase
                : context.l10n.diner_saveOption,
            icon: Icons.check_rounded,
            style: DinerButtonStyle.mustard,
            onPressed: _save,
          ),
        ],
      ),
    ),
  );
}

/// A route-owned loading state. It blocks input without popping navigators.
class DinerDeliberation extends StatelessWidget {
  const DinerDeliberation({super.key});
  @override
  Widget build(BuildContext context) => DinerNightSurface(
    child: SafeArea(
      child: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppDimensions.spaceLg),
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: DinerTokens.readingWidth,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const JudgeBiteAnimated(
                  pose: JudgeBitePose.thinking,
                  dimension: DinerTokens.heroJudge,
                ),
                const SizedBox(height: AppDimensions.spaceLg),
                DinerSignText(context.l10n.diner_deliberating),
                const SizedBox(height: AppDimensions.spaceMd),
                Semantics(
                  liveRegion: true,
                  child: Text(
                    context.l10n.diner_weighing,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: AppColors.background,
                      fontSize: DinerTokens.bodyEmphasis,
                    ),
                  ),
                ),
                const SizedBox(height: AppDimensions.spaceLg),
                ExcludeSemantics(
                  child: SizedBox(
                    width: DinerTokens.heroJudge,
                    child: LinearProgressIndicator(
                      value: reduceDinerMotion(context) ? .7 : null,
                      color: AppColors.pop,
                      backgroundColor: AppColors.accentLight,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}
