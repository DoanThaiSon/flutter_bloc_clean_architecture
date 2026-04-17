import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../../data.dart';

part 'api_user_data.freezed.dart';

part 'api_user_data.g.dart';

@freezed
class ApiUserData with _$ApiUserData {
  const ApiUserData._();

  const factory ApiUserData({
    @JsonKey(name: '_id') @Default('') String id,
    @JsonKey(name: 'email') @Default('') String email,
    @JsonKey(name: 'username') @Default('') String username,
    @JsonKey(name: 'employeeCode') @Default('') String employeeCode,
    @JsonKey(name: 'phoneNumber') @Default('') String phoneNumber,
    @JsonKey(name: 'dateOfBirth') String? birthday,
    @JsonKey(name: 'joinDate') String? joinDate,
    @JsonKey(name: 'gender') @Default('') String gender,
    @JsonKey(name: 'departmentId') @Default('') String departmentId,
    @JsonKey(name: 'departmentName') @Default('') String departmentName,
    @JsonKey(name: 'departmentCode') @Default('') String departmentCode,
    @JsonKey(name: 'departmentDescription') @Default('') String departmentDescription,
    @JsonKey(name: 'department') ApiDepartmentData? department,
    @JsonKey(name: 'role') @Default('user') String role,
    @JsonKey(name: 'isManager') bool? isManager,
    @JsonKey(name: 'managedDepartments') List<ApiDepartmentData>? managedDepartments,
  }) = _ApiUserData;

  factory ApiUserData.fromJson(Map<String, dynamic> json) =>
      _$ApiUserDataFromJson(json);
}
