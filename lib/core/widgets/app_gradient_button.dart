import 'package:flutter/material.dart';
import 'diner_components.dart';

/// Compatibility name for the mustard diner hero action.
class AppGradientButton extends StatelessWidget {
  const AppGradientButton({
    required this.label,
    required this.onPressed,
    this.icon,
    super.key,
  });
  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  @override
  Widget build(BuildContext context) => DinerButton(
    label: label,
    onPressed: onPressed,
    icon: icon,
    style: DinerButtonStyle.mustard,
  );
}
