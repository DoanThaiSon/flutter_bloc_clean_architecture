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

  Future<void> logout({
    required String refreshToken,
  });

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

  Future<bool> saveIsDarkMode(bool isDarkMode);

  Future<bool> saveLanguageCode(LanguageCode languageCode);

  Future<void> saveAccessToken(String accessToken);

  Future<bool> saveUserPreference(User user);

  Future<User> getMe();

  Future<AttendanceResponse> getTodayAttendance();

  Future<AttendanceHistoryResponse> getAttendanceHistory({
    required String startDate,
    required String endDate,
  });

  Future<CheckoutResponse> checkout({
    required double latitude,
    required double longitude,
  });

  Future<CheckoutResponse> checkIn({
    required double latitude,
    required double longitude,
  });

  Future<LeaveRequestResponse> getLeaveRequests({
    required int page,
    required int limit,
  });

  Future<LeaveRequestResponse> getAllLeaveRequests(
      {required int page, required int limit, String? status});

  Future<LeaveCodeResponse> getLeaveCodes();

  Future<CreateLeaveRequestResponse> createLeaveRequest({
    required String dayType,
    required String shift,
    required String leaveCodeId,
    required String startDate,
    required String endDate,
    required String reason,
  });

  Future<void> approveLeaveRequest({
    required String leaveRequestId,
  });

  Future<void> rejectLeaveRequest({
    required String leaveRequestId,
    required String rejectionReason,
  });

  Future<void> deleteLeaveRequest({
    required String leaveRequestId,
  });

  Future<void> updateLeaveRequest({
    required String leaveRequestId,
    required String dayType,
    required String shift,
    required String leaveCodeId,
    required String startDate,
    required String endDate,
    required String reason,
  });

  Future<Department> createDepartment({
    required String name,
    required String code,
    String? description,
    String? managerId,
  });

  Future<List<Department>> getDepartments(
      {required int page, required int limit, String? query});
  Future<DepartmentDetailResponseData> getDepartmentDetail({
    required String departmentId,
  });

  Future<void> deleteDepartment({
    required String departmentId,
  });

  Future<List<User>> getUsers({
    required int page,
    required int limit,
  });
}
