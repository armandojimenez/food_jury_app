import 'package:flutter/material.dart';

import '../theme/theme.dart';

/// Retro styled back button for navigation
class AppBackButton extends StatelessWidget {
  const AppBackButton({this.onPressed, this.color, super.key});

  final VoidCallback? onPressed;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onPressed ?? () => Navigator.of(context).pop(),
      icon: Container(
        padding: const EdgeInsets.all(AppDimensions.spaceSm),
        decoration: BoxDecoration(
          color: (color ?? AppColors.accent).withValues(alpha: 0.1),
          shape: BoxShape.circle,
          border: Border.all(
            color: color ?? AppColors.accent,
            width: AppDimensions.borderMedium,
          ),
        ),
        child: Icon(
          Icons.arrow_back,
          size: AppDimensions.iconSizeMd,
          color: color ?? AppColors.accent,
        ),
      ),
    );
  }
}

/// Retro styled close button for modals and dialogs
class AppCloseButton extends StatelessWidget {
  const AppCloseButton({this.onPressed, this.color, super.key});

  final VoidCallback? onPressed;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onPressed ?? () => Navigator.of(context).pop(),
      icon: Container(
        padding: const EdgeInsets.all(AppDimensions.spaceSm),
        decoration: BoxDecoration(
          color: (color ?? AppColors.error).withValues(alpha: 0.1),
          shape: BoxShape.circle,
          border: Border.all(
            color: color ?? AppColors.error,
            width: AppDimensions.borderMedium,
          ),
        ),
        child: Icon(
          Icons.close,
          size: AppDimensions.iconSizeMd,
          color: color ?? AppColors.error,
        ),
      ),
    );
  }
}

/// Retro app bar with back button and optional title
class AppRetroAppBar extends StatelessWidget implements PreferredSizeWidget {
  const AppRetroAppBar({
    this.title,
    this.actions,
    this.onBackPressed,
    this.showBackButton = true,
    super.key,
  });

  final String? title;
  final List<Widget>? actions;
  final VoidCallback? onBackPressed;
  final bool showBackButton;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.surface,
      elevation: 0,
      leading: showBackButton ? AppBackButton(onPressed: onBackPressed) : null,
      title: title != null
          ? Text(title!, style: AppTypography.titleLarge)
          : null,
      actions: actions,
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(2),
        child: Container(
          height: AppDimensions.borderMedium,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppColors.primary.withValues(alpha: 0.0),
                AppColors.primary,
                AppColors.primary.withValues(alpha: 0.0),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Floating action button with retro styling
class AppFab extends StatefulWidget {
  const AppFab({
    required this.onPressed,
    required this.icon,
    this.label,
    this.backgroundColor,
    super.key,
  });

  final VoidCallback onPressed;
  final IconData icon;
  final String? label;
  final Color? backgroundColor;

  @override
  State<AppFab> createState() => _AppFabState();
}

class _AppFabState extends State<AppFab> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: AppDimensions.durationFast,
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTapDown(TapDownDetails details) {
    _controller.forward();
  }

  void _handleTapUp(TapUpDetails details) {
    _controller.reverse();
  }

  void _handleTapCancel() {
    _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    final label = widget.label;

    return GestureDetector(
      onTapDown: _handleTapDown,
      onTapUp: _handleTapUp,
      onTapCancel: _handleTapCancel,
      onTap: widget.onPressed,
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(scale: _scaleAnimation.value, child: child);
        },
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: label != null
                ? AppDimensions.spaceMd
                : AppDimensions.spaceSm,
            vertical: AppDimensions.spaceSm,
          ),
          decoration: BoxDecoration(
            gradient: AppColors.primaryGradient,
            borderRadius: BorderRadius.circular(
              label != null ? AppDimensions.radiusXl : AppDimensions.radiusFull,
            ),
            border: Border.all(
              color: AppColors.primaryDark,
              width: AppDimensions.borderThick,
            ),
            boxShadow: AppDimensions.shadowLg,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                widget.icon,
                color: AppColors.textInverse,
                size: AppDimensions.iconSizeLg,
              ),
              if (label != null) ...[
                const SizedBox(width: AppDimensions.spaceSm),
                Text(
                  label,
                  style: AppTypography.labelLarge.copyWith(
                    color: AppColors.textInverse,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

/// Navigation tab bar item with retro styling
class AppTabItem extends StatelessWidget {
  const AppTabItem({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
    super.key,
  });

  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        child: AnimatedContainer(
          duration: AppDimensions.durationMedium,
          curve: AppDimensions.curveSnappy,
          padding: const EdgeInsets.symmetric(vertical: AppDimensions.spaceSm),
          decoration: BoxDecoration(
            border: Border(
              top: BorderSide(
                color: isSelected ? AppColors.primary : Colors.transparent,
                width: AppDimensions.borderThick,
              ),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                color: isSelected ? AppColors.primary : AppColors.textMuted,
                size: AppDimensions.iconSizeMd,
              ),
              const SizedBox(height: AppDimensions.spaceXxs),
              Text(
                label,
                style: AppTypography.labelSmall.copyWith(
                  color: isSelected ? AppColors.primary : AppColors.textMuted,
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
