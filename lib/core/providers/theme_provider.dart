import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'theme_provider.g.dart';

/// Key for storing theme preference in SharedPreferences.
const _themePreferenceKey = 'theme_mode';

/// Provider for managing app theme mode (light, dark, system).
///
/// Persists user preference using SharedPreferences.
@riverpod
class ThemeNotifier extends _$ThemeNotifier {
  @override
  ThemeMode build() {
    _loadSavedTheme();
    return ThemeMode.system;
  }

  /// Loads saved theme preference from SharedPreferences.
  Future<void> _loadSavedTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final themeName = prefs.getString(_themePreferenceKey);
    if (themeName != null) {
      final mode = ThemeMode.values.firstWhere(
        (mode) => mode.name == themeName,
        orElse: () => ThemeMode.system,
      );
      state = mode;
    }
  }

  /// Sets the theme mode and persists it to SharedPreferences.
  Future<void> setThemeMode(ThemeMode mode) async {
    state = mode;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_themePreferenceKey, mode.name);
  }
}
