import 'package:freezed_annotation/freezed_annotation.dart';

import 'api_leave_request_data.dart';

part 'api_create_leave_request_data.freezed.dart';
part 'api_create_leave_request_data.g.dart';

@freezed
class ApiCreateLeaveRequestResponse with _$ApiCreateLeaveRequestResponse {
  const factory ApiCreateLeaveRequestResponse({
    @JsonKey(name: 'status') String? status,
    @JsonKey(name: 'message') String? message,
    @JsonKey(name: 'data') ApiLeaveRequestData? data,
  }) = _ApiCreateLeaveRequestResponse;

  factory ApiCreateLeaveRequestResponse.fromJson(Map<String, dynamic> json) =>
      _$ApiCreateLeaveRequestResponseFromJson(json);
}

@freezed
class ApiCreateLeaveRequestBody with _$ApiCreateLeaveRequestBody {
  const factory ApiCreateLeaveRequestBody({
    @JsonKey(name: 'dayType') required String dayType,
    @JsonKey(name: 'shift') required String shift,
    @JsonKey(name: 'leaveCodeId') required String leaveCodeId,
    @JsonKey(name: 'startDate') required String startDate,
    @JsonKey(name: 'endDate') required String endDate,
    @JsonKey(name: 'reason') required String reason,
  }) = _ApiCreateLeaveRequestBody;

  factory ApiCreateLeaveRequestBody.fromJson(Map<String, dynamic> json) =>
      _$ApiCreateLeaveRequestBodyFromJson(json);
}
