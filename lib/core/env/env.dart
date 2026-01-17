enum Environment {
  dev,
  prod,
}

class Env {
  static late Environment current;

  static bool get isDev => current == Environment.dev;
  static bool get isProd => current == Environment.prod;

  static String get name => current.name;

  // API Configuration
  static String get apiBaseUrl {
    switch (current) {
      case Environment.dev:
        return 'https://dev-api.foodjury.app';
      case Environment.prod:
        return 'https://api.foodjury.app';
    }
  }

  // Firebase Configuration
  static String get firebaseProjectId {
    switch (current) {
      case Environment.dev:
        return 'food-jury-dev';
      case Environment.prod:
        return 'food-jury-prod';
    }
  }

  // Feature Flags
  static bool get enableLogging => isDev;
  static bool get enableCrashlytics => isProd;
  static bool get enableAnalytics => isProd;

  // App Info
  static String get appName {
    switch (current) {
      case Environment.dev:
        return 'FoodJury Dev';
      case Environment.prod:
        return 'FoodJury';
    }
  }
}
