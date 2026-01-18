import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../env/env.dart';

part 'mock_ai_provider.g.dart';

/// Key for storing mock AI preference.
const _mockAiKey = 'use_mock_ai';

/// Provider for the mock AI preference state.
///
/// Only accessible in dev mode. Always returns false in production.
@riverpod
class MockAiNotifier extends _$MockAiNotifier {
  @override
  bool build() {
    // In production, always use real AI
    if (Env.isProd) return false;

    // Load saved preference
    _loadPreference();
    return false; // Default to real AI
  }

  Future<void> _loadPreference() async {
    final prefs = await SharedPreferences.getInstance();
    final useMock = prefs.getBool(_mockAiKey) ?? false;
    state = useMock;
  }

  /// Toggle between mock and real AI service.
  Future<void> toggle() async {
    if (Env.isProd) return; // No-op in production

    final prefs = await SharedPreferences.getInstance();
    final newValue = !state;
    await prefs.setBool(_mockAiKey, newValue);
    state = newValue;
  }

  /// Set mock AI preference explicitly.
  Future<void> setUseMockAi(bool useMock) async {
    if (Env.isProd) return; // No-op in production

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_mockAiKey, useMock);
    state = useMock;
  }
}
