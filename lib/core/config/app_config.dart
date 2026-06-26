class AppConfig {
  static const String apiBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://10.0.2.2:5000',
  );

  static const String environment = String.fromEnvironment(
    'ENV',
    defaultValue: 'dev',
  );

  static bool get isDebug => environment == 'dev';
  static bool get isProduction => environment == 'prod';

  static Duration get connectTimeout => const Duration(seconds: 30);
  static Duration get receiveTimeout => const Duration(seconds: 30);
  static Duration get sendTimeout => const Duration(seconds: 30);
}
