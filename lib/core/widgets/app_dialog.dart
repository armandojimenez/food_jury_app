import 'package:flutter/material.dart';

import '../theme/theme.dart';
import '../utils/l10n_extensions.dart';
import 'diner_components.dart';
import 'diner_motion.dart';

/// Scrollable diner dialogs; actions stack naturally at large text sizes.
abstract final class AppDialog {
  static Future<bool> showConfirmation(
    BuildContext context, {
    required String title,
    required String message,
    String? confirmText,
    String? cancelText,
    IconData? icon,
  }) async =>
      await showDialog<bool>(
        context: context,
        animationStyle: reduceDinerMotion(context)
            ? AnimationStyle.noAnimation
            : null,
        builder: (dialogContext) => _DinerDialog(
          title: title,
          message: message,
          icon: icon,
          actions: [
            DinerButton(
              label: confirmText ?? context.l10n.common_yes,
              onPressed: () => Navigator.of(dialogContext).pop(true),
            ),
            DinerButton(
              label: cancelText ?? context.l10n.common_cancel,
              style: DinerButtonStyle.outline,
              onPressed: () => Navigator.of(dialogContext).pop(false),
            ),
          ],
        ),
      ) ??
      false;

  static Future<void> showAlert(
    BuildContext context, {
    required String title,
    required String message,
    String? buttonText,
    IconData? icon,
  }) => showDialog<void>(
    context: context,
    animationStyle: reduceDinerMotion(context)
        ? AnimationStyle.noAnimation
        : null,
    builder: (dialogContext) => _DinerDialog(
      title: title,
      message: message,
      icon: icon,
      actions: [
        DinerButton(
          label: buttonText ?? context.l10n.common_close,
          onPressed: () => Navigator.of(dialogContext).pop(),
        ),
      ],
    ),
  );

  static Future<void> showVerdict(
    BuildContext context, {
    required String title,
    required String message,
  }) => showAlert(
    context,
    title: title,
    message: message,
    icon: Icons.gavel_rounded,
  );

  static Future<T?> showCustom<T>(
    BuildContext context, {
    required Widget child,
  }) => showDialog<T>(
    context: context,
    animationStyle: reduceDinerMotion(context)
        ? AnimationStyle.noAnimation
        : null,
    builder: (_) => Dialog(child: SingleChildScrollView(child: child)),
  );
}

class _DinerDialog extends StatelessWidget {
  const _DinerDialog({
    required this.title,
    required this.message,
    required this.actions,
    this.icon,
  });
  final String title;
  final String message;
  final List<Widget> actions;
  final IconData? icon;

  @override
  Widget build(BuildContext context) => Dialog(
    child: SingleChildScrollView(
      padding: const EdgeInsets.all(AppDimensions.spaceLg),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (icon != null) ...[
            Icon(icon, size: AppDimensions.iconSizeXl),
            const SizedBox(height: AppDimensions.spaceMd),
          ],
          DinerHeading(title),
          const SizedBox(height: AppDimensions.spaceMd),
          Text(message, style: Theme.of(context).textTheme.bodyLarge),
          const SizedBox(height: AppDimensions.spaceLg),
          for (final action in actions)
            Padding(
              padding: const EdgeInsets.only(bottom: AppDimensions.spaceSm),
              child: action,
            ),
        ],
      ),
    ),
  );
}

/// Safe, keyboard-aware shared sheet for small utility flows.
abstract final class AppBottomSheet {
  static Future<T?> show<T>(
    BuildContext context, {
    required Widget child,
    bool isDismissible = true,
  }) => showModalBottomSheet<T>(
    context: context,
    isDismissible: isDismissible,
    enableDrag: isDismissible,
    isScrollControlled: true,
    useSafeArea: true,
    showDragHandle: true,
    sheetAnimationStyle: reduceDinerMotion(context)
        ? AnimationStyle.noAnimation
        : null,
    builder: (sheetContext) => SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(
        AppDimensions.spaceLg,
        0,
        AppDimensions.spaceLg,
        MediaQuery.viewInsetsOf(sheetContext).bottom +
            MediaQuery.paddingOf(sheetContext).bottom +
            AppDimensions.spaceLg,
      ),
      child: child,
    ),
  );
}
