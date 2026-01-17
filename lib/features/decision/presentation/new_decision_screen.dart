import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/theme.dart';
import '../../../core/utils/l10n_extensions.dart';
import '../../../core/widgets/widgets.dart';
import '../data/models/food_option.dart';
import '../data/models/objective.dart';

/// New Decision Screen - where users create food decisions.
///
/// Features:
/// - Add 2-5 food options
/// - Select objective (fun, healthy, fit, quick)
/// - Judge Bite reacts to progress
/// - Submit for verdict (Phase 4: AI integration)
class NewDecisionScreen extends StatefulWidget {
  const NewDecisionScreen({super.key});

  @override
  State<NewDecisionScreen> createState() => _NewDecisionScreenState();
}

class _NewDecisionScreenState extends State<NewDecisionScreen> {
  final List<FoodOption> _options = [];
  Objective? _selectedObjective;

  /// Minimum options required to submit
  static const int _minOptions = 2;

  /// Maximum options allowed
  static const int _maxOptions = 5;

  bool get _canSubmit =>
      _options.length >= _minOptions && _selectedObjective != null;
  bool get _canAddMore => _options.length < _maxOptions;

  void _addOption(FoodOption option) {
    if (_canAddMore) {
      setState(() {
        _options.add(option);
      });
    }
  }

  void _removeOption(int index) {
    setState(() {
      _options.removeAt(index);
    });
  }

  void _selectObjective(Objective objective) {
    setState(() {
      _selectedObjective = objective;
    });
  }

  Future<void> _submitDecision() async {
    if (!_canSubmit) {
      AppSnackbar.showError(
        context,
        message: context.l10n.decision_minOptionsError,
      );
      return;
    }

    // TODO: Phase 4 - Submit to AI and navigate to verdict screen
    AppSnackbar.showInfo(context, message: 'Coming in Phase 4: AI verdict!');
  }

  void _showAddOptionSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _AddOptionSheet(onAdd: _addOption),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppRetroAppBar(
        title: context.l10n.decision_screenTitle,
        onBackPressed: () => context.pop(),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Scrollable content
            Expanded(
              child: SingleChildScrollView(
                padding: AppDimensions.screenPadding,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: AppDimensions.spaceMd),

                    // Options Section
                    _OptionsSection(
                      options: _options,
                      onRemove: _removeOption,
                      onAddMore: _canAddMore ? _showAddOptionSheet : null,
                    ),

                    const SizedBox(height: AppDimensions.spaceXxl),

                    // Objective Selector
                    _ObjectiveSection(
                      selectedObjective: _selectedObjective,
                      onSelect: _selectObjective,
                    ),

                    const SizedBox(height: AppDimensions.spaceXxl),

                    // Judge Bite reacting to progress
                    _JudgeBiteProgress(
                      optionsCount: _options.length,
                      hasObjective: _selectedObjective != null,
                    ),

                    const SizedBox(height: AppDimensions.spaceLg),
                  ],
                ),
              ),
            ),

            // Submit Button (sticky at bottom)
            Container(
              padding: AppDimensions.screenPadding,
              decoration: BoxDecoration(
                color: AppColors.background,
                border: Border(
                  top: BorderSide(
                    color: AppColors.accent,
                    width: AppDimensions.borderThick,
                  ),
                ),
              ),
              child: AppButton(
                label: context.l10n.decision_letJudgeDecide,
                icon: Icons.gavel,
                onPressed: _canSubmit ? _submitDecision : null,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Options section showing all added options and add button.
class _OptionsSection extends StatelessWidget {
  const _OptionsSection({
    required this.options,
    required this.onRemove,
    required this.onAddMore,
  });

  final List<FoodOption> options;
  final Function(int) onRemove;
  final VoidCallback? onAddMore;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section Header
        Text(
          context.l10n.decision_yourOptions,
          style: AppTypography.labelLarge.copyWith(
            color: AppColors.textSecondary,
            letterSpacing: 1.2,
          ),
        ),

        const SizedBox(height: AppDimensions.spaceMd),

        // Option Cards
        ...List.generate(options.length, (index) {
          return Padding(
            padding: const EdgeInsets.only(bottom: AppDimensions.spaceMd),
            child: _OptionCard(
              option: options[index],
              index: index,
              onRemove: () => onRemove(index),
            ),
          );
        }),

        // Add Option Button
        if (onAddMore != null) _AddOptionButton(onPressed: onAddMore!),
      ],
    );
  }
}

/// Individual option card showing name, notes, and delete button.
class _OptionCard extends StatelessWidget {
  const _OptionCard({
    required this.option,
    required this.index,
    required this.onRemove,
  });

  final FoodOption option;
  final int index;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.spaceMd),
        child: Row(
          children: [
            // Option number badge
            Container(
              width: AppDimensions.iconContainerMd,
              height: AppDimensions.iconContainerMd,
              decoration: BoxDecoration(
                color: AppColors.primaryLight,
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppColors.accent,
                  width: AppDimensions.borderThick,
                ),
              ),
              child: Center(
                child: Text(
                  '${index + 1}',
                  style: AppTypography.titleLarge.copyWith(
                    color: AppColors.primary,
                  ),
                ),
              ),
            ),

            const SizedBox(width: AppDimensions.spaceMd),

            // Option details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    option.name,
                    style: AppTypography.titleMedium.copyWith(
                      color: AppColors.textPrimary,
                    ),
                  ),
                  if (option.notes != null && option.notes!.isNotEmpty) ...[
                    const SizedBox(height: AppDimensions.spaceXs),
                    Text(
                      option.notes!,
                      style: AppTypography.bodySmall.copyWith(
                        color: AppColors.textSecondary,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ],
              ),
            ),

            const SizedBox(width: AppDimensions.spaceSm),

            // Delete button
            IconButton(
              onPressed: onRemove,
              icon: const Icon(Icons.close),
              color: AppColors.error,
              tooltip: context.l10n.common_delete,
            ),
          ],
        ),
      ),
    );
  }
}

/// Add option button (dashed border style).
class _AddOptionButton extends StatelessWidget {
  const _AddOptionButton({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      borderRadius: AppDimensions.borderRadiusMd,
      child: Container(
        padding: const EdgeInsets.all(AppDimensions.spaceLg),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: AppDimensions.borderRadiusMd,
          border: Border.all(
            color: AppColors.accent,
            width: AppDimensions.borderThick,
            strokeAlign: BorderSide.strokeAlignInside,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.add_circle_outline,
              color: AppColors.primary,
              size: AppDimensions.iconSizeMd,
            ),
            const SizedBox(width: AppDimensions.spaceSm),
            Text(
              context.l10n.decision_addOption,
              style: AppTypography.titleMedium.copyWith(
                color: AppColors.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Objective selector section.
class _ObjectiveSection extends StatelessWidget {
  const _ObjectiveSection({
    required this.selectedObjective,
    required this.onSelect,
  });

  final Objective? selectedObjective;
  final Function(Objective) onSelect;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section Header
        Text(
          context.l10n.decision_whatsYourGoal,
          style: AppTypography.labelLarge.copyWith(
            color: AppColors.textSecondary,
            letterSpacing: 1.2,
          ),
        ),

        const SizedBox(height: AppDimensions.spaceMd),

        // Objective chips
        Wrap(
          spacing: AppDimensions.spaceSm,
          runSpacing: AppDimensions.spaceSm,
          children: Objective.values.map((objective) {
            return ObjectiveChip(
              label: objective.getLabel(context),
              icon: objective.icon,
              isSelected: selectedObjective == objective,
              onTap: () => onSelect(objective),
            );
          }).toList(),
        ),
      ],
    );
  }
}

/// Judge Bite reacting to user's progress.
class _JudgeBiteProgress extends StatelessWidget {
  const _JudgeBiteProgress({
    required this.optionsCount,
    required this.hasObjective,
  });

  final int optionsCount;
  final bool hasObjective;

  JudgeBitePose get _pose {
    if (optionsCount == 0) return JudgeBitePose.confused;
    if (optionsCount >= 2 && hasObjective) return JudgeBitePose.excited;
    return JudgeBitePose.thinking;
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: JudgeBiteAnimated(pose: _pose, size: JudgeBiteSize.small),
    );
  }
}

/// Bottom sheet for adding a new option.
class _AddOptionSheet extends StatefulWidget {
  const _AddOptionSheet({required this.onAdd});

  final Function(FoodOption) onAdd;

  @override
  State<_AddOptionSheet> createState() => _AddOptionSheetState();
}

class _AddOptionSheetState extends State<_AddOptionSheet> {
  final _nameController = TextEditingController();
  final _notesController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _nameController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      final option = FoodOption(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: _nameController.text.trim(),
        notes: _notesController.text.trim().isEmpty
            ? null
            : _notesController.text.trim(),
      );

      widget.onAdd(option);
      Navigator.of(context).pop();

      AppSnackbar.showSuccess(
        context,
        message: context.l10n.snackbar_optionAdded,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(AppDimensions.bottomSheetRadius),
        ),
        border: Border.all(
          color: AppColors.accent,
          width: AppDimensions.borderThick,
        ),
      ),
      padding: EdgeInsets.only(
        left: AppDimensions.spaceLg,
        right: AppDimensions.spaceLg,
        top: AppDimensions.spaceLg,
        bottom:
            MediaQuery.of(context).viewInsets.bottom + AppDimensions.spaceLg,
      ),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Sheet Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  context.l10n.option_add,
                  style: AppTypography.headlineMedium.copyWith(
                    color: AppColors.textPrimary,
                  ),
                ),
                AppCloseButton(onPressed: () => Navigator.of(context).pop()),
              ],
            ),

            const SizedBox(height: AppDimensions.spaceLg),

            // Name field
            AppTextField(
              controller: _nameController,
              label: context.l10n.option_nameLabel,
              hint: context.l10n.option_nameHint,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter a name';
                }
                return null;
              },
            ),

            const SizedBox(height: AppDimensions.spaceMd),

            // Notes field
            AppTextField(
              controller: _notesController,
              label: context.l10n.option_notesLabel,
              hint: context.l10n.option_notesHint,
              maxLines: 3,
            ),

            const SizedBox(height: AppDimensions.spaceLg),

            // Submit button
            AppButton(label: context.l10n.option_addToCase, onPressed: _submit),

            const SizedBox(height: AppDimensions.spaceSm),
          ],
        ),
      ),
    );
  }
}
