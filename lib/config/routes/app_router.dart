import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/theme.dart';
import '../../core/utils/l10n_extensions.dart';
import '../../core/widgets/widgets.dart';
import '../../features/decision/data/models/verdict.dart';
import '../../features/lucky/data/decision_case.dart';
import '../../features/lucky/presentation/method_picker_screen.dart';
import '../../features/lucky/presentation/lucky_draw_screen.dart';
import '../../features/lucky/presentation/lucky_verdict_screen.dart';
import '../../features/lucky/presentation/plus_preview_screen.dart';
import '../../features/food_library/presentation/food_library_screen.dart';
import '../../features/decision/presentation/new_decision_screen.dart';
import '../../features/decision/presentation/verdict_screen.dart';
import '../../features/history/presentation/history_screen.dart';
import '../../features/home/presentation/home_screen.dart';
import '../../features/settings/dev_settings_screen.dart';
import '../../features/settings/presentation/about_developer_screen.dart';
import '../../features/settings/presentation/settings_screen.dart';
import '../../features/splash/presentation/splash_screen.dart';
import '../../features/onboarding/presentation/onboarding_screen.dart';
import '../../features/onboarding/data/onboarding_store.dart';
import '../../features/jury/presentation/jury_screen.dart';
import '../../features/case_shelf/data/case_shelf_models.dart';

/// App navigation routes using GoRouter.
///
/// Routes are defined with animations and proper nesting.
/// Includes global error handling for navigation failures.
class AppRouter {
  /// Route path constants
  static const String splash = '/';
  static const String home = '/home';
  static const String onboarding = '/welcome';
  static const String jury = '/jury';
  static const String newDecision = '/decision/new';
  static const String verdict = '/decision/verdict';
  static const String methods = '/decision/methods';
  static const String draw = '/decision/draw';
  static const String plus = '/plus';
  static const String foodLibrary = '/food-library';
  static const String history = '/history';
  static const String settings = '/settings';
  static const String aboutDeveloper = '/about-developer';
  static const String devSettings = '/dev/settings';

  /// Cached router instance to prevent recreation on rebuilds.
  static GoRouter? _router;

  /// Returns the cached GoRouter instance, creating it if needed.
  static GoRouter get router => _router ??= createRouter();

  /// Creates the GoRouter instance with all route definitions.
  static GoRouter createRouter({
    String initialLocation = splash,
    Object? initialExtra,
  }) {
    return GoRouter(
      initialLocation: initialLocation,
      initialExtra: initialExtra,
      errorBuilder: (context, state) => const _ErrorScreen(),
      routes: [
        // Splash Screen
        GoRoute(
          path: splash,
          name: 'splash',
          pageBuilder: (context, state) => _buildPageWithTransition(
            child: const SplashScreen(),
            state: state,
          ),
        ),

        // Home Screen
        GoRoute(
          path: onboarding,
          pageBuilder: (context, state) => _buildPageWithTransition(
            child: OnboardingScreen(
              replay: state.extra is OnboardingReplayRouteData,
            ),
            state: state,
          ),
        ),
        GoRoute(
          path: jury,
          pageBuilder: (context, state) =>
              _buildPageWithTransition(child: const JuryScreen(), state: state),
        ),
        GoRoute(
          path: home,
          name: 'home',
          pageBuilder: (context, state) =>
              _buildPageWithTransition(child: const HomeScreen(), state: state),
        ),

        // New Decision Flow
        GoRoute(
          path: newDecision,
          name: 'newDecision',
          pageBuilder: (context, state) => _buildPageWithTransition(
            child: NewDecisionScreen(
              key: ValueKey((state.pageKey, state.extra)),
              initialCase: state.extra is DecisionCase
                  ? state.extra as DecisionCase
                  : null,
              initialDraft: state.extra is CaseDraft
                  ? state.extra as CaseDraft
                  : null,
            ),
            state: state,
            transitionType: _TransitionType.slideUp,
          ),
        ),

        GoRoute(
          path: methods,
          pageBuilder: (context, state) => _buildPageWithTransition(
            child: state.extra is MethodRouteData
                ? MethodPickerScreen(
                    caseData: (state.extra as MethodRouteData).caseData,
                    returnToEditor:
                        (state.extra as MethodRouteData).returnToEditor,
                  )
                : state.extra is DecisionCase
                ? MethodPickerScreen(caseData: state.extra as DecisionCase)
                : const _ErrorScreen(),
            state: state,
          ),
        ),
        GoRoute(
          path: draw,
          pageBuilder: (context, state) => _buildPageWithTransition(
            child:
                state.extra is DrawRouteData &&
                    (state.extra as DrawRouteData).verdict.isRandom
                ? LuckyDrawScreen(data: state.extra as DrawRouteData)
                : const _ErrorScreen(),
            state: state,
          ),
        ),
        GoRoute(
          path: plus,
          pageBuilder: (context, state) => _buildPageWithTransition(
            child: PlusPreviewScreen(
              fromOnboarding: state.extra is OnboardingOfferRouteData,
            ),
            state: state,
          ),
        ),
        GoRoute(
          path: foodLibrary,
          pageBuilder: (context, state) => _buildPageWithTransition(
            child: const FoodLibraryScreen(),
            state: state,
          ),
        ),

        // Verdict Screen
        GoRoute(
          path: verdict,
          name: 'verdict',
          pageBuilder: (context, state) {
            final extra = state.extra;
            // Support both Verdict directly (new verdict) and VerdictRouteData (from history)
            final Verdict verdictData;
            final bool showAnimation;
            if (extra is VerdictRouteData) {
              verdictData = extra.verdict;
              showAnimation = extra.showRevealAnimation;
            } else if (extra is Verdict) {
              verdictData = extra;
              showAnimation = true;
            } else {
              return _buildPageWithTransition(
                child: const _ErrorScreen(),
                state: state,
              );
            }
            return _buildPageWithTransition(
              child: verdictData.isRandom
                  ? LuckyVerdictScreen(
                      verdict: verdictData,
                      animate: showAnimation,
                      saved: extra is VerdictRouteData && extra.saved,
                      previousWinnerId: extra is VerdictRouteData
                          ? extra.previousWinnerId
                          : null,
                    )
                  : VerdictScreen(
                      verdict: verdictData,
                      showRevealAnimation: showAnimation,
                    ),
              state: state,
              transitionType: _TransitionType.fade,
            );
          },
        ),

        // History Screen
        GoRoute(
          path: history,
          name: 'history',
          pageBuilder: (context, state) => _buildPageWithTransition(
            child: const HistoryScreen(),
            state: state,
            transitionType: _TransitionType.slideLeft,
          ),
        ),

        // Settings Screen
        GoRoute(
          path: settings,
          name: 'settings',
          pageBuilder: (context, state) => _buildPageWithTransition(
            child: const SettingsScreen(),
            state: state,
            transitionType: _TransitionType.slideLeft,
          ),
        ),

        // About Developer Screen
        GoRoute(
          path: aboutDeveloper,
          name: 'aboutDeveloper',
          pageBuilder: (context, state) => _buildPageWithTransition(
            child: const AboutDeveloperScreen(),
            state: state,
            transitionType: _TransitionType.slideLeft,
          ),
        ),

        // Dev Settings (only in dev mode)
        GoRoute(
          path: devSettings,
          name: 'devSettings',
          pageBuilder: (context, state) => _buildPageWithTransition(
            child: const DevSettingsScreen(),
            state: state,
            transitionType: _TransitionType.slideLeft,
          ),
        ),
      ],
    );
  }

  /// Helper method to build pages with custom transitions.
  static Page<dynamic> _buildPageWithTransition({
    required Widget child,
    required GoRouterState state,
    _TransitionType transitionType = _TransitionType.fade,
  }) {
    return CustomTransitionPage(
      key: state.pageKey,
      transitionDuration: DinerTokens.route,
      reverseTransitionDuration: DinerTokens.route,
      child: child,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        if (reduceDinerMotion(context)) return child;
        return _getTransition(
          animation: animation.drive(CurveTween(curve: DinerTokens.enterCurve)),
          child: child,
          type: transitionType,
        );
      },
    );
  }

  /// Returns the appropriate transition based on type.
  static Widget _getTransition({
    required Animation<double> animation,
    required Widget child,
    required _TransitionType type,
  }) {
    switch (type) {
      case _TransitionType.fade:
        return FadeTransition(opacity: animation, child: child);

      case _TransitionType.slideUp:
        const begin = Offset(0.0, .06);
        const end = Offset.zero;
        final tween = Tween(begin: begin, end: end);
        final offsetAnimation = animation.drive(tween);

        return SlideTransition(
          position: offsetAnimation,
          child: FadeTransition(opacity: animation, child: child),
        );

      case _TransitionType.slideLeft:
        const begin = Offset(.06, 0.0);
        const end = Offset.zero;
        final tween = Tween(begin: begin, end: end);
        final offsetAnimation = animation.drive(tween);

        return SlideTransition(
          position: offsetAnimation,
          child: FadeTransition(opacity: animation, child: child),
        );
    }
  }
}

/// Transition types for page animations.
enum _TransitionType { fade, slideUp, slideLeft }

/// Data class for passing verdict with animation flag to the verdict screen.
class VerdictRouteData {
  const VerdictRouteData({
    required this.verdict,
    this.showRevealAnimation = true,
    this.saved = false,
    this.previousWinnerId,
  });

  final Verdict verdict;
  final bool showRevealAnimation;
  final bool saved;

  /// Prior winner for a new draw, never for replaying saved history.
  final String? previousWinnerId;
}

/// Error screen displayed when navigation fails.
///
/// Shows confused Judge Bite and a button to go home.
class _ErrorScreen extends StatelessWidget {
  const _ErrorScreen();

  @override
  Widget build(BuildContext context) => DinerScaffold(
    showLogo: true,
    showBack: false,
    maxWidth: DinerTokens.readingWidth,
    child: Column(
      children: [
        const JudgeBite(
          pose: JudgeBitePose.confused,
          size: JudgeBiteSize.xlarge,
        ),
        const SizedBox(height: AppDimensions.spaceLg),
        DinerHeading(context.l10n.diner_routeError),
        const SizedBox(height: AppDimensions.spaceLg),
        DinerButton(
          label: context.l10n.diner_goHome,
          icon: Icons.home_rounded,
          onPressed: () => context.go(AppRouter.home),
        ),
      ],
    ),
  );
}
