import 'package:flutter/widgets.dart';

import '../../l10n/app_localizations.dart';

/// Extension to easily access localized strings from BuildContext.
///
/// Example:
/// ```dart
/// Text(context.l10n.appTitle)
/// ```
extension LocalizationExtension on BuildContext {
  /// Returns the AppLocalizations instance for this context.
  ///
  /// Throws if localization has not been properly set up.
  AppLocalizations get l10n {
    return AppLocalizations.of(this)!;
  }
}
