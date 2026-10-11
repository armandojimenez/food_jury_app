import 'package:flutter/material.dart';

import '../theme/theme.dart';
import 'diner_components.dart';

/// Backward-compatible primary action backed by the shared diner control.
class AppButton extends StatelessWidget {
  const AppButton({
    required this.onPressed,
    required this.label,
    this.icon,
    this.isLoading = false,
    this.size = AppButtonSize.medium,
    super.key,
  });
  final VoidCallback? onPressed;
  final String label;
  final IconData? icon;
  final bool isLoading;
  final AppButtonSize size;
  @override
  Widget build(BuildContext context) => DinerButton(
    label: label,
    onPressed: onPressed,
    icon: icon,
    loading: isLoading,
  );
}

/// Outlined supporting action with the same scalable layout as the primary.
class AppSecondaryButton extends StatelessWidget {
  const AppSecondaryButton({
    required this.onPressed,
    required this.label,
    this.icon,
    this.size = AppButtonSize.medium,
    super.key,
  });
  final VoidCallback? onPressed;
  final String label;
  final IconData? icon;
  final AppButtonSize size;
  @override
  Widget build(BuildContext context) => DinerButton(
    label: label,
    onPressed: onPressed,
    icon: icon,
    style: DinerButtonStyle.outline,
  );
}

/// Accessible utility action; retained for existing widget consumers.
class AppIconButton extends StatelessWidget {
  const AppIconButton({
    required this.icon,
    required this.onPressed,
    this.color,
    this.semanticLabel,
    super.key,
  });
  final IconData icon;
  final VoidCallback? onPressed;
  final Color? color;
  final String? semanticLabel;
  @override
  Widget build(BuildContext context) => IconButton(
    icon: Icon(icon),
    onPressed: onPressed,
    tooltip: semanticLabel,
    color: color ?? Theme.of(context).colorScheme.onSurface,
    constraints: const BoxConstraints(minWidth: 48, minHeight: 48),
  );
}

/// Legacy size metadata retained while controls now grow with text scaling.
enum AppButtonSize {
  small(
    height: AppDimensions.buttonHeightSm,
    fontSize: 14,
    padding: EdgeInsets.symmetric(horizontal: 20),
  ),
  medium(
    height: AppDimensions.buttonHeightMd,
    fontSize: 16,
    padding: EdgeInsets.symmetric(horizontal: 32),
  ),
  large(
    height: AppDimensions.buttonHeightLg,
    fontSize: 18,
    padding: EdgeInsets.symmetric(horizontal: 40),
  );

  const AppButtonSize({
    required this.height,
    required this.fontSize,
    required this.padding,
  });
  final double height;
  final double fontSize;
  final EdgeInsets padding;
}
