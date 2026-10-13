enum Environment { dev, prod }

class Env {
  static late Environment current;

  static bool get isDev => current == Environment.dev;
  static bool get isProd => current == Environment.prod;

  static String get name => current.name;

  // Feature Flags
  static bool get enableLogging => isDev;

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
