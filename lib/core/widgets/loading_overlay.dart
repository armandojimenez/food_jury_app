import 'package:flutter/material.dart';
import '../theme/theme.dart';
import '../utils/l10n_extensions.dart';
import 'diner_components.dart';
import 'diner_motion.dart';
import 'diner_scaffold.dart';
import 'judge_bite.dart';

/// Legacy overlay API that owns its entry and never pops an unrelated route.
class LoadingOverlay extends StatelessWidget {
  const LoadingOverlay({
    required this.message,
    this.variant = LoadingVariant.thinking,
    super.key,
  });
  final String message;
  final LoadingVariant variant;
  static OverlayEntry? _entry;

  @override
  Widget build(BuildContext context) => DinerNightSurface(
    child: SafeArea(
      child: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(DinerTokens.pageInset),
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: DinerTokens.readingWidth,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (variant != LoadingVariant.simple)
                  const JudgeBiteAnimated(
                    pose: JudgeBitePose.thinking,
                    size: JudgeBiteSize.xlarge,
                  ),
                const SizedBox(height: AppDimensions.spaceLg),
                Semantics(liveRegion: true, child: DinerSignText(message)),
                const SizedBox(height: AppDimensions.spaceLg),
                const AppLoadingIndicator(color: AppColors.pop),
              ],
            ),
          ),
        ),
      ),
    ),
  );

  /// Show one owned overlay entry, replacing an earlier one if necessary.
  static void show(
    BuildContext context, {
    required String message,
    LoadingVariant variant = LoadingVariant.thinking,
  }) {
    hide(context);
    final entry = OverlayEntry(
      builder: (_) => Positioned.fill(
        child: LoadingOverlay(message: message, variant: variant),
      ),
    );
    _entry = entry;
    Overlay.of(context, rootOverlay: true).insert(entry);
  }

  /// Remove only the loading entry, without changing navigation.
  static void hide(BuildContext context) {
    _entry?.remove();
    _entry?.dispose();
    _entry = null;
  }
}

enum LoadingVariant { thinking, processing, simple }

/// Progress with a still accessible indicator when motion is reduced.
class AppLoadingIndicator extends StatelessWidget {
  const AppLoadingIndicator({this.size = 40, this.color, super.key});
  final double size;
  final Color? color;
  @override
  Widget build(BuildContext context) => Semantics(
    label: context.l10n.common_loading,
    liveRegion: true,
    child: ExcludeSemantics(
      child: SizedBox.square(
        dimension: size,
        child: CircularProgressIndicator(
          value: reduceDinerMotion(context) ? .7 : null,
          color: color ?? Theme.of(context).colorScheme.primary,
          strokeWidth: DinerTokens.border,
        ),
      ),
    ),
  );
}
