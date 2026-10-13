import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

import '../../config/routes/app_router.dart';
import '../theme/theme.dart';
import '../utils/l10n_extensions.dart';
import 'diner_components.dart';
import 'diner_display.dart';

/// Navy full-screen stage with legible native status and navigation icons.
class DinerNightSurface extends StatelessWidget {
  /// Creates a dramatic loading or reveal surface.
  const DinerNightSurface({required this.child, super.key});

  /// Content displayed on the navy stage.
  final Widget child;

  @override
  Widget build(BuildContext context) => AnnotatedRegion<SystemUiOverlayStyle>(
    value: SystemUiOverlayStyle.light.copyWith(
      statusBarColor: Colors.transparent,
      systemNavigationBarColor: AppColors.accent,
      systemNavigationBarIconBrightness: Brightness.light,
    ),
    child: Material(color: AppColors.accent, child: child),
  );
}

/// App shell shared by every diner screen, including tablet and landscape.
class DinerScaffold extends StatelessWidget {
  /// Creates the responsive court shell and its optional navigation.
  const DinerScaffold({
    required this.child,
    this.title,
    this.showBack = true,
    this.onBack,
    this.showLogo = false,
    this.trailing,
    this.bottomAction,
    this.navigationIndex,
    this.scrollable = true,
    this.maxWidth = DinerTokens.contentWidth,
    this.padding = const EdgeInsets.all(DinerTokens.pageInset),
    super.key,
  });

  /// The content composed inside this component.
  final Widget child;

  /// Localized heading displayed by this component.
  final String? title;

  /// Shows a back action that safely falls back to the court.
  final bool showBack;

  /// Overrides back navigation when a screen must protect unfinished work.
  final VoidCallback? onBack;

  /// Uses the FoodJury wordmark in place of the text title.
  final bool showLogo;

  /// Optional action at the end of the masthead.
  final Widget? trailing;

  /// Optional safe-area action outside the scrolling content.
  final Widget? bottomAction;

  /// Court (0) or history (1); null omits bottom navigation.
  final int? navigationIndex;

  /// False when the child supplies its own lazy scroll view.
  final bool scrollable;

  /// Maximum content width before centering within the window.
  final double maxWidth;

  /// Space between the component boundary and its content.
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    final inlineAction =
        bottomAction != null &&
        (MediaQuery.textScalerOf(context).scale(1) >=
                DinerTokens.largeTextBreakpoint ||
            MediaQuery.sizeOf(context).height <
                DinerTokens.compactWindowHeight);
    final body = Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: SafeArea(
          top: false,
          bottom:
              navigationIndex == null && (bottomAction == null || inlineAction),
          minimum: padding,
          child: SizedBox(
            width: double.infinity,
            child: inlineAction
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      child,
                      const SizedBox(height: AppDimensions.spaceLg),
                      bottomAction!,
                    ],
                  )
                : child,
          ),
        ),
      ),
    );
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark.copyWith(
        statusBarColor: Colors.transparent,
        systemNavigationBarColor: Theme.of(context).scaffoldBackgroundColor,
        systemNavigationBarIconBrightness:
            Theme.of(context).brightness == Brightness.dark
            ? Brightness.light
            : Brightness.dark,
      ),
      child: Scaffold(
        body: Column(
          children: [
            DinerMasthead(
              title: title,
              showBack: showBack,
              onBack: onBack,
              showLogo: showLogo,
              trailing: trailing,
            ),
            Expanded(
              child: scrollable
                  ? SingleChildScrollView(
                      keyboardDismissBehavior:
                          ScrollViewKeyboardDismissBehavior.onDrag,
                      child: body,
                    )
                  : body,
            ),
          ],
        ),
        bottomNavigationBar: bottomAction != null && !inlineAction
            ? SafeArea(
                top: false,
                minimum: const EdgeInsets.fromLTRB(
                  DinerTokens.pageInset,
                  AppDimensions.spaceSm,
                  DinerTokens.pageInset,
                  AppDimensions.spaceMd,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Flexible(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(
                          maxWidth: DinerTokens.readingWidth,
                        ),
                        child: bottomAction!,
                      ),
                    ),
                  ],
                ),
              )
            : navigationIndex == null
            ? null
            : DinerNavigation(selectedIndex: navigationIndex!),
      ),
    );
  }
}

/// Orange sign and checkerboard trim. Decoration never displaces safe areas.
class DinerMasthead extends StatelessWidget {
  /// Creates the orange sign, safe area and checker trim.
  const DinerMasthead({
    this.title,
    this.showBack = true,
    this.onBack,
    this.showLogo = false,
    this.trailing,
    super.key,
  });

  /// Localized heading displayed by this component.
  final String? title;

  /// Shows a back action that safely falls back to the court.
  final bool showBack;

  /// Overrides back navigation when a screen must protect unfinished work.
  final VoidCallback? onBack;

  /// Uses the FoodJury wordmark in place of the text title.
  final bool showLogo;

  /// Optional action at the end of the masthead.
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.signHighlight,
            AppColors.primary,
            AppColors.signShade,
          ],
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SafeArea(
            bottom: false,
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(
                  maxWidth: DinerTokens.contentWidth,
                  minHeight: DinerTokens.headerHeight,
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: DinerTokens.pageInset,
                    vertical: AppDimensions.spaceSm,
                  ),
                  child:
                      MediaQuery.textScalerOf(context).scale(1) >=
                              DinerTokens.largeTextBreakpoint &&
                          !showLogo
                      ? Column(
                          children: [
                            Row(
                              children: [
                                if (showBack)
                                  DinerIconButton(
                                    icon: Icons.arrow_back_rounded,
                                    label: context.l10n.common_back,
                                    onPressed:
                                        onBack ??
                                        () => context.canPop()
                                            ? context.pop()
                                            : context.go(AppRouter.home),
                                  ),
                                const Spacer(),
                                if (trailing != null) trailing!,
                              ],
                            ),
                            DinerSignText(
                              title ?? '',
                              size: DinerTokens.buttonType,
                            ),
                          ],
                        )
                      : Row(
                          children: [
                            if (showBack) ...[
                              DinerIconButton(
                                icon: Icons.arrow_back_rounded,
                                label: context.l10n.common_back,
                                onPressed:
                                    onBack ??
                                    () => context.canPop()
                                        ? context.pop()
                                        : context.go(AppRouter.home),
                              ),
                              const SizedBox(width: AppDimensions.spaceMd),
                            ],
                            Expanded(
                              child: showLogo
                                  ? const DinerWordmark()
                                  : DinerArcSign(
                                      title ?? '',
                                      size: DinerTokens.signSize,
                                    ),
                            ),
                            if (trailing != null) ...[
                              const SizedBox(width: AppDimensions.spaceMd),
                              trailing!,
                            ] else if (showBack)
                              const SizedBox(
                                width: DinerTokens.touchTarget,
                                child: Center(child: DinerStar(size: 27)),
                              ),
                          ],
                        ),
                ),
              ),
            ),
          ),
          const CheckerboardTrim(),
        ],
      ),
    );
  }
}

/// Checker trim is drawn at device-independent size, never stretched.
class CheckerboardTrim extends StatelessWidget {
  /// Creates the two-row diner checker trim.
  const CheckerboardTrim({super.key});
  @override
  Widget build(BuildContext context) => const ExcludeSemantics(
    child: SizedBox(
      height: DinerTokens.checkerSize * 2,
      width: double.infinity,
      child: CustomPaint(painter: _CheckerPainter()),
    ),
  );
}

class _CheckerPainter extends CustomPainter {
  const _CheckerPainter();
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = AppColors.background;
    canvas.drawRect(Offset.zero & size, paint);
    paint.color = AppColors.accent;
    const cell = DinerTokens.checkerSize;
    for (var y = 0; y < 2; y++) {
      for (var x = 0; x < (size.width / cell).ceil(); x++) {
        if ((x + y).isEven) {
          canvas.drawRect(Rect.fromLTWH(x * cell, y * cell, cell, cell), paint);
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant _CheckerPainter oldDelegate) => false;
}

/// Two destinations mirror the diner counter and its archive.
class DinerNavigation extends StatelessWidget {
  /// Creates the court and archive destinations.
  const DinerNavigation({required this.selectedIndex, super.key});

  /// Selected bottom destination: court (0) or history (1).
  final int selectedIndex;

  @override
  Widget build(BuildContext context) {
    final ink = Theme.of(context).colorScheme.onSurface;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        border: Border(
          top: BorderSide(color: ink, width: DinerTokens.border),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Center(
          heightFactor: 1,
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: DinerTokens.readingWidth,
            ),
            child: Row(
              children: [
                for (var i = 0; i < 2; i++)
                  Expanded(
                    child: Semantics(
                      selected: selectedIndex == i,
                      child: TextButton(
                        onPressed: () {
                          if (selectedIndex != i) {
                            context.go(
                              i == 0 ? AppRouter.home : AppRouter.history,
                            );
                          }
                        },
                        style: TextButton.styleFrom(
                          foregroundColor: ink,
                          padding: const EdgeInsets.symmetric(
                            vertical: AppDimensions.spaceSm,
                            horizontal: AppDimensions.spaceMd,
                          ),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              i == 0
                                  ? Icons.home_rounded
                                  : Icons.history_rounded,
                              color: selectedIndex == i
                                  ? AppColors.primary
                                  : ink,
                              size: AppDimensions.iconSizeLg,
                            ),
                            Text(
                              i == 0
                                  ? context.l10n.diner_court
                                  : context.l10n.diner_history,
                              style: TextStyle(
                                fontWeight: selectedIndex == i
                                    ? FontWeight.w800
                                    : FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
