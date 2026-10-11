import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../config/routes/app_router.dart';
import '../../../core/theme/theme.dart';
import '../../../core/utils/l10n_extensions.dart';
import '../../../core/widgets/widgets.dart';

/// A brief branded welcome, skipped immediately when reduced motion is enabled.
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Timer? _timer;
  bool _started = false;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_started) return;
    _started = true;
    _timer = Timer(
      reduceDinerMotion(context)
          ? Duration.zero
          : const Duration(milliseconds: 1100),
      () {
        if (mounted) context.go(AppRouter.home);
      },
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: AppColors.primary,
    body: SafeArea(
      child: LayoutBuilder(
        builder: (context, box) => SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: box.maxHeight),
            child: Padding(
              padding: const EdgeInsets.all(AppDimensions.spaceLg),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const DinerEntrance(
                    child: SizedBox(
                      width: DinerTokens.splashWordmark,
                      child: DinerWordmark(),
                    ),
                  ),
                  const SizedBox(height: AppDimensions.spaceLg),
                  const DinerEntrance(
                    order: 1,
                    child: JudgeBite(
                      pose: JudgeBitePose.waving,
                      dimension: DinerTokens.heroJudge,
                    ),
                  ),
                  const SizedBox(height: AppDimensions.spaceLg),
                  DinerEntrance(
                    order: 2,
                    child: DinerSignText(context.l10n.diner_welcome),
                  ),
                  const SizedBox(height: AppDimensions.spaceXl),
                  const SizedBox(
                    width: DinerTokens.splashTrim,
                    child: CheckerboardTrim(),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    ),
  );
}
