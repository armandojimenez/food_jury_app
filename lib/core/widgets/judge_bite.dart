import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../theme/theme.dart';
import 'diner_motion.dart';

/// The approved retro diner judge. All poses share a transparent art master.
class JudgeBite extends StatelessWidget {
  /// Creates a static illustrated pose with a short pose-change crossfade.
  const JudgeBite({
    required this.pose,
    this.size = JudgeBiteSize.medium,
    this.dimension,
    super.key,
  });

  /// Expression and body pose from the approved character set.
  final JudgeBitePose pose;

  /// Standard artwork size when no explicit dimension is supplied.
  final JudgeBiteSize size;

  /// Optional logical square extent for a composed hero scene.
  final double? dimension;

  @override
  Widget build(BuildContext context) => Semantics(
    image: true,
    label: 'Judge Bite',
    excludeSemantics: true,
    child: AnimatedSwitcher(
      duration: reduceDinerMotion(context)
          ? Duration.zero
          : AppDimensions.durationMedium,
      switchInCurve: Curves.easeOutCubic,
      child: Image.asset(
        'assets/images/judge_bite_v2/${pose.name}.png',
        key: ValueKey(pose),
        width: dimension ?? size.value,
        height: dimension ?? size.value,
        fit: BoxFit.contain,
        filterQuality: FilterQuality.medium,
        cacheWidth:
            ((dimension ?? size.value) * MediaQuery.devicePixelRatioOf(context))
                .ceil(),
      ),
    ),
  );
}

/// Complete mascot expression vocabulary.
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

/// Standard sizes; larger hero placements may supply an explicit token value.
enum JudgeBiteSize {
  small(AppDimensions.judgeBiteSm),
  medium(AppDimensions.judgeBiteMd),
  large(AppDimensions.judgeBiteLg),
  xlarge(AppDimensions.judgeBiteXl);

  const JudgeBiteSize(this.value);

  /// Logical size of the artwork.
  final double value;
}

/// A subtle breathing/rocking idle loop that obeys reduced motion and TickerMode.
class JudgeBiteAnimated extends StatefulWidget {
  /// Creates a breathing character that respects system motion preferences.
  const JudgeBiteAnimated({
    required this.pose,
    this.size = JudgeBiteSize.medium,
    this.dimension,
    super.key,
  });

  /// Expression and body pose from the approved character set.
  final JudgeBitePose pose;

  /// Standard artwork size when no explicit dimension is supplied.
  final JudgeBiteSize size;

  /// Optional logical square extent for a composed hero scene.
  final double? dimension;
  @override
  State<JudgeBiteAnimated> createState() => _JudgeBiteAnimatedState();
}

class _JudgeBiteAnimatedState extends State<JudgeBiteAnimated>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: DinerTokens.idle,
  );
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (reduceDinerMotion(context) || !TickerMode.valuesOf(context).enabled) {
      _controller.stop();
      _controller.value = 0;
    } else if (!_controller.isAnimating) {
      _controller.repeat();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
    animation: _controller,
    child: JudgeBite(
      pose: widget.pose,
      size: widget.size,
      dimension: widget.dimension,
    ),
    builder: (context, child) => Transform.translate(
      offset: Offset(0, math.sin(_controller.value * math.pi * 2) * 3),
      child: Transform.rotate(
        angle: math.sin(_controller.value * math.pi * 2) * .012,
        child: child,
      ),
    ),
  );
}
