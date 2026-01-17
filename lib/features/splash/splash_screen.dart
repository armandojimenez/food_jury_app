import 'package:flutter/material.dart';
import 'package:food_jury/core/theme/app_colors.dart';
import 'package:food_jury/core/theme/app_dimensions.dart';
import 'package:food_jury/core/widgets/judge_bite.dart';
import 'package:go_router/go_router.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToNext();
  }

  Future<void> _navigateToNext() async {
    // Artificial delay for splash effect
    await Future.delayed(const Duration(seconds: 3));
    if (mounted) {
      // Navigate to Home (replace with Onboarding check later)
      context.go('/home');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(gradient: AppColors.backgroundGradient),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(),

            // Judge Bite Animation
            TweenAnimationBuilder<double>(
              tween: Tween(begin: 0.0, end: 1.0),
              duration: const Duration(milliseconds: 800),
              curve: AppDimensions.curveBouncy,
              builder: (context, value, child) {
                return Transform.scale(
                  scale: value,
                  child: Transform.translate(
                    offset: Offset(0, 50 * (1 - value)),
                    child: child,
                  ),
                );
              },
              child: const JudgeBite(
                pose: JudgeBitePose.waving,
                size: AppDimensions.judgeBiteLg,
              ),
            ),

            const SizedBox(height: AppDimensions.spaceLg),

            // Logo Text
            TweenAnimationBuilder<double>(
              tween: Tween(begin: 0.0, end: 1.0),
              duration: const Duration(milliseconds: 800),
              curve: Curves.easeOut,
              builder: (context, value, child) {
                return Opacity(opacity: value, child: child);
              },
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppDimensions.spaceLg,
                      vertical: AppDimensions.spaceSm,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: AppColors.textPrimary,
                        width: AppDimensions.borderThick,
                      ),
                      borderRadius: AppDimensions.borderRadiusLg,
                    ),
                    child: Text(
                      'FoodJury',
                      style: Theme.of(context).textTheme.displaySmall?.copyWith(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.5,
                      ),
                    ),
                  ),
                  const SizedBox(height: AppDimensions.spaceMd),
                  Text(
                    "Order in the kitchen!",
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: AppColors.textSecondary,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),
            ),

            const Spacer(),

            // Loading indicator (subtle)
            const SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: AppDimensions.spaceXl),
          ],
        ),
      ),
    );
  }
}
