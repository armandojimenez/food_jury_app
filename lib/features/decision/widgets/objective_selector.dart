import 'package:flutter/material.dart';
import 'package:food_jury/core/theme/app_dimensions.dart';
import 'package:food_jury/core/widgets/objective_chip.dart';
import 'package:food_jury/features/decision/models/objective.dart';

class ObjectiveSelector extends StatelessWidget {
  final Objective? selectedObjective;
  final ValueChanged<Objective> onSelected;

  const ObjectiveSelector({
    super.key,
    required this.selectedObjective,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.screenPaddingHorizontal,
      ),
      child: Row(
        children: Objective.values.map((objective) {
          return Padding(
            padding: const EdgeInsets.only(right: AppDimensions.spaceSm),
            child: ObjectiveChip(
              label: objective.label,
              icon: objective.icon,
              isSelected: selectedObjective == objective,
              onTap: () => onSelected(objective),
            ),
          );
        }).toList(),
      ),
    );
  }
}
