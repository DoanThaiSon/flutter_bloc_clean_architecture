import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:domain/domain.dart';
import 'package:injectable/injectable.dart';

import '../../data.dart';

@LazySingleton(as: Repository)
class RepositoryImpl implements Repository {
  RepositoryImpl(
    this._appApiService,
    this._appPreferences,
    this._preferenceUserDataMapper,
    this._userDataMapper,
    this._languageCodeDataMapper,
    this._genderDataMapper,
  );

  final AppApiService _appApiService;
  final AppPreferences _appPreferences;

  final PreferenceUserDataMapper _preferenceUserDataMapper;
  final ApiUserDataMapper _userDataMapper;
  final LanguageCodeDataMapper _languageCodeDataMapper;
  final GenderDataMapper _genderDataMapper;


  @override
  bool get isLoggedIn => _appPreferences.isLoggedIn;

  @override
  bool get isFirstLogin => _appPreferences.isFirstLogin;

  @override
  bool get isFirstLaunchApp => _appPreferences.isFirstLaunchApp;

  @override
  Stream<bool> get onConnectivityChanged =>
      Connectivity().onConnectivityChanged.map((event) => event != ConnectivityResult.none);

  @override
  bool get isDarkMode => _appPreferences.isDarkMode;

  @override
  LanguageCode get languageCode =>
      _languageCodeDataMapper.mapToEntity(_appPreferences.languageCode);

  @override
  Future<bool> saveIsFirstLogin(bool isFirstLogin) {
    return _appPreferences.saveIsFirstLogin(isFirstLogin);
  }

  @override
  Future<bool> saveIsFirstLaunchApp(bool isFirstLaunchApp) {
    return _appPreferences.saveIsFirsLaunchApp(isFirstLaunchApp);
  }

  @override
  Future<void> login({
    required String email,
    required String password,
  }) async {
    final response = await _appApiService.login(email: email, password: password);
    await Future.wait([
      saveAccessToken(response?.data?.accessToken ?? ''),
      saveUserPreference(
        User(
          id: response?.data?.id ?? -1,
          email: response?.data?.email ?? '',
        ),
      ),
    ]);
  }

  @override
  Future<void> logout() async {
    await _appApiService.logout();
    await _appPreferences.clearCurrentUserData();
  }

  @override
  Future<void> resetPassword({
    required String token,
    required String email,
    required String password,
    required String confirmPassword,
  }) =>
      _appApiService.resetPassword(
        token: token,
        email: email,
        password: password,
      );

  @override
  Future<void> forgotPassword(String email) => _appApiService.forgotPassword(email);

  @override
  Future<void> register({
    required String username,
    required String email,
    required String password,
    required Gender gender,
  }) async {
    final response = await _appApiService.register(
      username: username,
      email: email,
      password: password,
      gender: _genderDataMapper.mapToData(gender),
    );
    await Future.wait([
      saveAccessToken(response?.data?.accessToken ?? ''),
      saveUserPreference(
        User(
          id: response?.data?.id ?? -1,
          email: response?.data?.email ?? '',
        ),
      ),
    ]);
  }

  @override
  User getUserPreference() => _preferenceUserDataMapper.mapToEntity(_appPreferences.currentUser);

  @override
  Future<void> clearCurrentUserData() => _appPreferences.clearCurrentUserData();

  @override
  Future<PagedList<User>> getUsers({
    required int page,
    required int? limit,
  }) async {
    final response = await _appApiService.getUsers(page: page, limit: limit);

    return PagedList(data: _userDataMapper.mapToListEntity(response?.results));
  }

  @override
  Future<bool> saveLanguageCode(LanguageCode languageCode) {
    return _appPreferences.saveLanguageCode(_languageCodeDataMapper.mapToData(languageCode));
  }

  @override
  Future<bool> saveIsDarkMode(bool isDarkMode) => _appPreferences.saveIsDarkMode(isDarkMode);

  @override
  Future<User> getMe() async {
    final response = await _appApiService.getMe();

    return _userDataMapper.mapToEntity(response);
  }

  @override
  Future<void> saveAccessToken(String accessToken) => _appPreferences.saveAccessToken(accessToken);

  @override
  Future<bool> saveUserPreference(User user) =>
      _appPreferences.saveCurrentUser(_preferenceUserDataMapper.mapToData(user));
}
