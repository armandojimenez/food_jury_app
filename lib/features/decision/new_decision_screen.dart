import 'package:flutter/material.dart';
import 'package:food_jury/core/theme/app_colors.dart';
import 'package:food_jury/core/theme/app_dimensions.dart';
import 'package:food_jury/core/widgets/app_button.dart';
import 'package:food_jury/core/widgets/judge_bite.dart';
import 'package:food_jury/core/widgets/loading_overlay.dart';
import 'package:food_jury/core/widgets/option_card.dart';
import 'package:food_jury/features/decision/models/food_option.dart';
import 'package:food_jury/features/decision/models/objective.dart';
import 'package:food_jury/features/decision/widgets/objective_selector.dart';
import 'package:food_jury/features/decision/widgets/option_input_sheet.dart';
import 'package:go_router/go_router.dart';

class NewDecisionScreen extends StatefulWidget {
  const NewDecisionScreen({super.key});

  @override
  State<NewDecisionScreen> createState() => _NewDecisionScreenState();
}

class _NewDecisionScreenState extends State<NewDecisionScreen> {
  final List<FoodOption> _options = [];
  Objective _selectedObjective = Objective.fun;
  bool _isProcessing = false;

  void _addOption(FoodOption option) {
    setState(() {
      _options.add(option);
    });
  }

  void _removeOption(int index) {
    setState(() {
      _options.removeAt(index);
    });
  }

  void _submitDecision() async {
    if (_options.length < 2) return;

    setState(() {
      _isProcessing = true;
    });

    // Mock processing time
    await Future.delayed(const Duration(seconds: 4));

    if (mounted) {
      setState(() {
        _isProcessing = false;
      });
      // TODO: Navigate to Verdict Screen with data
      // context.go('/decision/verdict', extra: ...);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Verdict calculated! (Screen coming soon)"),
        ),
      );
    }
  }

  void _showAddOptionSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.background,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppDimensions.radiusLg),
        ),
      ),
      builder: (context) => OptionInputSheet(onAdd: _addOption),
    );
  }

  JudgeBitePose _getJudgePose() {
    if (_options.isEmpty) return JudgeBitePose.confused;
    if (_options.length == 1) return JudgeBitePose.pointing; // Encouraging more
    return JudgeBitePose.excited;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          backgroundColor: AppColors.background,
          appBar: AppBar(
            title: const Text("What's the dilemma?"),
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
              onPressed: () => context.pop(),
            ),
          ),
          body: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: AppDimensions.screenPadding,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // SECTION: OPTIONS
                      Text(
                        "YOUR OPTIONS",
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          color: AppColors.textSecondary,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.0,
                        ),
                      ),
                      const SizedBox(height: AppDimensions.spaceMd),

                      // Option List
                      ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: _options.length,
                        separatorBuilder: (context, index) =>
                            const SizedBox(height: AppDimensions.spaceMd),
                        itemBuilder: (context, index) {
                          final option = _options[index];
                          return Dismissible(
                            key: Key(option.id),
                            direction: DismissDirection.endToStart,
                            onDismissed: (_) => _removeOption(index),
                            background: Container(
                              alignment: Alignment.centerRight,
                              padding: const EdgeInsets.only(
                                right: AppDimensions.spaceMd,
                              ),
                              color: AppColors.error,
                              child: const Icon(
                                Icons.delete,
                                color: Colors.white,
                              ),
                            ),
                            child: OptionCard(
                              name: option.name,
                              notes: option.notes,
                              imagePath: option.imagePath,
                              onDelete: () => _removeOption(index),
                            ),
                          );
                        },
                      ),

                      const SizedBox(height: AppDimensions.spaceMd),

                      // Add Option Button
                      if (_options.length < 5)
                        GestureDetector(
                          onTap: _showAddOptionSheet,
                          child: Container(
                            height: 80,
                            decoration: BoxDecoration(
                              color: Colors.transparent,
                              borderRadius: AppDimensions.borderRadiusMd,
                              border: Border.all(
                                color: AppColors.primary,
                                width: AppDimensions.borderMedium,
                                style: BorderStyle
                                    .solid, // Dash support needs a custom painter or package, staying solid for now
                              ),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                Icon(Icons.add, color: AppColors.primary),
                                SizedBox(height: AppDimensions.spaceXs),
                                Text(
                                  "Add Option",
                                  style: TextStyle(
                                    color: AppColors.primary,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                      const SizedBox(height: AppDimensions.spaceXl),

                      // SECTION: OBJECTIVE
                      Text(
                        "WHAT'S YOUR GOAL?",
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          color: AppColors.textSecondary,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.0,
                        ),
                      ),
                      const SizedBox(height: AppDimensions.spaceMd),

                      // Using negative margin to handle horizontal scroll padding nicely
                      Transform.translate(
                        offset: const Offset(
                          -AppDimensions.screenPaddingHorizontal,
                          0,
                        ),
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width,
                          child: ObjectiveSelector(
                            selectedObjective: _selectedObjective,
                            onSelected: (obj) =>
                                setState(() => _selectedObjective = obj),
                          ),
                        ),
                      ),

                      const SizedBox(height: AppDimensions.spaceXxl),
                      const SizedBox(
                        height: AppDimensions.spaceXxl,
                      ), // Bottom padding
                    ],
                  ),
                ),
              ),

              // Bottom Action Area
              Container(
                padding: AppDimensions.screenPadding,
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  boxShadow: AppDimensions.shadowLg,
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(AppDimensions.radiusLg),
                  ),
                ),
                child: SafeArea(
                  child: Row(
                    children: [
                      // Judge Reaction
                      JudgeBite(
                        pose: _getJudgePose(),
                        size: AppDimensions.judgeBiteSm,
                        compact: true,
                      ),
                      const SizedBox(width: AppDimensions.spaceMd),

                      // Submit Button
                      Expanded(
                        child: AppButton(
                          label: "Let the Judge Decide",
                          icon: Icons.gavel,
                          onPressed: _options.length >= 2
                              ? _submitDecision
                              : null,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),

        // Loading Overlay
        if (_isProcessing) const LoadingOverlay(),
      ],
    );
  }
}
