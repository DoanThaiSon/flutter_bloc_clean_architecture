import 'package:freezed_annotation/freezed_annotation.dart';

import 'api_department_data.dart';

part 'api_create_department_response.freezed.dart';

part 'api_create_department_response.g.dart';

@freezed
class ApiCreateDepartmentResponse with _$ApiCreateDepartmentResponse {
  const factory ApiCreateDepartmentResponse({
    @JsonKey(name: 'status') String? status,
    @JsonKey(name: 'message') String? message,
    @JsonKey(name: 'data') ApiDepartmentData? data,
  }) = _ApiCreateDepartmentResponse;

  factory ApiCreateDepartmentResponse.fromJson(Map<String, dynamic> json) =>
      _$ApiCreateDepartmentResponseFromJson(json);
}
