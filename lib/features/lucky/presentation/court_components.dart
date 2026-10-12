import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../../core/theme/theme.dart';
import '../../../core/utils/l10n_extensions.dart';
import '../data/decision_case.dart';

/// Geometry and finite motion shared by the four dinner rituals.
abstract final class CourtTokens {
  static const ritual = Duration(milliseconds: 3300);
  static const double stage = 440;
  static const double emblem = 72;
  static const double cardMinHeight = 230;

  /// Two cards need room for illustration, state icon, padding and spacing.
  static const double minimumPairWidth = 304;
  static const double heroFood = 270;
  static const double heroJudge = 132;
  static const double plateTurns = 5;
  static const double coinTurns = 4;
}

extension RandomMethodCopy on RandomMethod {
  String title(BuildContext c) => switch (this) {
    RandomMethod.wheel => c.l10n.lucky_wheel,
    RandomMethod.ticket => c.l10n.lucky_ticket,
    RandomMethod.cloche => c.l10n.lucky_cloche,
    RandomMethod.coin => c.l10n.lucky_coin,
  };
  String hint(BuildContext c) => switch (this) {
    RandomMethod.wheel => c.l10n.lucky_wheelHint,
    RandomMethod.ticket => c.l10n.lucky_ticketHint,
    RandomMethod.cloche => c.l10n.lucky_clocheHint,
    RandomMethod.coin => c.l10n.lucky_coinHint,
  };
}

/// Code-drawn ritual symbols remain crisp at every screen size.
class MethodEmblem extends StatelessWidget {
  const MethodEmblem(this.method, {super.key, this.size = CourtTokens.emblem});
  final RandomMethod method;
  final double size;
  @override
  Widget build(BuildContext context) => ExcludeSemantics(
    child: SizedBox.square(
      dimension: size,
      child: CustomPaint(painter: MethodPainter(method)),
    ),
  );
}

class MethodPainter extends CustomPainter {
  const MethodPainter(this.method);
  final RandomMethod method;
  @override
  void paint(Canvas canvas, Size size) {
    canvas.save();
    canvas.scale(size.width / 100, size.height / 100);
    final ink = Paint()
      ..color = AppColors.accent
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4;
    final fill = Paint()..color = AppColors.pop;
    switch (method) {
      case RandomMethod.wheel:
        canvas.drawCircle(
          const Offset(50, 50),
          46,
          Paint()..color = AppColors.background,
        );
        for (var i = 0; i < 4; i++) {
          canvas.drawArc(
            const Rect.fromLTWH(11, 11, 78, 78),
            i * math.pi / 2,
            math.pi / 2,
            true,
            Paint()
              ..color = [
                AppColors.primary,
                AppColors.pop,
                AppColors.sage,
                AppColors.background,
              ][i],
          );
        }
        canvas.drawCircle(const Offset(50, 50), 46, ink);
      case RandomMethod.ticket:
        canvas.drawRRect(
          RRect.fromRectAndRadius(
            const Rect.fromLTWH(14, 18, 65, 76),
            const Radius.circular(4),
          ),
          Paint()..color = AppColors.primary,
        );
        final ticket = RRect.fromRectAndRadius(
          const Rect.fromLTWH(25, 6, 65, 76),
          const Radius.circular(4),
        );
        canvas.drawRRect(ticket, Paint()..color = AppColors.background);
        canvas.drawRRect(ticket, ink);
        for (var y = 23.0; y < 40; y += 10) {
          canvas.drawLine(Offset(37, y), Offset(78, y), ink..strokeWidth = 2);
        }
        _letter(canvas, '?', const Offset(48, 37), 34);
      case RandomMethod.cloche:
        canvas.drawRRect(
          RRect.fromRectAndRadius(
            const Rect.fromLTWH(43, 24, 14, 17),
            const Radius.circular(5),
          ),
          fill,
        );
        final dome = Path()
          ..moveTo(7, 79)
          ..arcToPoint(const Offset(93, 79), radius: const Radius.circular(43))
          ..close();
        canvas.drawPath(dome, Paint()..color = AppColors.primary);
        canvas.drawPath(dome, ink);
        canvas.drawArc(
          const Rect.fromLTWH(20, 48, 60, 54),
          math.pi * 1.08,
          math.pi * .32,
          false,
          Paint()
            ..color = AppColors.background
            ..style = PaintingStyle.stroke
            ..strokeWidth = 3
            ..strokeCap = StrokeCap.round,
        );
        canvas.drawLine(
          const Offset(3, 86),
          const Offset(97, 86),
          ink..strokeWidth = 5,
        );
      case RandomMethod.coin:
        canvas.drawCircle(
          const Offset(52, 54),
          44,
          Paint()..color = AppColors.primary,
        );
        canvas.drawCircle(const Offset(48, 48), 43, fill);
        canvas.drawCircle(const Offset(48, 48), 43, ink);
        canvas.drawCircle(const Offset(48, 48), 35, ink..strokeWidth = 2);
        _letter(canvas, 'H', const Offset(33, 19), 52);
    }
    canvas.restore();
  }

  void _letter(Canvas canvas, String text, Offset at, double size) {
    final p = TextPainter(
      text: TextSpan(
        text: text,
        style: TextStyle(
          fontFamily: 'Bangers',
          fontSize: size,
          color: AppColors.accent,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    p.paint(canvas, at);
  }

  @override
  bool shouldRepaint(MethodPainter oldDelegate) => oldDelegate.method != method;
}
