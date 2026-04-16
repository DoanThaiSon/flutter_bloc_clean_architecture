import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../../data.dart';

part 'api_managers_response.freezed.dart';
part 'api_managers_response.g.dart';

@freezed
class ApiManagersResponse with _$ApiManagersResponse {
  const factory ApiManagersResponse({
    String? status,
    String? message,
    List<ApiUserData>? data,
  }) = _ApiManagersResponse;

  factory ApiManagersResponse.fromJson(Map<String, dynamic> json) =>
      _$ApiManagersResponseFromJson(json);
}
