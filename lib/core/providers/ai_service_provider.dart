import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../env/env.dart';
import '../services/ai_gateway_service.dart';
import '../services/ai_service.dart';
import '../services/mock_ai_service.dart';
import '../services/smart_allowance_service.dart';
import 'ai_consent_provider.dart';
import 'mock_ai_provider.dart';

/// Provider for the AI service.
///
/// Switches between the shared AI gateway and the developer's mock service.
/// In production, always uses the real AI service.
final aiServiceProvider = Provider<AiService>((ref) {
  final useMockAi = ref.watch(mockAiNotifierProvider);

  if (useMockAi) {
    return MockAiService();
  }
  final service = AiGatewayService(
    baseUrl: const String.fromEnvironment(
      'AI_GATEWAY_URL',
      defaultValue: 'https://ai-gateway.armando-rsx.workers.dev',
    ),
    token: const String.fromEnvironment('AI_GATEWAY_TOKEN'),
    environment: Env.name,
    deviceId: () => ref.read(smartAllowanceServiceProvider).deviceId,
    acceptedConsentVersion: () =>
        ref.read(aiConsentProvider.notifier).acceptedVersion(),
  );
  ref.onDispose(service.close);
  return service;
});
