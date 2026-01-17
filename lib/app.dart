import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'config/routes/app_router.dart';
import 'core/env/env.dart';
import 'core/providers/theme_provider.dart';
import 'core/theme/theme.dart';
import 'l10n/app_localizations.dart';

/// Main FoodJury application widget.
///
/// Configured with:
/// - GoRouter for navigation
/// - Localization (English & Spanish)
/// - Retro diner courtroom theme with dark mode support
class FoodJuryApp extends ConsumerWidget {
  const FoodJuryApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeNotifierProvider);

    return MaterialApp.router(
      title: Env.appName,
      debugShowCheckedModeBanner: Env.isDev,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: themeMode,

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

      // Routing - use cached router to prevent recreation on theme changes
      routerConfig: AppRouter.router,
    );
  }
}
