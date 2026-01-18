import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../services/ai_service.dart';
import '../services/gemini_ai_service.dart';
import '../services/mock_ai_service.dart';
import 'mock_ai_provider.dart';

/// Provider for the AI service.
///
/// Switches between real Gemini AI and mock service based on user preference.
/// In production, always uses the real AI service.
final aiServiceProvider = Provider<AiService>((ref) {
  final useMockAi = ref.watch(mockAiNotifierProvider);

  if (useMockAi) {
    return MockAiService();
  }
  return GeminiAiService();
});
