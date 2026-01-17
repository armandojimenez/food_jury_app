import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'config/routes/app_router.dart';
import 'core/env/env.dart';
import 'core/theme/theme.dart';
import 'l10n/app_localizations.dart';

/// Main FoodJury application widget.
///
/// Configured with:
/// - GoRouter for navigation
/// - Localization (English & Spanish)
/// - Retro diner courtroom theme
class FoodJuryApp extends StatelessWidget {
  const FoodJuryApp({super.key});

  @override
  Widget build(BuildContext context) {
    final router = AppRouter.createRouter();

    return MaterialApp.router(
      title: Env.appName,
      debugShowCheckedModeBanner: Env.isDev,
      theme: AppTheme.light,

      // Localization
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en', ''), // English
        Locale('es', ''), // Spanish
      ],
      localeResolutionCallback: (locale, supportedLocales) {
        // Check if the current device locale is supported
        if (locale != null) {
          for (var supportedLocale in supportedLocales) {
            if (supportedLocale.languageCode == locale.languageCode) {
              return supportedLocale;
            }
          }
        }
        // Default to English if locale not supported
        return supportedLocales.first;
      },

      // Routing
      routerConfig: router,
    );
  }
}
