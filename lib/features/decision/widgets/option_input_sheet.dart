import 'package:flutter/material.dart';
import 'package:food_jury/core/theme/app_colors.dart';
import 'package:food_jury/core/theme/app_dimensions.dart';
import 'package:food_jury/core/widgets/app_button.dart';
import 'package:food_jury/core/widgets/app_text_field.dart';
import 'package:food_jury/features/decision/models/food_option.dart';
import 'package:go_router/go_router.dart';

class OptionInputSheet extends StatefulWidget {
  final ValueChanged<FoodOption> onAdd;

  const OptionInputSheet({super.key, required this.onAdd});

  @override
  State<OptionInputSheet> createState() => _OptionInputSheetState();
}

class _OptionInputSheetState extends State<OptionInputSheet> {
  final _nameController = TextEditingController();
  final _notesController = TextEditingController();
  final String? _imagePath = null; // Placeholder for image logic

  @override
  void dispose() {
    _nameController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_nameController.text.trim().isEmpty) return;

    final option = FoodOption(
      name: _nameController.text.trim(),
      notes: _notesController.text.trim().isEmpty
          ? null
          : _notesController.text.trim(),
      imagePath: _imagePath,
    );

    widget.onAdd(option);
    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    // Bottom sheet UI
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: AppDimensions.screenPaddingHorizontal,
        right: AppDimensions.screenPaddingHorizontal,
        top: AppDimensions.spaceMd,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Drag handle
          Center(
            child: Container(
              width: AppDimensions.dragHandleWidth,
              height: AppDimensions.dragHandleHeight,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: AppDimensions.spaceLg),

          Text(
            "Add Option",
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: AppDimensions.spaceLg),

          // Image Placeholder
          GestureDetector(
            onTap: () {
              // TODO: Implement image picker
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Image picking coming soon!")),
              );
            },
            child: Container(
              height: 120,
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: AppDimensions.borderRadiusMd,
                border: Border.all(
                  color: AppColors.border,
                  width: AppDimensions.borderMedium,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(
                    Icons.camera_alt,
                    size: AppDimensions.iconSizeLg,
                    color: AppColors.primary,
                  ),
                  SizedBox(height: AppDimensions.spaceSm),
                  Text(
                    "Tap to add photo",
                    style: TextStyle(color: AppColors.textSecondary),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: AppDimensions.spaceMd),

          AppTextField(
            label: "Name *",
            hint: "What is it?",
            controller: _nameController,
          ),

          const SizedBox(height: AppDimensions.spaceMd),

          AppTextField(
            label: "Notes (optional)",
            hint: "Any details the judge should know?",
            controller: _notesController,
            maxLines: 2,
          ),

          const SizedBox(height: AppDimensions.spaceLg),

          AppButton(label: "Add to Case", onPressed: _submit),

          const SizedBox(height: AppDimensions.spaceLg),
        ],
      ),
    );
  }
}
