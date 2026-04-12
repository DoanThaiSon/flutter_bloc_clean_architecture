import 'package:freezed_annotation/freezed_annotation.dart';

part 'api_leave_code_data.freezed.dart';
part 'api_leave_code_data.g.dart';

@freezed
class ApiLeaveCodeResponse with _$ApiLeaveCodeResponse {
  const factory ApiLeaveCodeResponse({
    @JsonKey(name: 'status') String? status,
    @JsonKey(name: 'message') String? message,
    @JsonKey(name: 'data') List<ApiLeaveCodeData>? data,
  }) = _ApiLeaveCodeResponse;

  factory ApiLeaveCodeResponse.fromJson(Map<String, dynamic> json) =>
      _$ApiLeaveCodeResponseFromJson(json);
}

@freezed
class ApiLeaveCodeData with _$ApiLeaveCodeData {
  const factory ApiLeaveCodeData({
    @JsonKey(name: '_id') String? id,
    @JsonKey(name: 'name') String? name,
    @JsonKey(name: 'code') String? code,
    @JsonKey(name: 'description') String? description,
    @JsonKey(name: 'isActive') bool? isActive,
  }) = _ApiLeaveCodeData;

  factory ApiLeaveCodeData.fromJson(Map<String, dynamic> json) =>
      _$ApiLeaveCodeDataFromJson(json);
}
