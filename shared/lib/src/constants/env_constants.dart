import '../../shared.dart';

class EnvConstants {
  const EnvConstants._();

  static const flavorKey = 'FLAVOR';
  static const appNameKey = 'APP_NAME';
  static const baseUrlKey = 'BASE_URL';
  static const apiVersionKey = 'API_VERSION';

  static late Flavor flavor = Flavor.values
      .byName(const String.fromEnvironment(flavorKey, defaultValue: 'develop'));
  static late String baseUrl = const String.fromEnvironment(baseUrlKey);
  static late String appName =
  const String.fromEnvironment(appNameKey, defaultValue: '');
  static late String apiVersion = const String.fromEnvironment(apiVersionKey);

  /// Configure environment variables at runtime
  /// This allows SDK integration without requiring --dart-define flags
  static void configure({
    required String baseUrlValue,
    required String mapBoxUrlValue,
    required String apiVersionValue,
    required String accessTokenValue,
    String flavorValue = 'develop',
  }) {
    baseUrl = baseUrlValue.isNotEmpty ? baseUrlValue : baseUrl;
    apiVersion = apiVersionValue.isNotEmpty ? apiVersionValue : apiVersion;

    try {
      flavor = Flavor.values.byName(flavorValue);
    } catch (e) {
      Log.e('Invalid flavor: $flavorValue, using default: develop');
      flavor = Flavor.develop;
    }
  }

  static void init() {
    Log.d(flavor, name: flavorKey);
    Log.d(appName, name: appNameKey);
    Log.d(baseUrl, name: baseUrlKey);
    Log.d(apiVersion, name: apiVersionKey);
  }
}
