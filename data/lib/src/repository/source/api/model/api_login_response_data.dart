import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../../data.dart';


part 'api_login_response_data.freezed.dart';

part 'api_login_response_data.g.dart';

@freezed
class ApiLoginResponseData with _$ApiLoginResponseData {
  const factory ApiLoginResponseData({
    @JsonKey(name: 'user') ApiUserData? user,
    @JsonKey(name: 'accessToken') String? accessToken,
    @JsonKey(name: 'refreshToken') String? refreshToken,
  }) = _ApiLoginResponseData;

  factory ApiLoginResponseData.fromJson(Map<String, dynamic> json) =>
      _$ApiLoginResponseDataFromJson(json);
}
