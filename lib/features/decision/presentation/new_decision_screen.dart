import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';

import '../../../config/routes/app_router.dart';
import '../../../core/services/mock_ai_service.dart';
import '../../../core/theme/theme.dart';
import '../../../core/utils/l10n_extensions.dart';
import '../../../core/widgets/widgets.dart';
import '../data/models/food_option.dart';
import '../data/models/objective.dart';
import '../data/models/verdict.dart';

/// New Decision Screen - where users create food decisions.
///
/// Features:
/// - Courtroom-themed "Exhibit" cards for options
/// - Progress indicator showing readiness
/// - Judge Bite with speech bubble reactions
/// - Smooth animations throughout
/// - Submit for verdict with mock AI
class NewDecisionScreen extends StatefulWidget {
  const NewDecisionScreen({super.key});

  @override
  State<NewDecisionScreen> createState() => _NewDecisionScreenState();
}

class _NewDecisionScreenState extends State<NewDecisionScreen> {
  final List<FoodOption> _options = [];
  Objective? _selectedObjective;
  bool _isLoading = false;

  final _mockAiService = MockAiService();

  static const int _minOptions = 2;
  static const int _maxOptions = 5;

  bool get _canSubmit =>
      _options.length >= _minOptions &&
      _selectedObjective != null &&
      !_isLoading;
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

    setState(() => _isLoading = true);

    try {
      LoadingOverlay.show(
        context,
        message: context.l10n.loading_courtInSession,
      );

      final verdict = await _mockAiService.generateVerdict(
        options: _options,
        objective: _selectedObjective!,
        tone: JudgeTone.stern,
      );

      if (!mounted) return;
      LoadingOverlay.hide(context);
      context.push(AppRouter.verdict, extra: verdict);
    } catch (e) {
      if (!mounted) return;
      LoadingOverlay.hide(context);
      AppSnackbar.showError(context, message: context.l10n.error_genericMessage);
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _showAddOptionSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _AddOptionSheet(
        onAdd: _addOption,
        optionNumber: _options.length + 1,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: isDark
                ? [
                    AppColors.backgroundDark,
                    const Color(0xFF1E1E35),
                    const Color(0xFF151525),
                  ]
                : [
                    const Color(0xFFFFF8F0),
                    const Color(0xFFFFF2E6),
                    const Color(0xFFFFEBD9),
                  ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Custom Header
              _ScreenHeader(onBack: () => context.pop()),

              // Main Content
              Expanded(
                child: SingleChildScrollView(
                  padding: AppDimensions.screenPadding,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Progress Indicator
                      _ProgressSection(
                        optionsCount: _options.length,
                        hasObjective: _selectedObjective != null,
                        minOptions: _minOptions,
                        maxOptions: _maxOptions,
                      )
                          .animate()
                          .fadeIn(duration: AppDimensions.durationMedium),

                      const SizedBox(height: AppDimensions.spaceLg),

                      // Options Section
                      _OptionsSection(
                        options: _options,
                        onRemove: _removeOption,
                        onAddMore: _canAddMore ? _showAddOptionSheet : null,
                        maxOptions: _maxOptions,
                      ),

                      const SizedBox(height: AppDimensions.spaceXl),

                      // Objective Selector
                      _ObjectiveSection(
                        selectedObjective: _selectedObjective,
                        onSelect: _selectObjective,
                      )
                          .animate()
                          .fadeIn(
                            duration: AppDimensions.durationMedium,
                            delay: const Duration(milliseconds: 200),
                          ),

                      const SizedBox(height: AppDimensions.spaceXl),

                      // Judge Bite with Speech Bubble
                      _JudgeBiteSection(
                        optionsCount: _options.length,
                        hasObjective: _selectedObjective != null,
                        canSubmit: _canSubmit,
                      ),

                      const SizedBox(height: AppDimensions.spaceXxl),
                    ],
                  ),
                ),
              ),

              // Submit Button
              _SubmitSection(
                canSubmit: _canSubmit,
                isLoading: _isLoading,
                onSubmit: _submitDecision,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Custom header with retro styling.
class _ScreenHeader extends StatelessWidget {
  const _ScreenHeader({required this.onBack});

  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.spaceMd,
        vertical: AppDimensions.spaceSm,
      ),
      child: Row(
        children: [
          // Back button
          Container(
            decoration: BoxDecoration(
              color: colorScheme.surface,
              shape: BoxShape.circle,
              border: Border.all(
                color: colorScheme.secondary,
                width: AppDimensions.borderMedium,
              ),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x20000000),
                  offset: Offset(2, 2),
                  blurRadius: 0,
                ),
              ],
            ),
            child: IconButton(
              onPressed: onBack,
              icon: const Icon(Icons.arrow_back),
              color: colorScheme.secondary,
            ),
          ),

          const SizedBox(width: AppDimensions.spaceMd),

          // Title
          Expanded(
            child: Text(
              context.l10n.decision_screenTitle,
              style: AppTypography.headlineMedium.copyWith(
                color: colorScheme.onSurface,
              ),
            ),
          ),

          // Gavel icon decoration
          Container(
            padding: const EdgeInsets.all(AppDimensions.spaceSm),
            decoration: BoxDecoration(
              color: colorScheme.primary.withValues(alpha: 0.1),
              borderRadius: AppDimensions.borderRadiusMd,
            ),
            child: const Text('⚖️', style: TextStyle(fontSize: 24)),
          ),
        ],
      ),
    );
  }
}

/// Progress indicator showing how ready the case is.
class _ProgressSection extends StatelessWidget {
  const _ProgressSection({
    required this.optionsCount,
    required this.hasObjective,
    required this.minOptions,
    required this.maxOptions,
  });

  final int optionsCount;
  final bool hasObjective;
  final int minOptions;
  final int maxOptions;

  double get _progress {
    double optionProgress = (optionsCount / minOptions).clamp(0.0, 1.0) * 0.7;
    double objectiveProgress = hasObjective ? 0.3 : 0.0;
    return optionProgress + objectiveProgress;
  }

  String get _statusText {
    if (optionsCount == 0) return 'Add your food options to begin';
    if (optionsCount < minOptions) {
      return 'Add ${minOptions - optionsCount} more option${minOptions - optionsCount > 1 ? 's' : ''}';
    }
    if (!hasObjective) return 'Now pick your goal!';
    return 'Ready for the verdict!';
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(AppDimensions.spaceMd),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: AppDimensions.borderRadiusLg,
        border: Border.all(
          color: _progress >= 1.0 ? AppColors.success : colorScheme.outline,
          width: AppDimensions.borderMedium,
        ),
      ),
      child: Column(
        children: [
          // Status text
          Row(
            children: [
              Icon(
                _progress >= 1.0 ? Icons.check_circle : Icons.pending,
                color: _progress >= 1.0 ? AppColors.success : colorScheme.primary,
                size: 20,
              ),
              const SizedBox(width: AppDimensions.spaceSm),
              Expanded(
                child: Text(
                  _statusText,
                  style: AppTypography.labelMedium.copyWith(
                    color: _progress >= 1.0
                        ? AppColors.success
                        : colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
              Text(
                '$optionsCount/$maxOptions',
                style: AppTypography.labelSmall.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),

          const SizedBox(height: AppDimensions.spaceSm),

          // Progress bar
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: _progress,
              backgroundColor: colorScheme.outline,
              valueColor: AlwaysStoppedAnimation(
                _progress >= 1.0 ? AppColors.success : colorScheme.primary,
              ),
              minHeight: 6,
            ),
          ),
        ],
      ),
    );
  }
}

/// Options section with courtroom "Exhibit" styling.
class _OptionsSection extends StatelessWidget {
  const _OptionsSection({
    required this.options,
    required this.onRemove,
    required this.onAddMore,
    required this.maxOptions,
  });

  final List<FoodOption> options;
  final Function(int) onRemove;
  final VoidCallback? onAddMore;
  final int maxOptions;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section Header with icon
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(AppDimensions.spaceXs),
              decoration: BoxDecoration(
                color: colorScheme.primary,
                borderRadius: AppDimensions.borderRadiusSm,
              ),
              child: const Icon(
                Icons.restaurant_menu,
                color: Colors.white,
                size: 16,
              ),
            ),
            const SizedBox(width: AppDimensions.spaceSm),
            Text(
              context.l10n.decision_yourOptions.toUpperCase(),
              style: AppTypography.labelLarge.copyWith(
                color: colorScheme.onSurface,
                letterSpacing: 1.5,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),

        const SizedBox(height: AppDimensions.spaceMd),

        // Empty state or options
        if (options.isEmpty)
          _EmptyOptionsState(onAdd: onAddMore)
        else ...[
          // Option Cards with staggered animation
          ...options.asMap().entries.map((entry) {
            final index = entry.key;
            final option = entry.value;
            return Padding(
              padding: const EdgeInsets.only(bottom: AppDimensions.spaceMd),
              child: _ExhibitCard(
                option: option,
                exhibitLetter: String.fromCharCode(65 + index), // A, B, C...
                onRemove: () => onRemove(index),
              )
                  .animate()
                  .fadeIn(
                    duration: AppDimensions.durationMedium,
                    delay: Duration(milliseconds: index * 100),
                  )
                  .slideX(
                    begin: 0.1,
                    end: 0.0,
                    duration: AppDimensions.durationMedium,
                    delay: Duration(milliseconds: index * 100),
                  ),
            );
          }),

          // Add more button
          if (onAddMore != null)
            _AddOptionButton(
              onPressed: onAddMore!,
              remainingSlots: maxOptions - options.length,
            )
                .animate()
                .fadeIn(
                  duration: AppDimensions.durationMedium,
                  delay: Duration(milliseconds: options.length * 100),
                ),
        ],
      ],
    );
  }
}

/// Empty state when no options added.
class _EmptyOptionsState extends StatelessWidget {
  const _EmptyOptionsState({required this.onAdd});

  final VoidCallback? onAdd;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(AppDimensions.spaceXl),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: AppDimensions.borderRadiusLg,
        border: Border.all(
          color: colorScheme.outline,
          width: AppDimensions.borderMedium,
        ),
      ),
      child: Column(
        children: [
          // Icon
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: colorScheme.primary.withValues(alpha: 0.2),
              shape: BoxShape.circle,
            ),
            child: const Center(
              child: Text('🍽️', style: TextStyle(fontSize: 32)),
            ),
          ),

          const SizedBox(height: AppDimensions.spaceMd),

          Text(
            'No evidence yet!',
            style: AppTypography.titleMedium.copyWith(
              color: colorScheme.onSurface,
            ),
          ),

          const SizedBox(height: AppDimensions.spaceXs),

          Text(
            'Add your food options to build your case',
            style: AppTypography.bodyMedium.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: AppDimensions.spaceLg),

          if (onAdd != null)
            AppButton(
              label: 'Add First Option',
              icon: Icons.add,
              onPressed: onAdd,
            ),
        ],
      ),
    )
        .animate()
        .fadeIn(duration: AppDimensions.durationMedium)
        .scale(
          begin: const Offset(0.95, 0.95),
          end: const Offset(1.0, 1.0),
          duration: AppDimensions.durationMedium,
        );
  }
}

/// Courtroom-styled "Exhibit" card for each option.
class _ExhibitCard extends StatelessWidget {
  const _ExhibitCard({
    required this.option,
    required this.exhibitLetter,
    required this.onRemove,
  });

  final FoodOption option;
  final String exhibitLetter;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: AppDimensions.borderRadiusMd,
        border: Border.all(
          color: colorScheme.secondary,
          width: AppDimensions.borderThick,
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x30000000),
            offset: Offset(4, 4),
            blurRadius: 0,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Exhibit header
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppDimensions.spaceMd,
              vertical: AppDimensions.spaceSm,
            ),
            decoration: BoxDecoration(
              color: colorScheme.secondary,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(AppDimensions.radiusMd - 3),
              ),
            ),
            child: Row(
              children: [
                // Exhibit badge
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppDimensions.spaceSm,
                    vertical: AppDimensions.spaceXxs,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.pop,
                    borderRadius: AppDimensions.borderRadiusSm,
                  ),
                  child: Text(
                    'EXHIBIT $exhibitLetter',
                    style: AppTypography.labelSmall.copyWith(
                      color: colorScheme.secondary,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.0,
                    ),
                  ),
                ),

                const Spacer(),

                // Delete button
                InkWell(
                  onTap: onRemove,
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: AppColors.error.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.close,
                      color: colorScheme.surface,
                      size: 18,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Content
          Padding(
            padding: const EdgeInsets.all(AppDimensions.spaceMd),
            child: Row(
              children: [
                // Food emoji placeholder
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: colorScheme.primary.withValues(alpha: 0.2),
                    borderRadius: AppDimensions.borderRadiusSm,
                    border: Border.all(
                      color: colorScheme.primary.withValues(alpha: 0.3),
                      width: 2,
                    ),
                  ),
                  child: const Center(
                    child: Text('🍴', style: TextStyle(fontSize: 24)),
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
                          color: colorScheme.onSurface,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (option.notes != null && option.notes!.isNotEmpty) ...[
                        const SizedBox(height: AppDimensions.spaceXxs),
                        Row(
                          children: [
                            Icon(
                              Icons.notes,
                              size: 14,
                              color: colorScheme.onSurfaceVariant,
                            ),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                option.notes!,
                                style: AppTypography.bodySmall.copyWith(
                                  color: colorScheme.onSurfaceVariant,
                                  fontStyle: FontStyle.italic,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
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

/// Styled add option button.
class _AddOptionButton extends StatelessWidget {
  const _AddOptionButton({
    required this.onPressed,
    required this.remainingSlots,
  });

  final VoidCallback onPressed;
  final int remainingSlots;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return InkWell(
      onTap: onPressed,
      borderRadius: AppDimensions.borderRadiusMd,
      child: Container(
        padding: const EdgeInsets.all(AppDimensions.spaceMd),
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: AppDimensions.borderRadiusMd,
          border: Border.all(
            color: colorScheme.primary,
            width: 2,
            strokeAlign: BorderSide.strokeAlignInside,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: colorScheme.primary,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.add,
                color: Colors.white,
                size: 20,
              ),
            ),
            const SizedBox(width: AppDimensions.spaceSm),
            Text(
              context.l10n.decision_addOption,
              style: AppTypography.titleSmall.copyWith(
                color: colorScheme.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(width: AppDimensions.spaceSm),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppDimensions.spaceSm,
                vertical: AppDimensions.spaceXxs,
              ),
              decoration: BoxDecoration(
                color: colorScheme.primary.withValues(alpha: 0.2),
                borderRadius: AppDimensions.borderRadiusSm,
              ),
              child: Text(
                '$remainingSlots left',
                style: AppTypography.labelSmall.copyWith(
                  color: colorScheme.primary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Objective selector with better visual design.
class _ObjectiveSection extends StatelessWidget {
  const _ObjectiveSection({
    required this.selectedObjective,
    required this.onSelect,
  });

  final Objective? selectedObjective;
  final Function(Objective) onSelect;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section Header
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(AppDimensions.spaceXs),
              decoration: BoxDecoration(
                color: AppColors.pop,
                borderRadius: AppDimensions.borderRadiusSm,
              ),
              child: Icon(
                Icons.flag,
                color: colorScheme.secondary,
                size: 16,
              ),
            ),
            const SizedBox(width: AppDimensions.spaceSm),
            Text(
              context.l10n.decision_whatsYourGoal.toUpperCase(),
              style: AppTypography.labelLarge.copyWith(
                color: colorScheme.onSurface,
                letterSpacing: 1.5,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),

        const SizedBox(height: AppDimensions.spaceMd),

        // Objective chips in a nice grid
        Wrap(
          spacing: AppDimensions.spaceSm,
          runSpacing: AppDimensions.spaceSm,
          children: Objective.values.asMap().entries.map((entry) {
            final index = entry.key;
            final objective = entry.value;
            final isSelected = selectedObjective == objective;

            return _ObjectiveCard(
              objective: objective,
              isSelected: isSelected,
              onTap: () => onSelect(objective),
            )
                .animate()
                .fadeIn(
                  duration: AppDimensions.durationMedium,
                  delay: Duration(milliseconds: index * 50),
                )
                .scale(
                  begin: const Offset(0.9, 0.9),
                  end: const Offset(1.0, 1.0),
                  duration: AppDimensions.durationMedium,
                  delay: Duration(milliseconds: index * 50),
                );
          }).toList(),
        ),
      ],
    );
  }
}

/// Individual objective card with better styling.
class _ObjectiveCard extends StatelessWidget {
  const _ObjectiveCard({
    required this.objective,
    required this.isSelected,
    required this.onTap,
  });

  final Objective objective;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: AppDimensions.durationFast,
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.spaceMd,
          vertical: AppDimensions.spaceSm,
        ),
        decoration: BoxDecoration(
          color: isSelected ? colorScheme.primary : colorScheme.surface,
          borderRadius: AppDimensions.borderRadiusLg,
          border: Border.all(
            color: isSelected ? AppColors.primaryDark : colorScheme.outline,
            width: isSelected
                ? AppDimensions.borderThick
                : AppDimensions.borderMedium,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: colorScheme.primary.withValues(alpha: 0.3),
                    offset: const Offset(0, 4),
                    blurRadius: 8,
                  ),
                ]
              : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              objective.icon,
              style: const TextStyle(fontSize: 20),
            ),
            const SizedBox(width: AppDimensions.spaceSm),
            Text(
              objective.getLabel(context),
              style: AppTypography.labelLarge.copyWith(
                color: isSelected ? Colors.white : colorScheme.onSurface,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Judge Bite section with speech bubble.
class _JudgeBiteSection extends StatelessWidget {
  const _JudgeBiteSection({
    required this.optionsCount,
    required this.hasObjective,
    required this.canSubmit,
  });

  final int optionsCount;
  final bool hasObjective;
  final bool canSubmit;

  JudgeBitePose get _pose {
    if (optionsCount == 0) return JudgeBitePose.confused;
    if (canSubmit) return JudgeBitePose.excited;
    if (optionsCount >= 2) return JudgeBitePose.thinking;
    return JudgeBitePose.pointing;
  }

  String get _message {
    if (optionsCount == 0) return 'Present your evidence!';
    if (optionsCount == 1) return 'One option? Add more to compare!';
    if (!hasObjective) return 'Now tell me your goal!';
    if (canSubmit) return 'Ready to deliver the verdict!';
    return 'Building a solid case...';
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Center(
      child: Column(
        children: [
          // Speech bubble
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppDimensions.spaceLg,
              vertical: AppDimensions.spaceMd,
            ),
            decoration: BoxDecoration(
              color: colorScheme.surface,
              borderRadius: AppDimensions.borderRadiusLg,
              border: Border.all(
                color: colorScheme.secondary,
                width: AppDimensions.borderMedium,
              ),
              boxShadow: AppDimensions.shadowRetro,
            ),
            child: Text(
              '"$_message"',
              style: AppTypography.bodyLarge.copyWith(
                color: colorScheme.onSurface,
                fontStyle: FontStyle.italic,
              ),
              textAlign: TextAlign.center,
            ),
          )
              .animate(key: ValueKey(_message))
              .fadeIn(duration: AppDimensions.durationMedium)
              .slideY(
                begin: -0.2,
                end: 0.0,
                duration: AppDimensions.durationMedium,
              ),

          // Speech bubble pointer
          CustomPaint(
            size: const Size(20, 10),
            painter: _SpeechBubblePointer(colorScheme: colorScheme),
          ),

          const SizedBox(height: AppDimensions.spaceXs),

          // Judge Bite
          JudgeBite(pose: _pose, size: JudgeBiteSize.medium),
        ],
      ),
    );
  }
}

/// Custom painter for speech bubble pointer.
class _SpeechBubblePointer extends CustomPainter {
  _SpeechBubblePointer({required this.colorScheme});

  final ColorScheme colorScheme;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = colorScheme.surface
      ..style = PaintingStyle.fill;

    final borderPaint = Paint()
      ..color = colorScheme.secondary
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    final path = Path()
      ..moveTo(0, 0)
      ..lineTo(size.width / 2, size.height)
      ..lineTo(size.width, 0)
      ..close();

    canvas.drawPath(path, paint);
    canvas.drawLine(Offset(0, 0), Offset(size.width / 2, size.height), borderPaint);
    canvas.drawLine(Offset(size.width, 0), Offset(size.width / 2, size.height), borderPaint);
  }

  @override
  bool shouldRepaint(covariant _SpeechBubblePointer oldDelegate) =>
      colorScheme != oldDelegate.colorScheme;
}

/// Submit section with gradient button.
class _SubmitSection extends StatelessWidget {
  const _SubmitSection({
    required this.canSubmit,
    required this.isLoading,
    required this.onSubmit,
  });

  final bool canSubmit;
  final bool isLoading;
  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: AppDimensions.screenPadding,
      decoration: BoxDecoration(
        color: colorScheme.surface,
        border: Border(
          top: BorderSide(
            color: colorScheme.secondary,
            width: 3,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: colorScheme.secondary.withValues(alpha: 0.1),
            offset: const Offset(0, -4),
            blurRadius: 8,
          ),
        ],
      ),
      child: AppGradientButton(
        label: context.l10n.decision_letJudgeDecide,
        icon: Icons.gavel,
        onPressed: canSubmit ? onSubmit : null,
      ),
    );
  }
}

/// Bottom sheet for adding a new option.
class _AddOptionSheet extends StatefulWidget {
  const _AddOptionSheet({
    required this.onAdd,
    required this.optionNumber,
  });

  final Function(FoodOption) onAdd;
  final int optionNumber;

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
    final colorScheme = Theme.of(context).colorScheme;
    final exhibitLetter = String.fromCharCode(64 + widget.optionNumber);

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(AppDimensions.bottomSheetRadius),
        ),
        border: Border.all(
          color: colorScheme.secondary,
          width: AppDimensions.borderThick,
        ),
      ),
      padding: EdgeInsets.only(
        left: AppDimensions.spaceLg,
        right: AppDimensions.spaceLg,
        top: AppDimensions.spaceLg,
        bottom: MediaQuery.of(context).viewInsets.bottom + AppDimensions.spaceLg,
      ),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header with exhibit badge
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppDimensions.spaceMd,
                    vertical: AppDimensions.spaceXs,
                  ),
                  decoration: BoxDecoration(
                    color: colorScheme.secondary,
                    borderRadius: AppDimensions.borderRadiusSm,
                  ),
                  child: Text(
                    'EXHIBIT $exhibitLetter',
                    style: AppTypography.labelMedium.copyWith(
                      color: AppColors.pop,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.0,
                    ),
                  ),
                ),
                const Spacer(),
                AppCloseButton(onPressed: () => Navigator.of(context).pop()),
              ],
            ),

            const SizedBox(height: AppDimensions.spaceMd),

            Text(
              'Add to your case',
              style: AppTypography.headlineSmall.copyWith(
                color: colorScheme.onSurface,
              ),
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
            AppButton(
              label: context.l10n.option_addToCase,
              icon: Icons.add,
              onPressed: _submit,
            ),

            const SizedBox(height: AppDimensions.spaceSm),
          ],
        ),
      ),
    );
  }
}
