import 'package:shared_preferences/shared_preferences.dart';

/// Local first-run flag. Demonstrations never create cases or spend rulings.
class OnboardingStore {
  /// Preference version changes only when a new introduction is required.
  static const completionKey = 'welcome_completed_v1';

  /// Whether this installation has finished or skipped the introduction.
  static Future<bool> isComplete() async =>
      (await SharedPreferences.getInstance()).getBool(completionKey) ?? false;

  /// Persists completion before allowing navigation away from the introduction.
  static Future<void> complete() async {
    final saved = await (await SharedPreferences.getInstance()).setBool(
      completionKey,
      true,
    );
    if (!saved) throw StateError('Could not save welcome preference');
  }
}

/// The educational tour reopened deliberately from Settings.
class OnboardingReplayRouteData {
  const OnboardingReplayRouteData();
}

/// The existing offer screen is the last stage of first-run onboarding.
class OnboardingOfferRouteData {
  const OnboardingOfferRouteData();
}
