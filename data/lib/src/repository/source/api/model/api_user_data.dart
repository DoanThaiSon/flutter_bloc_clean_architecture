import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../../data.dart';

part 'api_user_data.freezed.dart';

part 'api_user_data.g.dart';

@freezed
class ApiUserData with _$ApiUserData {
  const ApiUserData._();

  const factory ApiUserData({
    @JsonKey(name: '_id') String? id,
    @JsonKey(name: 'email') String? email,
    @JsonKey(name: 'birthday') String? birthday,
    @JsonKey(name: 'name') String? name,
    @JsonKey(name: 'avatar') ApiImageUrlData? avatar,
    @JsonKey(name: 'sex') String? gender,
    @JsonKey(name: 'employeeCode') String? employeeCode,
    @JsonKey(name: 'phoneNumber') String? phoneNumber,
    @JsonKey(name: 'role') String? role,
  }) = _ApiUserData;

  factory ApiUserData.fromJson(Map<String, dynamic> json) =>
      _$ApiUserDataFromJson(json);
}
