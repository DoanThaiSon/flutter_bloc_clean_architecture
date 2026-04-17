import 'package:freezed_annotation/freezed_annotation.dart';

import 'api_department_data.dart';

part 'api_departments_response.freezed.dart';
part 'api_departments_response.g.dart';

@freezed
class ApiDepartmentsResponse with _$ApiDepartmentsResponse {
  const factory ApiDepartmentsResponse({
    @Default([]) List<ApiDepartmentData> data,
    @Default(0) int total,
    @Default(1) int page,
    @Default(20) int limit,
  }) = _ApiDepartmentsResponse;

  factory ApiDepartmentsResponse.fromJson(Map<String, dynamic> json) =>
      _$ApiDepartmentsResponseFromJson(json);
}
