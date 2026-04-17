import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../../data.dart';
import 'api_department_data.dart';

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

// @freezed
// class ApiLoginUserData with _$ApiLoginUserData {
//   const factory ApiLoginUserData({
//     @JsonKey(name: '_id') String? id,
//     @JsonKey(name: 'email') String? email,
//     @JsonKey(name: 'username') String? username,
//     @JsonKey(name: 'employeeCode') String? employeeCode,
//     @JsonKey(name: 'phoneNumber') String? phoneNumber,
//     @JsonKey(name: 'dateOfBirth') String? dateOfBirth,
//     @JsonKey(name: 'joinDate') String? joinDate,
//     @JsonKey(name: 'gender') String? gender,
//     @JsonKey(name: 'departmentId') String? departmentId,
//     @JsonKey(name: 'department') ApiDepartmentData? department,
//     @JsonKey(name: 'role') String? role,
//     @JsonKey(name: 'isManager') bool? isManager,
//     @JsonKey(name: 'managedDepartments')
//     List<ApiDepartmentData>? managedDepartments,
//   }) = _ApiLoginUserData;
//
//   factory ApiLoginUserData.fromJson(Map<String, dynamic> json) =>
//       _$ApiLoginUserDataFromJson(json);
// }
