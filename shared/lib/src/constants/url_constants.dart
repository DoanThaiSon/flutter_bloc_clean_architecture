import '../../shared.dart';

class UrlConstants {
  const UrlConstants._();
  static const randomUserBaseUrl = 'https://randomuser.me/api/';
  static String get appApiBaseUrl {
    return EnvConstants.baseUrl + EnvConstants.apiVersion;
  }

  static String get baseUrl {
    return EnvConstants.baseUrl;
  }
}

