import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';

import '../../../config/routes/app_router.dart';
import '../../../core/theme/theme.dart';
import '../../../core/utils/l10n_extensions.dart';
import '../../../core/widgets/widgets.dart';

/// Splash screen - the dramatic first impression.
///
/// Features:
/// - Warm gradient background
/// - Judge Bite waving entrance from bottom
/// - App logo with retro glow effect
/// - Tagline fade in
/// - Auto-navigate to home after animations complete
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToHome();
  }

  Future<void> _navigateToHome() async {
    // Wait for animations to complete, then navigate
    await Future.delayed(const Duration(milliseconds: 3000));
    if (mounted) {
      context.go(AppRouter.home);
    }
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
                    AppColors.surfaceDark,
                  ]
                : [
                    AppColors.background,
                    const Color(0xFFFFE8D6),
                    AppColors.primaryLight,
                  ],
            stops: const [0.0, 0.6, 1.0],
          ),
        ),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(flex: 2),

              // App Logo with retro glow
              _AppLogo()
                  .animate()
                  .fadeIn(
                    duration: AppDimensions.durationSlow,
                    curve: Curves.easeOut,
                  )
                  .scale(
                    begin: const Offset(0.8, 0.8),
                    end: const Offset(1.0, 1.0),
                    duration: AppDimensions.durationSlow,
                    curve: Curves.elasticOut,
                  ),

              const SizedBox(height: AppDimensions.spaceXxl),

              // Judge Bite - bounces in from bottom
              JudgeBite(
                pose: JudgeBitePose.waving,
                size: JudgeBiteSize.xlarge,
              )
                  .animate()
                  .slideY(
                    begin: 2.0,
                    end: 0.0,
                    duration: AppDimensions.durationDramatic,
                    curve: Curves.elasticOut,
                    delay: const Duration(milliseconds: 300),
                  )
                  .fadeIn(
                    duration: AppDimensions.durationMedium,
                    delay: const Duration(milliseconds: 300),
                  ),

              const SizedBox(height: AppDimensions.spaceLg),

              // Tagline - fades in last
              _Tagline()
                  .animate()
                  .fadeIn(
                    duration: AppDimensions.durationMedium,
                    delay: const Duration(milliseconds: 1000),
                  )
                  .slideY(
                    begin: 0.3,
                    end: 0.0,
                    duration: AppDimensions.durationMedium,
                    delay: const Duration(milliseconds: 1000),
                  ),

              const Spacer(flex: 3),

              // Subtle loading indicator
              _LoadingDots()
                  .animate()
                  .fadeIn(
                    duration: AppDimensions.durationMedium,
                    delay: const Duration(milliseconds: 1500),
                  ),

              const SizedBox(height: AppDimensions.spaceXxl),
            ],
          ),
        ),
      ),
    );
  }
}

/// App logo with retro diner styling.
class _AppLogo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      children: [
        // Main logo text with clean retro shadow
        Text(
          context.l10n.appTitle.toUpperCase(),
          style: AppTypography.displayLarge.copyWith(
            color: colorScheme.primary,
            fontSize: 52,
            letterSpacing: 4.0,
            shadows: [
              // Hard retro shadow - clean and bold
              Shadow(
                color: colorScheme.secondary,
                blurRadius: 0,
                offset: const Offset(3, 3),
              ),
              // Subtle gold glow
              Shadow(
                color: colorScheme.tertiary.withValues(alpha: 0.5),
                blurRadius: 24,
                offset: Offset.zero,
              ),
            ],
          ),
        ),

        const SizedBox(height: AppDimensions.spaceSm),

        // Decorative line - bolder and more prominent
        Container(
          width: 160,
          height: 6,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.transparent,
                colorScheme.tertiary,
                colorScheme.primary,
                colorScheme.tertiary,
                Colors.transparent,
              ],
            ),
            borderRadius: BorderRadius.circular(3),
            boxShadow: [
              BoxShadow(
                color: colorScheme.tertiary.withValues(alpha: 0.4),
                blurRadius: 8,
                spreadRadius: 0,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// Tagline text.
class _Tagline extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.spaceLg,
        vertical: AppDimensions.spaceSm,
      ),
      decoration: BoxDecoration(
        color: colorScheme.surface.withValues(alpha: 0.8),
        borderRadius: AppDimensions.borderRadiusLg,
        border: Border.all(
          color: colorScheme.secondary.withValues(alpha: 0.2),
          width: AppDimensions.borderMedium,
        ),
      ),
      child: Text(
        context.l10n.appTagline,
        style: AppTypography.titleMedium.copyWith(
          color: colorScheme.onSurfaceVariant,
          fontStyle: FontStyle.italic,
          letterSpacing: 0.5,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}

/// Animated loading dots.
class _LoadingDots extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(3, (index) {
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 4),
          child: _Dot()
              .animate(
                onPlay: (controller) => controller.repeat(reverse: true),
              )
              .scale(
                begin: const Offset(0.5, 0.5),
                end: const Offset(1.0, 1.0),
                duration: const Duration(milliseconds: 600),
                delay: Duration(milliseconds: index * 200),
              )
              .fadeIn(
                duration: const Duration(milliseconds: 300),
                delay: Duration(milliseconds: index * 200),
              ),
        );
      }),
    );
  }
}

/// Single dot for loading indicator.
class _Dot extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      width: 10,
      height: 10,
      decoration: BoxDecoration(
        color: colorScheme.primary,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: colorScheme.primary.withValues(alpha: 0.4),
            blurRadius: 8,
            spreadRadius: 1,
          ),
        ],
      ),
    );
  }
}
