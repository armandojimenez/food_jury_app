import 'package:flutter/material.dart';
import 'package:food_jury/core/theme/app_colors.dart';
import 'package:food_jury/core/theme/app_dimensions.dart';
import 'package:food_jury/core/widgets/app_button.dart';
import 'package:food_jury/core/widgets/judge_bite.dart';
import 'package:go_router/go_router.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Mock empty state for now
    bool hasHistory = false;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('FoodJury'),
        centerTitle: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () => context.push('/settings'),
            icon: const Icon(Icons.settings, color: AppColors.textPrimary),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: AppDimensions.screenPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Greeting
              Text(
                "Good evening,\nhungry one!",
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: AppDimensions.spaceXl),

              // Judge Bite Hero
              Center(
                child: TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0.95, end: 1.05),
                  duration: const Duration(seconds: 2),
                  curve: Curves.easeInOut,
                  builder: (context, value, child) {
                    return Transform.translate(
                      offset: Offset(0, 5 * (value - 1) * 10), // Subtle bobbing
                      child: child,
                    );
                  },
                  onEnd:
                      () {}, // Loop handling would need a Stateful widget, skipping for simpler MVP now
                  child: const JudgeBite(
                    pose: JudgeBitePose.idle,
                    size: AppDimensions.judgeBiteLg,
                  ),
                ),
              ),

              const SizedBox(height: AppDimensions.spaceXl),

              // Main CTA
              _buildNewDecisionCard(context),

              const SizedBox(height: AppDimensions.spaceXl),

              // Recent History / Empty State
              Expanded(
                child: hasHistory
                    ? const Center(child: Text("History List Here"))
                    : _buildEmptyState(context),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNewDecisionCard(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.primaryLight.withValues(alpha: 0.2),
        borderRadius: AppDimensions.borderRadiusLg,
        border: Border.all(
          color: AppColors.primaryLight,
          width: AppDimensions.borderThin,
        ),
      ),
      padding: const EdgeInsets.all(AppDimensions.spaceLg),
      child: Column(
        children: [
          Text(
            "Can't decide what to eat?",
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(color: AppColors.textSecondary),
          ),
          const SizedBox(height: AppDimensions.spaceMd),
          AppButton(
            label: "Start New Decision",
            icon: Icons.restaurant_menu,
            isFullWidth: true,
            style: AppButtonStyle.primary,
            onPressed: () => context.push('/decision/new'),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(Icons.history, size: 48, color: AppColors.textMuted),
        const SizedBox(height: AppDimensions.spaceSm),
        Text(
          "The court records are empty...",
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            color: AppColors.textMuted,
            fontStyle: FontStyle.italic,
          ),
        ),
      ],
    );
  }
}
