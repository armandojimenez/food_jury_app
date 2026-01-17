import 'package:flutter/material.dart';
import 'package:food_jury/core/theme/app_dimensions.dart';

enum JudgeBitePose {
  idle,
  thinking,
  excited,
  stern,
  confused,
  celebrating,
  sleeping,
  eating,
  pointing,
  waving,
}

class JudgeBite extends StatelessWidget {
  final JudgeBitePose pose;
  final double size;
  final bool compact;

  const JudgeBite({
    super.key,
    this.pose = JudgeBitePose.idle,
    this.size = AppDimensions.judgeBiteMd,
    this.compact = false,
  });

  String _getAssetPath(JudgeBitePose pose) {
    // Determine asset name based on pose enum
    final filename = pose.name;
    return 'assets/images/judge_bite/$filename.png';
  }

  @override
  Widget build(BuildContext context) {
    final effectiveSize = compact ? AppDimensions.judgeBiteSm : size;

    return AnimatedSwitcher(
      duration: AppDimensions.durationMedium,
      transitionBuilder: (Widget child, Animation<double> animation) {
        // Elastic pop + fade transition for personality
        final scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
          CurvedAnimation(parent: animation, curve: AppDimensions.curveBouncy),
        );

        final fadeAnimation = Tween<double>(
          begin: 0.0,
          end: 1.0,
        ).animate(CurvedAnimation(parent: animation, curve: Curves.easeOut));

        return ScaleTransition(
          scale: scaleAnimation,
          child: FadeTransition(opacity: fadeAnimation, child: child),
        );
      },
      child: Image.asset(
        _getAssetPath(pose),
        key: ValueKey<JudgeBitePose>(pose),
        height: effectiveSize,
        width: effectiveSize,
        fit: BoxFit.contain,
        // Fallback or error builder in case assets are missing during dev
        errorBuilder: (context, error, stackTrace) {
          return Container(
            key: ValueKey<JudgeBitePose>(pose),
            height: effectiveSize,
            width: effectiveSize,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              shape: BoxShape.circle,
            ),
            child: Text(
              pose.name[0].toUpperCase(),
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          );
        },
      ),
    );
  }
}
