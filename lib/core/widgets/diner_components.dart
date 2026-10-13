import 'dart:math' as math;
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../services/court_feedback.dart';
import '../theme/theme.dart';
import 'diner_motion.dart';
import 'food_illustration.dart';

/// Raised diner action treatments.
enum DinerButtonStyle { orange, mustard, outline }

/// Accessible native ink action with a tactile, animated hard shadow.
class DinerButton extends ConsumerStatefulWidget {
  /// Creates a raised diner action with native focus and ink feedback.
  const DinerButton({
    required this.label,
    required this.onPressed,
    this.icon,
    this.style = DinerButtonStyle.orange,
    this.loading = false,
    super.key,
  });

  /// Localized visible label and accessible action name.
  final String label;

  /// Action callback; null disables the control.
  final VoidCallback? onPressed;

  /// Optional leading icon accompanying the label.
  final IconData? icon;

  /// Color treatment and border style of the action.
  final DinerButtonStyle style;

  /// Shows progress and temporarily disables the action.
  final bool loading;

  @override
  ConsumerState<DinerButton> createState() => _DinerButtonState();
}

class _DinerButtonState extends ConsumerState<DinerButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final enabled = widget.onPressed != null && !widget.loading;
    final outlined = widget.style == DinerButtonStyle.outline;
    final color = !enabled
        ? scheme.surfaceContainerHighest
        : switch (widget.style) {
            DinerButtonStyle.orange => AppColors.primary,
            DinerButtonStyle.mustard => AppColors.pop,
            DinerButtonStyle.outline => scheme.surface,
          };
    final ink = outlined || !enabled ? scheme.onSurface : AppColors.accent;
    final duration = reduceDinerMotion(context)
        ? Duration.zero
        : DinerTokens.press;
    return Semantics(
      button: true,
      enabled: enabled,
      child: Padding(
        padding: const EdgeInsets.only(bottom: DinerTokens.shadow),
        child: AnimatedContainer(
          duration: duration,
          transform: Matrix4.translationValues(
            0,
            _pressed ? DinerTokens.shadow : 0,
            0,
          ),
          decoration: BoxDecoration(
            borderRadius: AppDimensions.borderRadiusMd,
            boxShadow: enabled
                ? [
                    BoxShadow(
                      color: AppColors.accent,
                      offset: Offset(0, _pressed ? 0 : DinerTokens.shadow),
                    ),
                  ]
                : null,
          ),
          child: Material(
            color: color,
            shape: RoundedRectangleBorder(
              borderRadius: AppDimensions.borderRadiusMd,
              side: BorderSide(
                color: enabled ? ink : scheme.outline,
                width: DinerTokens.border,
              ),
            ),
            clipBehavior: Clip.antiAlias,
            child: InkWell(
              // CourtFeedback owns sound and haptics so saved preferences and
              // reduced motion also suppress the platform's default tap cue.
              enableFeedback: false,
              onTap: !enabled
                  ? null
                  : () {
                      CourtFeedback.play(context, ref, CourtCue.selection);
                      widget.onPressed?.call();
                    },
              onHighlightChanged: (value) => setState(() => _pressed = value),
              child: ConstrainedBox(
                constraints: const BoxConstraints(
                  minHeight: DinerTokens.buttonHeight,
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppDimensions.spaceMd,
                    vertical: AppDimensions.spaceSm,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (widget.loading) ...[
                        SizedBox(
                          width: AppDimensions.iconSizeMd,
                          height: AppDimensions.iconSizeMd,
                          child: CircularProgressIndicator(
                            value: reduceDinerMotion(context) ? .7 : null,
                            strokeWidth: DinerTokens.border,
                            color: ink,
                          ),
                        ),
                        const SizedBox(width: AppDimensions.spaceSm),
                      ] else if (widget.icon != null) ...[
                        Icon(
                          widget.icon,
                          color: ink,
                          size: AppDimensions.iconSizeLg,
                        ),
                        const SizedBox(width: AppDimensions.spaceSm),
                      ],
                      Flexible(
                        child: Text(
                          widget.label.toUpperCase(),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: AppTypography.displayFont,
                            fontSize: DinerTokens.buttonType,
                            color: ink,
                            letterSpacing: .7,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Compact utility action with a minimum 48dp hit area.
class DinerIconButton extends ConsumerWidget {
  /// Creates a full-size utility target with a localized tooltip.
  const DinerIconButton({
    required this.icon,
    required this.label,
    required this.onPressed,
    super.key,
  });

  /// Optional leading icon accompanying the label.
  final IconData icon;

  /// Localized visible label and accessible action name.
  final String label;

  /// Action callback; null disables the control.
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context, WidgetRef ref) => IconButton(
    tooltip: label,
    enableFeedback: false,
    onPressed: onPressed == null
        ? null
        : () {
            CourtFeedback.play(context, ref, CourtCue.selection);
            onPressed!();
          },
    icon: Icon(icon),
    style: IconButton.styleFrom(
      foregroundColor: AppColors.accent,
      backgroundColor: AppColors.background,
      minimumSize: const Size.square(DinerTokens.touchTarget),
      side: const BorderSide(
        color: AppColors.accent,
        width: DinerTokens.border,
      ),
    ),
  );
}

/// Outlined cream diner-sign lettering. The duplicated paint is decorative.
class DinerSignText extends StatelessWidget {
  /// Creates outlined live masthead lettering.
  const DinerSignText(this.text, {this.size = DinerTokens.signSize, super.key});

  /// Localized live text, preserved for scaling and accessibility.
  final String text;

  /// Logical extent of the artwork or lettering before text scaling.
  final double size;
  @override
  Widget build(BuildContext context) {
    final base = TextStyle(
      fontFamily: AppTypography.displayFont,
      fontSize: size,
      height: 1.05,
      letterSpacing: 1.2,
    );
    return Semantics(
      label: text,
      child: ExcludeSemantics(
        child: Stack(
          alignment: Alignment.center,
          children: [
            Transform.translate(
              offset: const Offset(2, 3),
              child: Text(
                text.toUpperCase(),
                textAlign: TextAlign.center,
                style: base.copyWith(color: AppColors.accent),
              ),
            ),
            Text(
              text.toUpperCase(),
              textAlign: TextAlign.center,
              style: base.copyWith(
                foreground: Paint()
                  ..style = PaintingStyle.stroke
                  ..strokeWidth = 3
                  ..color = AppColors.accent,
              ),
            ),
            Text(
              text.toUpperCase(),
              textAlign: TextAlign.center,
              style: base.copyWith(color: AppColors.background),
            ),
          ],
        ),
      ),
    );
  }
}

/// Approved branded lettering. The readable text remains the semantic label.
class DinerWordmark extends StatelessWidget {
  /// Creates the approved raster lettering with a spoken brand label.
  const DinerWordmark({super.key});
  @override
  Widget build(BuildContext context) => Semantics(
    label: 'FoodJury',
    image: true,
    child: ExcludeSemantics(
      child: Image.asset(
        'assets/images/brand/foodjury-wordmark.png',
        height: DinerTokens.headerHeight - AppDimensions.spaceMd,
        fit: BoxFit.contain,
        errorBuilder: (context, error, stack) =>
            const DinerSignText('FoodJury'),
      ),
    ),
  );
}

/// Responsive expressive headline, using live text for localization and scaling.
class DinerHeading extends StatelessWidget {
  /// Creates an expressive localized display heading.
  const DinerHeading(
    this.text, {
    this.center = false,
    this.large = false,
    super.key,
  });

  /// Localized live text, preserved for scaling and accessibility.
  final String text;

  /// Whether to center the heading instead of aligning it to the start.
  final bool center;

  /// Uses the larger dimensions intended for a wide composition.
  final bool large;
  @override
  Widget build(BuildContext context) => Semantics(
    header: true,
    child: Text(
      text.toUpperCase(),
      textAlign: center ? TextAlign.center : TextAlign.start,
      style: TextStyle(
        fontFamily: AppTypography.displayFont,
        fontSize:
            MediaQuery.textScalerOf(context).scale(1) >=
                DinerTokens.largeTextBreakpoint
            ? DinerTokens.accessibleHeadline
            : large
            ? DinerTokens.tabletHeadline
            : DinerTokens.headline,
        height: 1.08,
        letterSpacing: .5,
        color: Theme.of(context).colorScheme.onSurface,
      ),
    ),
  );
}

/// Menu section divider with room for a translated label and optional action.
class DinerSection extends StatelessWidget {
  /// Creates a menu divider that adapts to large text.
  const DinerSection(this.title, {this.action, super.key});

  /// Localized heading displayed by this component.
  final String title;

  /// Optional utility action placed after the section heading.
  final Widget? action;
  @override
  Widget build(BuildContext context) {
    final heading = Text(
      title.toUpperCase(),
      style: TextStyle(
        fontFamily: AppTypography.displayFont,
        fontSize: DinerTokens.sectionType,
        color: Theme.of(context).colorScheme.onSurface,
      ),
    );
    if (action != null &&
        MediaQuery.textScalerOf(context).scale(1) >=
            DinerTokens.largeTextBreakpoint) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          heading,
          Align(alignment: Alignment.centerRight, child: action),
        ],
      );
    }
    return Row(
      children: [
        const SizedBox(
          width: AppDimensions.spaceLg,
          child: Divider(thickness: 2),
        ),
        const SizedBox(width: AppDimensions.spaceSm),
        Flexible(flex: 5, child: heading),
        const SizedBox(width: AppDimensions.spaceSm),
        const Flexible(child: Divider(thickness: 2)),
        if (action != null) action!,
      ],
    );
  }
}

/// A reusable bordered order-ticket surface with optional hard elevation.
class DinerTicket extends StatelessWidget {
  /// Creates a paper surface with an optional dashed or raised treatment.
  const DinerTicket({
    required this.child,
    this.color,
    this.raised = false,
    this.dashed = false,
    this.padding = const EdgeInsets.all(AppDimensions.spaceMd),
    super.key,
  });

  /// The content composed inside this component.
  final Widget child;

  /// Optional color override; otherwise uses the component’s theme defaults.
  final Color? color;

  /// Adds the system’s hard offset shadow.
  final bool raised;

  /// Draws a dashed ticket outline instead of a solid border.
  final bool dashed;

  /// Space between the component boundary and its content.
  final EdgeInsets padding;
  @override
  Widget build(BuildContext context) => CustomPaint(
    foregroundPainter: dashed
        ? _DashedTicketPainter(Theme.of(context).colorScheme.onSurface)
        : null,
    child: Container(
      padding: padding,
      decoration: BoxDecoration(
        color: color ?? Theme.of(context).colorScheme.surface,
        borderRadius: AppDimensions.borderRadiusMd,
        border: dashed
            ? null
            : Border.all(
                color: Theme.of(context).colorScheme.onSurface,
                width: DinerTokens.border,
              ),
        boxShadow: raised ? AppDimensions.shadowRetroSm : null,
      ),
      child: child,
    ),
  );
}

/// Clear selection chip that wraps text instead of clipping at large text sizes.
class DinerChoice extends ConsumerWidget {
  /// Creates a selectable option with explicit selected semantics.
  const DinerChoice({
    required this.label,
    required this.selected,
    required this.onTap,
    this.icon,
    super.key,
  });

  /// Localized visible label and accessible action name.
  final String label;

  /// Whether this choice is currently selected; also exposed to semantics.
  final bool selected;

  /// Callback invoked when this choice is activated.
  final VoidCallback onTap;

  /// Optional leading icon accompanying the label.
  final IconData? icon;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ink = selected
        ? AppColors.accent
        : Theme.of(context).colorScheme.onSurface;
    return Semantics(
      button: true,
      enabled: true,
      selected: selected,
      child: Material(
        color: selected ? AppColors.pop : Theme.of(context).colorScheme.surface,
        shape: RoundedRectangleBorder(
          borderRadius: AppDimensions.borderRadiusMd,
          side: BorderSide(color: ink, width: DinerTokens.border),
        ),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          enableFeedback: false,
          onTap: () {
            CourtFeedback.play(context, ref, CourtCue.selection);
            onTap();
          },
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              minHeight: DinerTokens.touchTarget,
            ),
            child: Padding(
              padding: const EdgeInsets.all(AppDimensions.spaceSm),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (selected || icon != null) ...[
                    Icon(selected ? Icons.check_rounded : icon, color: ink),
                    const SizedBox(width: AppDimensions.spaceSm),
                  ],
                  Flexible(
                    child: Text(
                      label,
                      textAlign: TextAlign.center,
                      style: TextStyle(fontWeight: FontWeight.w800, color: ink),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// The verdict stamp is live text, so long food names never enter this badge.
class DinerStamp extends StatelessWidget {
  /// Creates a tilted live-text badge.
  const DinerStamp(
    this.label, {
    this.orange = false,
    this.tilt = true,
    super.key,
  });

  /// Localized visible label and accessible action name.
  final String label;

  /// Uses orange instead of mustard for the stamp surface.
  final bool orange;

  /// Applies the small characteristic diner stamp rotation.
  final bool tilt;
  @override
  Widget build(BuildContext context) => Transform.rotate(
    angle: tilt ? -.075 : 0,
    child: Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.spaceMd,
        vertical: AppDimensions.spaceXs,
      ),
      decoration: BoxDecoration(
        color: orange ? AppColors.primary : AppColors.pop,
        borderRadius: AppDimensions.borderRadiusSm,
        border: Border.all(color: AppColors.accent, width: DinerTokens.border),
      ),
      child: Text(
        label.toUpperCase(),
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontFamily: AppTypography.displayFont,
          fontSize: DinerTokens.stampType,
          color: AppColors.accent,
          letterSpacing: 1,
        ),
      ),
    ),
  );
}

/// Food evidence shows the actual user image or an honest illustrated placeholder.
class DinerFoodImage extends StatelessWidget {
  /// Shows user evidence first and decorative food artwork otherwise.
  const DinerFoodImage({
    this.bytes,
    this.label,
    this.foodName = '',
    this.illustrationId,
    this.size = DinerTokens.thumbnail,
    super.key,
  });

  /// Original user-selected photo data; null uses decorative illustration.
  final Uint8List? bytes;

  /// Food name used to select a decorative fallback when no photo exists.
  final String foodName;
  final String? illustrationId;

  /// Localized visible label and accessible action name.
  final String? label;

  /// Logical extent of the artwork or lettering before text scaling.
  final double size;
  @override
  Widget build(BuildContext context) => ClipRRect(
    borderRadius: AppDimensions.borderRadiusSm,
    child: SizedBox(
      width: size,
      height: size,
      child: bytes != null && bytes!.isNotEmpty
          ? Image.memory(
              bytes!,
              fit: BoxFit.cover,
              cacheWidth: (size * MediaQuery.devicePixelRatioOf(context))
                  .ceil(),
              semanticLabel: label,
              errorBuilder: (context, error, stack) =>
                  _FoodPlaceholder(foodName, illustrationId),
            )
          : _FoodPlaceholder(foodName, illustrationId),
    ),
  );
}

class _FoodPlaceholder extends StatelessWidget {
  const _FoodPlaceholder(this.name, this.illustrationId);
  final String? illustrationId;
  final String name;
  @override
  Widget build(BuildContext context) => ColoredBox(
    color: AppColors.pop.withValues(alpha: .24),
    child: Padding(
      padding: const EdgeInsets.all(AppDimensions.spaceXs),
      child: FoodIllustration(name: name, illustrationId: illustrationId),
    ),
  );
}

/// Small geometric diner starburst used as a decorative accent only.
class DinerStar extends StatelessWidget {
  /// Creates a decorative mustard starburst.
  const DinerStar({this.size = AppDimensions.iconSizeXl, super.key});

  /// Logical extent of the artwork or lettering before text scaling.
  final double size;
  @override
  Widget build(BuildContext context) => ExcludeSemantics(
    child: SizedBox.square(
      dimension: size,
      child: CustomPaint(painter: _StarPainter()),
    ),
  );
}

class _StarPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final path = Path();
    for (var i = 0; i < 16; i++) {
      final radius = size.shortestSide * (i.isEven ? .5 : .19);
      final angle = i * math.pi / 8;
      final point =
          center + Offset(math.cos(angle) * radius, math.sin(angle) * radius);
      if (i == 0) {
        path.moveTo(point.dx, point.dy);
      } else {
        path.lineTo(point.dx, point.dy);
      }
    }
    path.close();
    canvas.drawPath(path, Paint()..color = AppColors.pop);
  }

  @override
  bool shouldRepaint(covariant _StarPainter oldDelegate) => false;
}

class _DashedTicketPainter extends CustomPainter {
  const _DashedTicketPainter(this.ink);
  final Color ink;
  @override
  void paint(Canvas canvas, Size size) {
    final path = Path()
      ..addRRect(
        RRect.fromRectAndRadius(
          (Offset.zero & size).deflate(1),
          const Radius.circular(DinerTokens.radius),
        ),
      );
    final paint = Paint()
      ..color = ink
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;
    for (final metric in path.computeMetrics()) {
      for (double distance = 0; distance < metric.length; distance += 9) {
        canvas.drawPath(metric.extractPath(distance, distance + 5), paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant _DashedTicketPainter old) => old.ink != ink;
}
