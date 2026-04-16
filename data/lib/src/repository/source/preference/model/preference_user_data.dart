import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../../data.dart';
import '../../api/model/api_department_data.dart';

part 'preference_user_data.freezed.dart';
part 'preference_user_data.g.dart';

@freezed
class PreferenceUserData with _$PreferenceUserData {
  const factory PreferenceUserData({
    @JsonKey(name: 'id') required String id,
    @JsonKey(name: 'email') required String email,
    @JsonKey(name: 'name') @Default('') String name,
    @JsonKey(name: 'employeeCode') @Default('') String employeeCode,
    @JsonKey(name: 'phoneNumber') @Default('') String phoneNumber,
    @JsonKey(name: 'birthday') String? birthday,
    @JsonKey(name: 'joinDate') String? joinDate,
    @JsonKey(name: 'gender') @Default('') String gender,
    @JsonKey(name: 'departmentId') @Default('') String departmentId,
    @JsonKey(name: 'departmentName') @Default('') String departmentName,
    @JsonKey(name: 'departmentCode') @Default('') String departmentCode,
    @JsonKey(name: 'departmentDescription') @Default('') String departmentDescription,
    @JsonKey(name: 'role') @Default('user') String role,
    @JsonKey(name: 'isManager') bool? isManager,
    @JsonKey(name: 'managedDepartments') List<ApiDepartmentData>? managedDepartments,
  }) = _PreferenceUserData;

  const PreferenceUserData._();

  factory PreferenceUserData.fromJson(Map<String, dynamic> json) =>
      _$PreferenceUserDataFromJson(json);
}
