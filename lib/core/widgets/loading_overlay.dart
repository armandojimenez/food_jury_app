import 'package:flutter/material.dart';

import '../theme/theme.dart';

/// Loading overlay with Judge Bite thinking animation
class LoadingOverlay extends StatelessWidget {
  const LoadingOverlay({
    required this.message,
    this.variant = LoadingVariant.thinking,
    super.key,
  });

  final String message;
  final LoadingVariant variant;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      color: colorScheme.scrim.withValues(alpha: 0.7),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Loading indicator based on variant
            _buildLoadingIndicator(),
            const SizedBox(height: AppDimensions.spaceLg),

            // Message
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppDimensions.spaceXl,
                vertical: AppDimensions.spaceMd,
              ),
              decoration: BoxDecoration(
                color: colorScheme.surface,
                borderRadius: AppDimensions.borderRadiusMd,
                border: Border.all(
                  color: colorScheme.secondary,
                  width: AppDimensions.borderMedium,
                ),
              ),
              child: Text(
                message,
                style: AppTypography.judgeSpeech.copyWith(
                  color: colorScheme.onSurface,
                ),
                textAlign: TextAlign.center,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingIndicator() {
    switch (variant) {
      case LoadingVariant.thinking:
        return const _GavelSpinner();
      case LoadingVariant.processing:
        return const _PulsingGavel();
      case LoadingVariant.simple:
        return const AppLoadingIndicator();
    }
  }

  /// Show loading overlay
  static void show(
    BuildContext context, {
    required String message,
    LoadingVariant variant = LoadingVariant.thinking,
  }) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => LoadingOverlay(message: message, variant: variant),
    );
  }

  /// Hide loading overlay
  static void hide(BuildContext context) {
    Navigator.of(context).pop();
  }
}

/// Loading variant styles
enum LoadingVariant {
  /// Rotating gavel
  thinking,

  /// Pulsing gavel
  processing,

  /// Simple circular indicator
  simple,
}

/// Rotating gavel spinner
class _GavelSpinner extends StatefulWidget {
  const _GavelSpinner();

  @override
  State<_GavelSpinner> createState() => _GavelSpinnerState();
}

class _GavelSpinnerState extends State<_GavelSpinner>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.rotate(
          angle: _controller.value * 2 * 3.14159,
          child: child,
        );
      },
      child: Container(
        width: AppDimensions.judgeBiteMd,
        height: AppDimensions.judgeBiteMd,
        padding: const EdgeInsets.all(AppDimensions.spaceLg),
        decoration: BoxDecoration(
          color: colorScheme.primary.withValues(alpha: 0.2),
          shape: BoxShape.circle,
          border: Border.all(
            color: colorScheme.secondary,
            width: AppDimensions.borderThick,
          ),
          boxShadow: AppDimensions.shadowMd,
        ),
        child: Icon(
          Icons.gavel,
          size: AppDimensions.iconSizeXl,
          color: colorScheme.primary,
        ),
      ),
    );
  }
}

/// Pulsing gavel animation
class _PulsingGavel extends StatefulWidget {
  const _PulsingGavel();

  @override
  State<_PulsingGavel> createState() => _PulsingGavelState();
}

class _PulsingGavelState extends State<_PulsingGavel>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    )..repeat(reverse: true);

    _scaleAnimation = Tween<double>(
      begin: 0.9,
      end: 1.1,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(scale: _scaleAnimation.value, child: child);
      },
      child: Container(
        width: AppDimensions.judgeBiteMd,
        height: AppDimensions.judgeBiteMd,
        padding: const EdgeInsets.all(AppDimensions.spaceLg),
        decoration: BoxDecoration(
          gradient: AppColors.primaryGradient,
          shape: BoxShape.circle,
          border: Border.all(
            color: colorScheme.secondary,
            width: AppDimensions.borderThick,
          ),
          boxShadow: AppDimensions.shadowLg,
        ),
        child: const Icon(
          Icons.gavel,
          size: AppDimensions.iconSizeXl,
          color: AppColors.textInverse,
        ),
      ),
    );
  }
}

/// Simple loading indicator
class AppLoadingIndicator extends StatelessWidget {
  const AppLoadingIndicator({this.size = 40, this.color, super.key});

  final double size;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return SizedBox(
      width: size,
      height: size,
      child: CircularProgressIndicator(
        strokeWidth: 3,
        valueColor: AlwaysStoppedAnimation<Color>(color ?? colorScheme.primary),
      ),
    );
  }
}

/// Judge Bite loading messages
class JudgeMessages {
  static const List<String> thinking = [
    'The court is in session...',
    'Examining the evidence...',
    'Deliberating carefully...',
    'Consulting the menu...',
    'Weighing the options...',
  ];

  static const List<String> processing = [
    'Processing your request...',
    'Judge Bite is thinking...',
    'Analyzing the flavors...',
    'Making the call...',
    'Almost there...',
  ];

  static const List<String> saving = [
    'Recording the verdict...',
    'Filing the paperwork...',
    'Saving to the court records...',
    'Documenting the decision...',
  ];

  static String getRandom(List<String> messages) {
    return messages[DateTime.now().millisecond % messages.length];
  }
}
