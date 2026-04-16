import 'package:freezed_annotation/freezed_annotation.dart';

part 'api_leave_request_data.freezed.dart';

part 'api_leave_request_data.g.dart';

@freezed
class ApiLeaveRequestResponse with _$ApiLeaveRequestResponse {
  const factory ApiLeaveRequestResponse({
    @JsonKey(name: 'status') String? status,
    @JsonKey(name: 'message') String? message,
    @JsonKey(name: 'data') List<ApiLeaveRequestData>? data,
    @JsonKey(name: 'page') int? page,
    @JsonKey(name: 'limit') int? limit,
    @JsonKey(name: 'total') int? total,
  }) = _ApiLeaveRequestResponse;

  factory ApiLeaveRequestResponse.fromJson(Map<String, dynamic> json) =>
      _$ApiLeaveRequestResponseFromJson(json);
}

@freezed
class ApiLeaveRequestData with _$ApiLeaveRequestData {
  const factory ApiLeaveRequestData({
    @JsonKey(name: '_id') String? id,
    @JsonKey(name: 'userId') String? userId,
    @JsonKey(name: 'dayType') String? dayType,
    @JsonKey(name: 'shift') String? shift,
    @JsonKey(name: 'creatorName') String? creatorName,
    @JsonKey(name: 'leaveCodeId') String? leaveCodeId,
    @JsonKey(name: 'startDate') String? startDate,
    @JsonKey(name: 'endDate') String? endDate,
    @JsonKey(name: 'totalDays') double? totalDays,
    @JsonKey(name: 'reason') String? reason,
    @JsonKey(name: 'status') String? status,
    @JsonKey(name: 'approvedBy') String? approvedBy,
    @JsonKey(name: 'approvedAt') String? approvedAt,
    @JsonKey(name: 'rejectionReason') String? rejectionReason,
    @JsonKey(name: 'createdAt') String? createdAt,
    @JsonKey(name: 'updatedAt') String? updatedAt,
    @JsonKey(name: '_destroy') bool? destroy,
    @JsonKey(name: 'approver') ApiApproverData? approver,
  }) = _ApiLeaveRequestData;

  factory ApiLeaveRequestData.fromJson(Map<String, dynamic> json) =>
      _$ApiLeaveRequestDataFromJson(json);
}

@freezed
class ApiApproverData with _$ApiApproverData {
  const factory ApiApproverData({
    @JsonKey(name: '_id') String? id,
    @JsonKey(name: 'email') String? email,
    @JsonKey(name: 'username') String? username,
    @JsonKey(name: 'role') String? role,
    @JsonKey(name: 'createdAt') String? createdAt,
    @JsonKey(name: 'updatedAt') String? updatedAt,
  }) = _ApiApproverData;

  factory ApiApproverData.fromJson(Map<String, dynamic> json) =>
      _$ApiApproverDataFromJson(json);
}
