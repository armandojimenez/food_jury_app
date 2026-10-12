import 'package:flutter/material.dart';
import '../theme/theme.dart';
import 'diner_components.dart';

/// Arched, outlined diner lettering, painted from the real localized string.
/// Large accessibility text falls back to wrapping live text without distortion.
class DinerArcSign extends StatelessWidget {
  const DinerArcSign(
    this.text, {
    this.size = DinerTokens.signSize,
    this.outlined = true,
    super.key,
  });
  final String text;
  final double size;
  final bool outlined;
  @override
  Widget build(BuildContext context) {
    if (MediaQuery.textScalerOf(context).scale(1) >=
            DinerTokens.largeTextBreakpoint ||
        text.contains('\n')) {
      return outlined
          ? DinerSignText(text, size: size)
          : DinerHeading(text, center: true);
    }
    return LayoutBuilder(
      builder: (context, box) {
        final upper = text.toUpperCase();
        final style = TextStyle(
          fontFamily: AppTypography.displayFont,
          fontSize: MediaQuery.textScalerOf(context).scale(size),
          letterSpacing: .6,
        );
        final measure = TextPainter(
          text: TextSpan(text: upper, style: style),
          textDirection: Directionality.of(context),
        )..layout();
        final available = box.maxWidth.isFinite
            ? box.maxWidth
            : measure.width + 16;
        final scaledSize = MediaQuery.textScalerOf(context).scale(size);
        if (measure.width > available - 12) {
          return outlined
              ? DinerSignText(text, size: size)
              : DinerHeading(text, center: true);
        }
        final height = scaledSize * 1.22 + 10;
        return Semantics(
          label: text,
          header: true,
          excludeSemantics: true,
          child: SizedBox(
            width: available,
            height: height,
            child: CustomPaint(
              painter: _ArcSignPainter(
                upper,
                scaledSize,
                outlined,
                Theme.of(context).colorScheme.onSurface,
              ),
            ),
          ),
        );
      },
    );
  }
}

class _ArcSignPainter extends CustomPainter {
  const _ArcSignPainter(this.text, this.fontSize, this.outlined, this.ink);
  final String text;
  final double fontSize;
  final bool outlined;
  final Color ink;
  TextPainter _glyph(String text, TextStyle style) => TextPainter(
    text: TextSpan(text: text, style: style),
    textDirection: TextDirection.ltr,
  )..layout();
  @override
  void paint(Canvas canvas, Size size) {
    final base = TextStyle(
      fontFamily: AppTypography.displayFont,
      fontSize: fontSize,
      height: 1,
      letterSpacing: .6,
    );
    final letters = text.characters.toList();
    final widths = letters.map((c) => _glyph(c, base).width).toList();
    final total = widths.fold(0.0, (a, b) => a + b);
    var x = (size.width - total) / 2;
    final rise = fontSize * .24;
    for (var i = 0; i < letters.length; i++) {
      final center = x + widths[i] / 2;
      final position = (center - size.width / 2) / (total / 2);
      final y = fontSize * .18 + rise * position * position;
      canvas.save();
      canvas.translate(center, y);
      canvas.rotate(position * .105);
      final origin = Offset(-widths[i] / 2, 0);
      if (outlined) {
        _glyph(
          letters[i],
          base.copyWith(color: AppColors.accent),
        ).paint(canvas, origin + const Offset(2.5, 4.5));
        _glyph(
          letters[i],
          base.copyWith(
            foreground: Paint()
              ..style = PaintingStyle.stroke
              ..strokeJoin = StrokeJoin.round
              ..strokeWidth = 3.5
              ..color = AppColors.accent,
          ),
        ).paint(canvas, origin);
      }
      _glyph(
        letters[i],
        base.copyWith(color: outlined ? AppColors.background : ink),
      ).paint(canvas, origin);
      canvas.restore();
      x += widths[i];
    }
  }

  @override
  bool shouldRepaint(_ArcSignPainter old) =>
      old.text != text ||
      old.fontSize != fontSize ||
      old.outlined != outlined ||
      old.ink != ink;
}

/// A bold poster headline with a mustard brush underline and star accents.
/// Decoration has its own space and never intersects text or touch targets.
class DinerPosterHeading extends StatelessWidget {
  const DinerPosterHeading(
    this.text, {
    this.large = false,
    this.center = true,
    super.key,
  });
  final String text;
  final bool large, center;
  @override
  Widget build(BuildContext context) {
    final accessible =
        MediaQuery.textScalerOf(context).scale(1) >=
        DinerTokens.largeTextBreakpoint;
    if (accessible) return DinerHeading(text, center: center, large: large);
    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 3, 14, 20),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Transform.rotate(
            angle: -.025,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                for (final line in text.split('\n'))
                  DinerArcSign(
                    line,
                    size: large
                        ? DinerTokens.tabletHeadline
                        : DinerTokens.headline,
                    outlined: false,
                  ),
              ],
            ),
          ),
          const Positioned(
            left: 14,
            right: 14,
            bottom: -5,
            height: 10,
            child: CustomPaint(painter: _UnderlinePainter()),
          ),
          const Positioned(right: -13, bottom: -10, child: DinerStar(size: 27)),
          const Positioned(left: -13, top: 2, child: DinerStar(size: 18)),
        ],
      ),
    );
  }
}

class _UnderlinePainter extends CustomPainter {
  const _UnderlinePainter();
  @override
  void paint(Canvas canvas, Size size) {
    final path = Path()
      ..moveTo(0, size.height * .9)
      ..quadraticBezierTo(
        size.width * .50,
        -size.height * .1,
        size.width,
        size.height * .05,
      );
    canvas.drawPath(
      path,
      Paint()
        ..color = AppColors.pop
        ..strokeWidth = 6
        ..strokeCap = StrokeCap.round
        ..style = PaintingStyle.stroke,
    );
  }

  @override
  bool shouldRepaint(_UnderlinePainter old) => false;
}

/// A double-bordered, notched paper ticket inspired by the approved mockups.
class DinerVoucher extends StatelessWidget {
  const DinerVoucher({required this.child, super.key});
  final Widget child;
  @override
  Widget build(BuildContext context) => CustomPaint(
    painter: _VoucherPainter(
      Theme.of(context).colorScheme.surface,
      Theme.of(context).colorScheme.onSurface,
    ),
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 22),
      child: child,
    ),
  );
}

class _VoucherPainter extends CustomPainter {
  const _VoucherPainter(this.paper, this.ink);
  final Color paper, ink;
  Path _path(Rect r, double cut) => Path()
    ..moveTo(r.left + cut, r.top)
    ..lineTo(r.right - cut, r.top)
    ..quadraticBezierTo(r.right - cut, r.top + cut, r.right, r.top + cut)
    ..lineTo(r.right, r.bottom - cut)
    ..quadraticBezierTo(r.right - cut, r.bottom - cut, r.right - cut, r.bottom)
    ..lineTo(r.left + cut, r.bottom)
    ..quadraticBezierTo(r.left + cut, r.bottom - cut, r.left, r.bottom - cut)
    ..lineTo(r.left, r.top + cut)
    ..quadraticBezierTo(r.left + cut, r.top + cut, r.left + cut, r.top)
    ..close();
  @override
  void paint(Canvas canvas, Size size) {
    final outer = _path((Offset.zero & size).deflate(2), 10);
    canvas.drawPath(outer, Paint()..color = paper);
    canvas.drawPath(
      outer,
      Paint()
        ..color = ink
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.5,
    );
    canvas.drawPath(
      _path((Offset.zero & size).deflate(7), 8),
      Paint()
        ..color = AppColors.primary
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5,
    );
  }

  @override
  bool shouldRepaint(_VoucherPainter old) =>
      old.paper != paper || old.ink != ink;
}
