import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../services/ai_service.dart';
import '../services/gemini_ai_service.dart';
// ignore: unused_import
import '../services/mock_ai_service.dart'; // Available for offline dev

/// Provider for the AI service.
///
/// Uses Gemini AI for verdict generation.
/// To use mock service for offline development, change to MockAiService().
final aiServiceProvider = Provider<AiService>((ref) {
  return GeminiAiService();
});
