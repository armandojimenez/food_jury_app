import 'dart:io';

import 'package:flutter/material.dart';

import '../services/ai_service.dart';
import '../widgets/widgets.dart';
import 'l10n_extensions.dart';

/// Centralized error handling utilities.
///
/// Provides user-friendly error messages and logging.
class ErrorHandler {
  ErrorHandler._();

  /// Handles an error and shows appropriate feedback to the user.
  ///
  /// Returns true if the error was handled, false otherwise.
  static bool handle(
    BuildContext context,
    Object error, {
    VoidCallback? onRetry,
  }) {
    final message = _getErrorMessage(context, error);
    AppSnackbar.showError(context, message: message);
    debugPrint('Error handled: $error');
    return true;
  }

  /// Gets a user-friendly error message for the given error.
  static String _getErrorMessage(BuildContext context, Object error) {
    final l10n = context.l10n;

    // Network errors
    if (error is SocketException) {
      return l10n.error_networkError;
    }

    // AI service errors
    if (error is AiServiceException) {
      return l10n.error_aiServiceError;
    }

    // Timeout errors
    if (error.toString().contains('TimeoutException')) {
      return l10n.error_timeoutError;
    }

    // Default error message
    return l10n.error_genericMessage;
  }

  /// Checks if the device likely has network connectivity.
  ///
  /// This is a simple check; for production, consider using
  /// connectivity_plus package for more robust checking.
  static Future<bool> hasNetworkConnectivity() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } on SocketException catch (_) {
      return false;
    }
  }

  /// Shows a network error dialog with retry option.
  static Future<bool> showNetworkErrorDialog(
    BuildContext context, {
    required VoidCallback onRetry,
  }) async {
    return await AppDialog.showConfirmation(
      context,
      title: context.l10n.error_networkErrorTitle,
      message: context.l10n.error_networkError,
      confirmText: context.l10n.common_retry,
    );
  }
}
