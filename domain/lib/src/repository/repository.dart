import '../../domain.dart';

abstract class Repository {
  bool get isLoggedIn;

  bool get isFirstLaunchApp;

  bool get isFirstLogin;

  bool get isDarkMode;

  LanguageCode get languageCode;

  Stream<bool> get onConnectivityChanged;

  Future<User> login({
    required String email,
    required String password,
  });

  Future<void> logout();

  Future<void> resetPassword({
    required String token,
    required String email,
    required String password,
    required String confirmPassword,
  });

  Future<void> forgotPassword(String email);

  User getUserPreference();

  Future<void> clearCurrentUserData();

  Future<bool> saveIsFirstLogin(bool isFirstLogin);

  Future<bool> saveIsFirstLaunchApp(bool isFirstLaunchApp);

  Future<PagedList<User>> getUsers({
    required int page,
    required int? limit,
  });

  Future<bool> saveIsDarkMode(bool isDarkMode);

  Future<bool> saveLanguageCode(LanguageCode languageCode);

  Future<void> saveAccessToken(String accessToken);

  Future<bool> saveUserPreference(User user);

  Future<User> getMe();

  Future<AttendanceResponse> getTodayAttendance();

  Future<CheckoutResponse> checkout({
    required double latitude,
    required double longitude,
  });

  Future<CheckoutResponse> checkIn({
    required double latitude,
    required double longitude,
  });
}
