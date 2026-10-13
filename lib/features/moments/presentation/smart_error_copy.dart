import 'dart:async';
import 'dart:io';

import '../../../core/services/ai_service.dart';
import '../../../core/services/ai_gateway_service.dart';
import '../../../core/services/smart_allowance_service.dart';
import '../../../l10n/app_localizations.dart';

/// Keep the useful underlying failure when an AI adapter wraps it.
String smartRulingError(AppLocalizations l, Object error) {
  if (error is AiGatewayException) {
    return switch (error.code) {
      AiGatewayError.rateLimit => l.moments_gatewayBusy,
      AiGatewayError.contentFilter ||
      AiGatewayError.invalidInput => l.moments_gatewayCaseReview,
      AiGatewayError.payloadTooLarge => l.moments_gatewayTooLarge,
      AiGatewayError.configuration ||
      AiGatewayError.unauthorized => l.moments_gatewayUnavailable,
      AiGatewayError.network => l.moments_offline,
      AiGatewayError.timeout => l.moments_timeout,
      _ => l.lucky_aiError,
    };
  }
  final cause = error is AiServiceException ? error.cause : null;
  if (cause != null && !identical(cause, error)) {
    return smartRulingError(l, cause);
  }
  if (error is SocketException) return l.moments_offline;
  if (error is TimeoutException) return l.moments_timeout;
  if (error is SmartAllowanceUnavailable) return l.moments_allowanceUnavailable;
  return l.lucky_aiError;
}
