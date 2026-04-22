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
    this._apiUserDataMapper,
    this._attendanceResponseDataMapper,
    this._attendanceHistoryResponseDataMapper,
    this._checkoutResponseDataMapper,
    this._leaveRequestResponseDataMapper,
    this._leaveCodeResponseDataMapper,
    this._createLeaveRequestResponseDataMapper,
    this._departmentDataMapper,
    this._departmentsResponseMapper,
  );

  final AppApiService _appApiService;
  final AppPreferences _appPreferences;

  final ApiUserDataMapper _preferenceUserDataMapper;
  final ApiUserDataMapper _userDataMapper;
  final LanguageCodeDataMapper _languageCodeDataMapper;
  final GenderDataMapper _genderDataMapper;
  final ApiUserDataMapper _apiUserDataMapper;
  final ApiAttendanceResponseDataMapper _attendanceResponseDataMapper;
  final ApiAttendanceHistoryResponseDataMapper
      _attendanceHistoryResponseDataMapper;
  final ApiCheckoutResponseDataMapper _checkoutResponseDataMapper;
  final ApiLeaveRequestResponseDataMapper _leaveRequestResponseDataMapper;
  final ApiLeaveCodeResponseDataMapper _leaveCodeResponseDataMapper;
  final ApiCreateLeaveRequestResponseDataMapper
      _createLeaveRequestResponseDataMapper;
  final ApiDepartmentDataMapper _departmentDataMapper;
  final ApiDepartmentsResponseMapper _departmentsResponseMapper;

  @override
  bool get isLoggedIn => _appPreferences.isLoggedIn;

  @override
  bool get isFirstLogin => _appPreferences.isFirstLogin;

  @override
  bool get isFirstLaunchApp => _appPreferences.isFirstLaunchApp;

  @override
  Stream<bool> get onConnectivityChanged => Connectivity()
      .onConnectivityChanged
      .map((event) => event != ConnectivityResult.none);

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
  Future<User> login({
    required String email,
    required String password,
  }) async {
    final response =
        await _appApiService.login(email: email, password: password);
    final user = _apiUserDataMapper.mapToEntity(response?.data?.user);

    await Future.wait([
      if (response?.data?.accessToken != null)
        _appPreferences.saveAccessToken(response!.data!.accessToken!),
      if (response?.data?.refreshToken != null)
        _appPreferences.saveRefreshToken(response!.data!.refreshToken!),
      saveUserPreference(user),
    ]);

    return user;
  }

  @override
  Future<void> logout({
    required String refreshToken,
  }) async {
    await _appApiService.logout(refreshToken: refreshToken);
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
  Future<void> forgotPassword(String email) =>
      _appApiService.forgotPassword(email);

  @override
  User getUserPreference() =>
      _preferenceUserDataMapper.mapToEntity(_appPreferences.currentUser);

  @override
  Future<void> clearCurrentUserData() => _appPreferences.clearCurrentUserData();

  @override
  Future<bool> saveLanguageCode(LanguageCode languageCode) {
    return _appPreferences
        .saveLanguageCode(_languageCodeDataMapper.mapToData(languageCode));
  }

  @override
  Future<bool> saveIsDarkMode(bool isDarkMode) =>
      _appPreferences.saveIsDarkMode(isDarkMode);

  @override
  Future<User> getMe() async {
    final response = await _appApiService.getMe();

    return _userDataMapper.mapToEntity(response);
  }

  @override
  Future<AttendanceResponse> getTodayAttendance() async {
    final response = await _appApiService.getTodayAttendance();
    return _attendanceResponseDataMapper.mapToEntity(response);
  }

  @override
  Future<AttendanceHistoryResponse> getAttendanceHistory({
    required String startDate,
    required String endDate,
  }) async {
    final response = await _appApiService.getAttendanceHistory(
      startDate: startDate,
      endDate: endDate,
    );
    return _attendanceHistoryResponseDataMapper.mapToEntity(response);
  }

  @override
  Future<CheckoutResponse> checkout({
    required double latitude,
    required double longitude,
  }) async {
    final response = await _appApiService.checkout(
      latitude: latitude,
      longitude: longitude,
    );
    return _checkoutResponseDataMapper.mapToEntity(response);
  }

  @override
  Future<CheckoutResponse> checkIn({
    required double latitude,
    required double longitude,
  }) async {
    final response = await _appApiService.checkIn(
      latitude: latitude,
      longitude: longitude,
    );
    return _checkoutResponseDataMapper.mapToEntity(response);
  }

  @override
  Future<LeaveRequestResponse> getLeaveRequests({
    required int page,
    required int limit,
  }) async {
    final response = await _appApiService.getLeaveRequests(
      page: page,
      limit: limit,
    );
    return _leaveRequestResponseDataMapper.mapToEntity(response);
  }

  @override
  Future<LeaveRequestResponse> getAllLeaveRequests(
      {required int page, required int limit, String? status}) async {
    final response = await _appApiService.getAllLeaveRequests(
        page: page, limit: limit, status: status);
    return _leaveRequestResponseDataMapper.mapToEntity(response);
  }

  @override
  Future<LeaveCodeResponse> getLeaveCodes() async {
    final response = await _appApiService.getLeaveCodes();
    return _leaveCodeResponseDataMapper.mapToEntity(response);
  }

  @override
  Future<CreateLeaveRequestResponse> createLeaveRequest({
    required String dayType,
    required String shift,
    required String leaveCodeId,
    required String startDate,
    required String endDate,
    required String reason,
  }) async {
    final response = await _appApiService.createLeaveRequest(
      dayType: dayType,
      shift: shift,
      leaveCodeId: leaveCodeId,
      startDate: startDate,
      endDate: endDate,
      reason: reason,
    );
    return _createLeaveRequestResponseDataMapper.mapToEntity(response);
  }

  @override
  Future<void> approveLeaveRequest({
    required String leaveRequestId,
  }) async {
    await _appApiService.approveLeaveRequest(leaveRequestId);
  }

  @override
  Future<void> rejectLeaveRequest({
    required String leaveRequestId,
    required String rejectionReason,
  }) async {
    await _appApiService.rejectLeaveRequest(leaveRequestId, rejectionReason);
  }

  @override
  Future<void> deleteLeaveRequest({
    required String leaveRequestId,
  }) async {
    await _appApiService.deleteLeaveRequest(leaveRequestId);
  }

  @override
  Future<void> updateLeaveRequest({
    required String leaveRequestId,
    required String dayType,
    required String shift,
    required String leaveCodeId,
    required String startDate,
    required String endDate,
    required String reason,
  }) async {
    await _appApiService.updateLeaveRequest(
      leaveRequestsId: leaveRequestId,
      dayType: dayType,
      shift: shift,
      leaveCodeId: leaveCodeId,
      startDate: startDate,
      endDate: endDate,
      reason: reason,
    );
  }

  @override
  Future<void> saveAccessToken(String accessToken) =>
      _appPreferences.saveAccessToken(accessToken);

  @override
  Future<bool> saveUserPreference(User user) => _appPreferences
      .saveCurrentUser(_preferenceUserDataMapper.mapToData(user));

  @override
  Future<Department> createDepartment({
    required String name,
    required String code,
    String? description,
    String? managerId,
  }) async {
    final response = await _appApiService.createDepartment(
      name: name,
      code: code,
      description: description,
      managerId: managerId,
    );
    return _departmentDataMapper.mapToEntity(response?.data);
  }

  @override
  Future<Department> updateDepartment({
    required String departmentId,
    required String name,
    required String code,
    String? description,
    String? managerId,
  }) async {
    final response = await _appApiService.updateDepartment(
      departmentId: departmentId,
      name: name,
      code: code,
      description: description,
      managerId: managerId,
    );
    return _departmentDataMapper.mapToEntity(response?.data);
  }

  @override
  Future<List<Department>> getDepartments(
      {required int page, required int limit, String? query}) async {
    final response = await _appApiService.getDepartments(
        page: page, limit: limit, query: query);
    return _departmentsResponseMapper.mapToEntity(response);
  }

  @override
  Future<List<User>> getUsers({required int page, required int limit}) async {
    final response = await _appApiService.getUsers(page: page, limit: limit);
    return _userDataMapper.mapToListEntity(response?.data);
  }

  @override
  Future<void> deleteDepartment({
    required String departmentId,
  }) async {
    await _appApiService.deleteDepartment(departmentId);
  }

  @override
  Future<Department> getDepartmentDetail(
      {required String departmentId}) async {
    final response =
        await _appApiService.getDepartmentDetail(departmentId: departmentId);
    return _departmentDataMapper.mapToEntity(response?.data);
  }
}
