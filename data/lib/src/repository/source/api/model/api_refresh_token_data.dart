import 'package:freezed_annotation/freezed_annotation.dart';

part 'api_refresh_token_data.freezed.dart';
part 'api_refresh_token_data.g.dart';

@freezed
class ApiAuthResponseData with _$ApiAuthResponseData {
  const factory ApiAuthResponseData({
    @JsonKey(name: 'data') TokenAuthResponseData? data,
  }) = _ApiAuthResponseData;

  factory ApiAuthResponseData.fromJson(Map<String, dynamic> json) =>
      _$ApiAuthResponseDataFromJson(json);
}

@freezed
class TokenAuthResponseData with _$TokenAuthResponseData {
  const factory TokenAuthResponseData({
    @JsonKey(name: 'accessToken') String? accessToken,
    @JsonKey(name: 'refreshToken') String? refreshToken,
  }) = _TokenAuthResponseData;

  factory TokenAuthResponseData.fromJson(Map<String, dynamic> json) =>
      _$TokenAuthResponseDataFromJson(json);
}
