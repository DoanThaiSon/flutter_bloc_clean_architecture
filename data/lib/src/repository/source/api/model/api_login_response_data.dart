import 'package:freezed_annotation/freezed_annotation.dart';

part 'api_login_response_data.freezed.dart';
part 'api_login_response_data.g.dart';

@freezed
class ApiLoginResponseData with _$ApiLoginResponseData {
  const factory ApiLoginResponseData({
    @JsonKey(name: 'user') ApiLoginUserData? user,
    @JsonKey(name: 'accessToken') String? accessToken,
    @JsonKey(name: 'refreshToken') String? refreshToken,
  }) = _ApiLoginResponseData;

  factory ApiLoginResponseData.fromJson(Map<String, dynamic> json) =>
      _$ApiLoginResponseDataFromJson(json);
}

@freezed
class ApiLoginUserData with _$ApiLoginUserData {
  const factory ApiLoginUserData({
    @JsonKey(name: '_id') String? id,
    @JsonKey(name: 'email') String? email,
    @JsonKey(name: 'username') String? username,
    @JsonKey(name: 'role') String? role,
    @JsonKey(name: 'createdAt') int? createdAt,
  }) = _ApiLoginUserData;

  factory ApiLoginUserData.fromJson(Map<String, dynamic> json) =>
      _$ApiLoginUserDataFromJson(json);
}
