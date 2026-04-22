import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../../data.dart';

part 'api_department_data.freezed.dart';

part 'api_department_data.g.dart';

@freezed
class ApiDepartmentData with _$ApiDepartmentData {
  const factory ApiDepartmentData({
    @JsonKey(name: '_id') String? id,
    @JsonKey(name: 'name') String? name,
    @JsonKey(name: 'code') String? code,
    @JsonKey(name: 'description') String? description,
    @JsonKey(name: 'managerId') String? managerId,
    @JsonKey(name: 'manager') ApiUserData? manager,
  }) = _ApiDepartmentData;

  factory ApiDepartmentData.fromJson(Map<String, dynamic> json) =>
      _$ApiDepartmentDataFromJson(json);
}
