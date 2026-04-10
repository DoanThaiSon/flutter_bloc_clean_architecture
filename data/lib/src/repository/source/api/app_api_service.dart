import 'package:injectable/injectable.dart';

import '../../../../data.dart';

@LazySingleton()
class AppApiService {
  AppApiService(
    this._noneAuthAppServerApiClient,
    this._authAppServerApiClient,
    this._randomUserApiClient,
  );

  final NoneAuthAppServerApiClient _noneAuthAppServerApiClient;
  final AuthAppServerApiClient _authAppServerApiClient;
  final RandomUserApiClient _randomUserApiClient;

  Future<DataResponse<ApiLoginResponseData>?> login({
    required String email,
    required String password,
  }) async {
    return _noneAuthAppServerApiClient.request(
      method: RestMethod.post,
      path: '/auth/login',
      body: {
        'email': email,
        'password': password,
      },
      decoder: (json) =>
          ApiLoginResponseData.fromJson(json as Map<String, dynamic>),
    );
  }

  Future<void> logout() async {
    await _authAppServerApiClient.request(
      method: RestMethod.post,
      path: '/v1/auth/logout',
    );
  }

  Future<DataResponse<ApiAuthResponseData>?> register({
    required String username,
    required String email,
    required String password,
    required int gender,
  }) async {
    return _noneAuthAppServerApiClient.request(
      method: RestMethod.post,
      path: '/v1/auth/register',
      body: {
        'username': username,
        'gender': gender,
        'email': email,
        'password': password,
        'password_confirmation': password,
      },
      decoder: (json) =>
          ApiAuthResponseData.fromJson(json as Map<String, dynamic>),
    );
  }

  Future<void> forgotPassword(String email) async {
    await _noneAuthAppServerApiClient.request(
      method: RestMethod.post,
      path: '/v1/auth/forgot-password',
      body: {
        'email': email,
      },
    );
  }

  Future<void> resetPassword({
    required String token,
    required String email,
    required String password,
  }) async {
    await _noneAuthAppServerApiClient.request(
      method: RestMethod.post,
      path: '/v1/auth/reset-password',
      body: {
        'token': token,
        'email': email,
        'password': password,
        'password_confirmation': password,
      },
    );
  }

  Future<ApiUserData?> getMe() async {
    return _authAppServerApiClient.request(
      method: RestMethod.get,
      path: '/v1/me',
      successResponseMapperType: SuccessResponseMapperType.jsonObject,
      decoder: (json) => ApiUserData.fromJson(json as Map<String, dynamic>),
    );
  }

  Future<ApiAttendanceDataResponse?> getTodayAttendance() async {
    return _authAppServerApiClient.request(
      method: RestMethod.get,
      path: '/attendances/today',
      successResponseMapperType: SuccessResponseMapperType.jsonObject,
      decoder: (json) =>
          ApiAttendanceDataResponse.fromJson(json as Map<String, dynamic>),
    );
  }

  Future<ApiCheckoutResponseData?> checkout({
    required double latitude,
    required double longitude,
  }) async {
    return _authAppServerApiClient.request(
      method: RestMethod.post,
      path: '/attendances/check-out',
      body: {
        'location': {'latitude': latitude, 'longitude': longitude}
      },
      successResponseMapperType: SuccessResponseMapperType.jsonObject,
      decoder: (json) =>
          ApiCheckoutResponseData.fromJson(json as Map<String, dynamic>),
    );
  }
  Future<ApiCheckoutResponseData?> checkIn({
    required double latitude,
    required double longitude,
  }) async {
    return _authAppServerApiClient.request(
      method: RestMethod.post,
      path: '/attendances/check-in',
      body: {
        'location': {'latitude': latitude, 'longitude': longitude}
      },
      successResponseMapperType: SuccessResponseMapperType.jsonObject,
      decoder: (json) =>
          ApiCheckoutResponseData.fromJson(json as Map<String, dynamic>),
    );
  }

  Future<ResultsListResponse<ApiUserData>?> getUsers({
    required int page,
    required int? limit,
  }) {
    return _randomUserApiClient.request(
      method: RestMethod.get,
      path: '',
      queryParameters: {
        'page': page,
        'results': limit,
      },
      successResponseMapperType: SuccessResponseMapperType.resultsJsonArray,
      decoder: (json) => ApiUserData.fromJson(json as Map<String, dynamic>),
    );
  }
}
