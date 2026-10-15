/// Application-level configuration.
///
/// Keeps environment-specific values (API base URL, etc.) in one place
/// so they are never hardcoded throughout the UI or data layers.
class AppConfig {
  AppConfig._();

  /// Base URL for the mock JSON Server API.
  ///
  /// - Android Emulator: http://10.0.2.2:3001
  /// - iOS Simulator / desktop: http://localhost:3001
  /// - Physical device: http://<your-local-ip>:3001
  ///
  /// Change this single value (or use --dart-define) when switching platforms.
  static const String apiBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://10.0.2.2:3001',
  );

  static const String customersEndpoint = '/customers';

  static String get customersUrl => '$apiBaseUrl$customersEndpoint';
}
