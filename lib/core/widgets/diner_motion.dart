import 'package:flutter/material.dart';

import '../theme/theme.dart';

/// True when the operating system requests reduced or disabled animation.
bool reduceDinerMotion(BuildContext context) =>
    MediaQuery.disableAnimationsOf(context) ||
    MediaQuery.accessibleNavigationOf(context);

/// A short staggered entrance, automatically bypassed for reduced motion.
class DinerEntrance extends StatefulWidget {
  /// Creates a finite entrance with automatic reduced-motion bypass.
  const DinerEntrance({required this.child, this.order = 0, super.key});

  /// The content composed inside this component.
  final Widget child;

  /// Zero-based stagger step relative to related entering content.
  final int order;

  @override
  State<DinerEntrance> createState() => _DinerEntranceState();
}

class _DinerEntranceState extends State<DinerEntrance>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: DinerTokens.entrance + DinerTokens.stagger * widget.order,
  );
  bool _started = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (reduceDinerMotion(context)) {
      _controller.value = 1;
    } else if (!_started) {
      _controller.forward();
    }
    _started = true;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final delay = DinerTokens.stagger.inMilliseconds * widget.order;
    final total = DinerTokens.entrance.inMilliseconds + delay;
    return AnimatedBuilder(
      animation: _controller,
      child: widget.child,
      builder: (context, child) {
        final t = Interval(
          delay / total,
          1,
          curve: DinerTokens.enterCurve,
        ).transform(_controller.value);
        return Opacity(
          opacity: t,
          child: Transform.translate(
            offset: Offset(0, AppDimensions.spaceMd * (1 - t)),
            child: child,
          ),
        );
      },
    );
  }
}

/// Isolates busy routes from touch, keyboard and assistive technology input.
class DinerBusyBoundary extends StatelessWidget {
  /// Isolates background content while work or a reveal is active.
  const DinerBusyBoundary({required this.busy, required this.child, super.key});

  /// Prevents background interaction and removes its accessible actions.
  final bool busy;

  /// The content composed inside this component.
  final Widget child;
  @override
  Widget build(BuildContext context) => ExcludeFocus(
    excluding: busy,
    child: ExcludeSemantics(
      excluding: busy,
      child: IgnorePointer(ignoring: busy, child: child),
    ),
  );
}
