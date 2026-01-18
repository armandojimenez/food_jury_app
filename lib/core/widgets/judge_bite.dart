import 'package:flutter/material.dart';

import '../theme/theme.dart';

/// Judge Bite mascot widget
/// Displays different poses with smooth transitions
class JudgeBite extends StatelessWidget {
  const JudgeBite({
    required this.pose,
    this.size = JudgeBiteSize.medium,
    super.key,
  });

  final JudgeBitePose pose;
  final JudgeBiteSize size;

  @override
  Widget build(BuildContext context) {
    // For now, we'll use a placeholder with icon
    // In production, this will load actual image assets
    return AnimatedSwitcher(
      duration: AppDimensions.durationMedium,
      switchInCurve: AppDimensions.curveBouncy,
      switchOutCurve: AppDimensions.curveSnappy,
      transitionBuilder: (child, animation) {
        return FadeTransition(
          opacity: animation,
          child: ScaleTransition(
            scale: Tween<double>(begin: 0.9, end: 1.0).animate(animation),
            child: child,
          ),
        );
      },
      child: _JudgeBiteImage(key: ValueKey(pose), pose: pose, size: size.value),
    );
  }
}

/// Judge Bite image widget
class _JudgeBiteImage extends StatelessWidget {
  const _JudgeBiteImage({required this.pose, required this.size, super.key});

  final JudgeBitePose pose;
  final double size;

  String get _assetPath => 'assets/images/judge_bite/${pose.name}.png';

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: Image.asset(
        _assetPath,
        width: size,
        height: size,
        fit: BoxFit.contain,
        filterQuality: FilterQuality.medium,
      ),
    );
  }
}

/// Judge Bite pose states
enum JudgeBitePose {
  /// Neutral standing pose
  idle,

  /// Looking up, gavel on chin
  thinking,

  /// Bouncing, gavel raised high
  excited,

  /// Arms crossed, serious face
  stern,

  /// Head tilted, scratching head
  confused,

  /// Jumping with joy
  celebrating,

  /// Eyes closed, zzz bubbles
  sleeping,

  /// Munching on food
  eating,

  /// Pointing to the right
  pointing,

  /// Friendly wave
  waving,
}

/// Judge Bite size presets
enum JudgeBiteSize {
  small(AppDimensions.judgeBiteSm),
  medium(AppDimensions.judgeBiteMd),
  large(AppDimensions.judgeBiteLg),
  xlarge(AppDimensions.judgeBiteXl);

  const JudgeBiteSize(this.value);
  final double value;
}

/// Judge Bite with idle animation (floating effect)
class JudgeBiteAnimated extends StatefulWidget {
  const JudgeBiteAnimated({
    required this.pose,
    this.size = JudgeBiteSize.medium,
    super.key,
  });

  final JudgeBitePose pose;
  final JudgeBiteSize size;

  @override
  State<JudgeBiteAnimated> createState() => _JudgeBiteAnimatedState();
}

class _JudgeBiteAnimatedState extends State<JudgeBiteAnimated>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _floatAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);

    _floatAnimation = Tween<double>(
      begin: -5.0,
      end: 5.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _floatAnimation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, _floatAnimation.value),
          child: child,
        );
      },
      child: JudgeBite(pose: widget.pose, size: widget.size),
    );
  }
}
