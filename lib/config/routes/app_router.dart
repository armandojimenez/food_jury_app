import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/decision/presentation/new_decision_screen.dart';
import '../../features/home/presentation/home_screen.dart';
import '../../features/settings/dev_settings_screen.dart';

/// App navigation routes using GoRouter.
///
/// Routes are defined with animations and proper nesting.
class AppRouter {
  /// Route path constants
  static const String home = '/';
  static const String newDecision = '/decision/new';
  static const String devSettings = '/dev/settings';

  /// Creates the GoRouter instance with all route definitions.
  static GoRouter createRouter() {
    return GoRouter(
      initialLocation: home,
      routes: [
        // Home Screen
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
            child: const NewDecisionScreen(),
            state: state,
            transitionType: _TransitionType.slideUp,
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
      child: child,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return _getTransition(
          animation: animation,
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
        const begin = Offset(0.0, 1.0);
        const end = Offset.zero;
        final tween = Tween(begin: begin, end: end);
        final offsetAnimation = animation.drive(tween);

        return SlideTransition(
          position: offsetAnimation,
          child: FadeTransition(opacity: animation, child: child),
        );

      case _TransitionType.slideLeft:
        const begin = Offset(1.0, 0.0);
        const end = Offset.zero;
        final tween = Tween(begin: begin, end: end);
        final offsetAnimation = animation.drive(tween);

        return SlideTransition(position: offsetAnimation, child: child);
    }
  }
}

/// Transition types for page animations.
enum _TransitionType { fade, slideUp, slideLeft }
