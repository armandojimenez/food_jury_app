import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../env/env.dart';
import '../../app.dart';

Future<void> bootstrap(Environment environment) async {
  // Ensure Flutter bindings are initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Set environment
  Env.current = environment;

  // Configure error handling
  await _configureErrorHandling();

  // Set preferred orientations
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Set system UI overlay style
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.light,
    ),
  );

  // Initialize services
  await _initializeServices();

  // Log environment info
  _logEnvironmentInfo();

  // Run the app
  runApp(const FoodJuryApp());
}

Future<void> _configureErrorHandling() async {
  // Handle Flutter framework errors
  FlutterError.onError = (FlutterErrorDetails details) {
    if (Env.isDev) {
      FlutterError.dumpErrorToConsole(details);
    } else {
      // In production, send to crash reporting service
      Zone.current.handleUncaughtError(
        details.exception,
        details.stack ?? StackTrace.empty,
      );
    }
  };

  // Handle errors outside of Flutter framework
  PlatformDispatcher.instance.onError = (error, stack) {
    if (Env.isDev) {
      debugPrint('Uncaught error: $error');
      debugPrint('Stack trace: $stack');
    }
    // Return true to prevent the error from propagating
    return true;
  };
}

Future<void> _initializeServices() async {
  // TODO: Initialize Firebase
  // await Firebase.initializeApp(
  //   options: DefaultFirebaseOptions.currentPlatform,
  // );

  // TODO: Initialize local storage (Drift)
  // await LocalDatabase.initialize();

  // TODO: Initialize other services as needed
}

void _logEnvironmentInfo() {
  if (Env.enableLogging) {
    debugPrint('╔══════════════════════════════════════════════════════════╗');
    debugPrint('║                    FOOD JURY                             ║');
    debugPrint('╠══════════════════════════════════════════════════════════╣');
    debugPrint('║ Environment: ${Env.name.padRight(44)}║');
    debugPrint('║ App Name: ${Env.appName.padRight(47)}║');
    debugPrint('║ Logging: ${(Env.enableLogging ? 'Enabled' : 'Disabled').padRight(48)}║');
    debugPrint('║ Analytics: ${(Env.enableAnalytics ? 'Enabled' : 'Disabled').padRight(46)}║');
    debugPrint('╚══════════════════════════════════════════════════════════╝');
  }
}
