import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../../core/theme/theme.dart';
import '../../../core/utils/l10n_extensions.dart';
import '../../../core/widgets/widgets.dart';
import '../../decision/data/models/food_option.dart';

/// The same theatrical composition for illustrated dishes and user photographs.
/// The judge overlaps the frame's margin, keeping the food and all copy clear.
class WinnerHero extends StatelessWidget {
  const WinnerHero({required this.option, super.key});
  final FoodOption option;
  @override
  Widget build(BuildContext context) => AspectRatio(
    aspectRatio: 1.4,
    child: LayoutBuilder(
      builder: (context, box) {
        final width = box.maxWidth;
        return Stack(
          clipBehavior: Clip.none,
          children: [
            const Positioned.fill(child: CustomPaint(painter: _BurstPainter())),
            const Positioned(right: 4, top: 0, child: DinerStar(size: 30)),
            const Positioned(left: 0, top: 18, child: DinerStar(size: 18)),
            if (option.hasImage)
              Positioned(
                left: width * .035,
                top: width * .025,
                right: width * .13,
                bottom: width * .10,
                child: Transform.rotate(
                  angle: -.045,
                  child: Container(
                    padding: const EdgeInsets.all(AppDimensions.spaceSm),
                    decoration: BoxDecoration(
                      color: AppColors.background,
                      border: Border.all(
                        color: AppColors.accent,
                        width: DinerTokens.border,
                      ),
                      boxShadow: AppDimensions.shadowRetroSm,
                    ),
                    child: ClipRRect(
                      borderRadius: AppDimensions.borderRadiusSm,
                      child: Image.memory(
                        option.imageBytes!,
                        fit: BoxFit.cover,
                        cacheWidth: DinerTokens.photoDecodeWidth,
                        semanticLabel: context.l10n.a11y_photoOf(option.name),
                        errorBuilder: (_, error, stack) => FoodIllustration(
                          name: option.name,
                          illustrationId: option.illustrationId,
                          size: width * .65,
                        ),
                      ),
                    ),
                  ),
                ),
              )
            else
              Positioned(
                left: -width * .025,
                top: width * .025,
                bottom: width * .01,
                right: width * .20,
                child: FoodIllustration(
                  name: option.name,
                  illustrationId: option.illustrationId,
                  size: width * .75,
                ),
              ),
            Positioned(
              right: -width * .04,
              bottom: -width * .025,
              child: JudgeBite(
                pose: JudgeBitePose.celebrating,
                dimension: width * (option.hasImage ? .35 : .43),
              ),
            ),
          ],
        );
      },
    ),
  );
}

class _BurstPainter extends CustomPainter {
  const _BurstPainter();
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width * .49, size.height * .5);
    final path = Path();
    for (var i = 0; i < 24; i++) {
      final angle = -math.pi / 2 + i * math.pi / 12;
      final radius = i.isEven ? 1.0 : .65;
      final point =
          center +
          Offset(
            math.cos(angle) * size.width * .52 * radius,
            math.sin(angle) * size.height * .49 * radius,
          );
      if (i == 0) {
        path.moveTo(point.dx, point.dy);
      } else {
        path.lineTo(point.dx, point.dy);
      }
    }
    canvas.drawPath(path..close(), Paint()..color = AppColors.pop);
    canvas.drawPath(
      path,
      Paint()
        ..color = AppColors.accent
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.5,
    );
  }

  @override
  bool shouldRepaint(_BurstPainter old) => false;
}
