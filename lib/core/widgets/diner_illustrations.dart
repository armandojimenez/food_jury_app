import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../theme/theme.dart';
import 'diner_components.dart';
import 'judge_bite.dart';

/// A speech bubble drawn as one silhouette, with a real comic tail.
class DinerSpeechBubble extends StatelessWidget {
  /// Creates a scalable speech bubble with a comic tail.
  const DinerSpeechBubble(this.text, {super.key});

  /// Localized live text, preserved for scaling and accessibility.
  final String text;
  @override
  Widget build(BuildContext context) => CustomPaint(
    painter: _SpeechPainter(
      Theme.of(context).colorScheme.surface,
      Theme.of(context).colorScheme.onSurface,
    ),
    child: Padding(
      padding: const EdgeInsets.fromLTRB(
        DinerTokens.bubbleInset,
        DinerTokens.bubbleInset,
        DinerTokens.bubbleInset,
        AppDimensions.spaceLg,
      ),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontSize: DinerTokens.bubbleType,
          fontWeight: FontWeight.w900,
          height: 1.1,
        ),
      ),
    ),
  );
}

class _SpeechPainter extends CustomPainter {
  const _SpeechPainter(this.paper, this.ink);
  final Color paper;
  final Color ink;
  @override
  void paint(Canvas canvas, Size size) {
    final oval = Path()
      ..addRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(0, 0, size.width, size.height - 12),
          const Radius.circular(32),
        ),
      );
    final tail = Path()
      ..moveTo(18, size.height - 24)
      ..lineTo(6, size.height)
      ..lineTo(42, size.height - 15)
      ..close();
    final bubble = Path.combine(PathOperation.union, oval, tail);
    canvas.drawPath(bubble, Paint()..color = paper);
    canvas.drawPath(
      bubble,
      Paint()
        ..color = ink
        ..style = PaintingStyle.stroke
        ..strokeWidth = DinerTokens.border,
    );
  }

  @override
  bool shouldRepaint(covariant _SpeechPainter old) =>
      paper != old.paper || ink != old.ink;
}

/// Hand-drawn accent rays add energy without adding semantic noise.
class DinerRays extends StatelessWidget {
  /// Creates three decorative hand-drawn accent strokes.
  const DinerRays({this.size = DinerTokens.rays, super.key});

  /// Logical extent of the artwork or lettering before text scaling.
  final double size;
  @override
  Widget build(BuildContext context) => ExcludeSemantics(
    child: SizedBox.square(
      dimension: size,
      child: CustomPaint(
        painter: _RayPainter(Theme.of(context).colorScheme.onSurface),
      ),
    ),
  );
}

class _RayPainter extends CustomPainter {
  const _RayPainter(this.ink);
  final Color ink;
  @override
  void paint(Canvas canvas, Size size) {
    final p = Paint()
      ..color = ink
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;
    for (var i = 0; i < 3; i++) {
      final angle = -.65 + i * .65;
      final center = Offset(size.width, size.height / 2);
      canvas.drawLine(
        center - Offset(math.cos(angle), math.sin(angle)) * size.width * .95,
        center - Offset(math.cos(angle), math.sin(angle)) * size.width * .4,
        p,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _RayPainter old) => old.ink != ink;
}

/// A layered character scene. Boots overlap the action's top edge; bubbles and
/// accents sit in the foreground. Text and hit areas retain their normal size.
class DinerCharacterStage extends StatelessWidget {
  /// Composes a mascot, optional speech and overlapping footer.
  const DinerCharacterStage({
    required this.pose,
    this.bubble,
    this.footer,
    this.large = false,
    super.key,
  });

  /// The expression and body pose used for the character.
  final JudgeBitePose pose;

  /// Optional localized speech, simplified away at large text sizes.
  final String? bubble;

  /// Content beneath the character; its upper edge may be overlapped by boots.
  final Widget? footer;

  /// Uses the larger dimensions intended for a wide composition.
  final bool large;
  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, box) {
      final accessible =
          MediaQuery.textScalerOf(context).scale(1) >=
          DinerTokens.largeTextBreakpoint;
      final judge = math.min(
        box.maxWidth * (accessible ? .9 : .8),
        large ? DinerTokens.wideSceneJudge : DinerTokens.sceneJudge,
      );
      return Stack(
        clipBehavior: Clip.none,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: judge - 8),
              if (footer != null) footer!,
            ],
          ),
          Positioned(
            top: judge * .1,
            left: judge * .06,
            child: const DinerStar(size: AppDimensions.spaceXxxl),
          ),
          Positioned(
            top: judge * .55,
            left: 0,
            child: const DinerRays(size: DinerTokens.smallRays),
          ),
          Positioned(
            top: -4,
            left: accessible ? (box.maxWidth - judge) / 2 : 8,
            child: IgnorePointer(
              child: JudgeBiteAnimated(pose: pose, dimension: judge + 16),
            ),
          ),
          if (bubble != null && !accessible)
            Positioned(
              top: 0,
              right: 0,
              width: math.min(box.maxWidth * .31, DinerTokens.bubbleWidth),
              child: Transform.rotate(
                angle: .045,
                child: DinerSpeechBubble(bubble!),
              ),
            ),
        ],
      );
    },
  );
}

/// Decorative sunburst behind food art and the big reveal.
class DinerSunburst extends StatelessWidget {
  /// Creates a background burst without accessible noise.
  const DinerSunburst({
    this.color = AppColors.primary,
    this.opacity = .12,
    super.key,
  });

  /// Optional color override; otherwise uses the component’s theme defaults.
  final Color color;

  /// Opacity of the decorative burst rays.
  final double opacity;
  @override
  Widget build(BuildContext context) => ExcludeSemantics(
    child: CustomPaint(
      painter: _SunburstPainter(color.withValues(alpha: opacity)),
    ),
  );
}

class _SunburstPainter extends CustomPainter {
  const _SunburstPainter(this.color);
  final Color color;
  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final radius = size.longestSide;
    final paint = Paint()..color = color;
    for (var i = 0; i < 14; i++) {
      final start = i * math.pi * 2 / 14;
      final path = Path()
        ..moveTo(center.dx, center.dy)
        ..lineTo(
          center.dx + math.cos(start) * radius,
          center.dy + math.sin(start) * radius,
        )
        ..lineTo(
          center.dx + math.cos(start + .12) * radius,
          center.dy + math.sin(start + .12) * radius,
        )
        ..close();
      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _SunburstPainter old) => old.color != color;
}
