import 'package:freezed_annotation/freezed_annotation.dart';

part 'api_department_data.freezed.dart';

part 'api_department_data.g.dart';

@freezed
class ApiDepartmentDetailResponseData with _$ApiDepartmentDetailResponseData{
  const factory ApiDepartmentDetailResponseData({
    @JsonKey(name: 'status') String? status,
    @JsonKey(name: 'message') String? message,
    @JsonKey(name: 'data') ApiDepartmentData? data,
  }) = _ApiDepartmentDetailResponseData;

  factory ApiDepartmentDetailResponseData.fromJson(Map<String, dynamic> json) =>
      _$ApiDepartmentDetailResponseDataFromJson(json);
}

@freezed
class ApiDepartmentData with _$ApiDepartmentData {
  const factory ApiDepartmentData({
    @JsonKey(name: '_id') String? id,
    @JsonKey(name: 'name') String? name,
    @JsonKey(name: 'code') String? code,
    @JsonKey(name: 'description') String? description,
    @JsonKey(name: 'managerId') String? managerId,
  }) = _ApiDepartmentData;

  factory ApiDepartmentData.fromJson(Map<String, dynamic> json) =>
      _$ApiDepartmentDataFromJson(json);
}
