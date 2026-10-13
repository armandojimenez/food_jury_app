import 'package:flutter/material.dart';

import '../../../core/theme/theme.dart';
import '../../../core/utils/l10n_extensions.dart';
import '../../../core/widgets/widgets.dart';

/// Mount only after durable save succeeds. Never celebrates a pending write.
class SavedCaseMoment extends StatefulWidget {
  const SavedCaseMoment({
    required this.animate,
    this.compact = false,
    super.key,
  });
  final bool animate;
  final bool compact;
  @override
  State<SavedCaseMoment> createState() => _SavedCaseMomentState();
}

class _SavedCaseMomentState extends State<SavedCaseMoment>
    with SingleTickerProviderStateMixin {
  late final _controller = AnimationController(
    vsync: this,
    duration: DinerTokens.filingStamp,
  );
  bool _started = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!widget.animate ||
        reduceDinerMotion(context) ||
        MediaQuery.textScalerOf(context).scale(1) >=
            DinerTokens.largeTextBreakpoint) {
      _controller.stop();
      _controller.value = 1;
    } else if (!_started) {
      _started = true;
      _controller.forward();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Semantics(
    key: const Key('case-filed'),
    container: true,
    liveRegion: true,
    label: context.l10n.moments_filedAnnouncement,
    excludeSemantics: true,
    child: DinerTicket(
      dashed: true,
      child: Row(
        children: [
          JudgeBite(
            pose: JudgeBitePose.filing,
            dimension: widget.compact
                ? DinerTokens.touchTarget
                : DinerTokens.thumbnail,
          ),
          const SizedBox(width: AppDimensions.spaceSm),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AnimatedBuilder(
                  animation: _controller,
                  child: DinerStamp(context.l10n.moments_filed),
                  builder: (context, child) {
                    final landing = Curves.easeOutBack.transform(
                      ((_controller.value - .15) / .65).clamp(0, 1),
                    );
                    return Opacity(
                      opacity: (_controller.value / .3).clamp(0, 1),
                      child: Transform.translate(
                        offset: Offset(
                          0,
                          (1 - landing) * -AppDimensions.spaceMd,
                        ),
                        child: Transform.scale(
                          alignment: Alignment.centerLeft,
                          scale: 1.35 - .35 * landing,
                          child: child,
                        ),
                      ),
                    );
                  },
                ),
                if (!widget.compact) ...[
                  const SizedBox(height: AppDimensions.spaceSm),
                  Text(context.l10n.moments_filedHint),
                ],
              ],
            ),
          ),
        ],
      ),
    ),
  );
}
