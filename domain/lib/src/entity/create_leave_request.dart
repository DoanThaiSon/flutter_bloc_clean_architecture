import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain.dart';

part 'create_leave_request.freezed.dart';

@freezed
class CreateLeaveRequestData with _$CreateLeaveRequestData {
  const factory CreateLeaveRequestData({
    required String dayType,
    required String shift,
    required String leaveCodeId,
    required String startDate,
    required String endDate,
    required String reason,
  }) = _CreateLeaveRequestData;
}

@freezed
class CreateLeaveRequestResponse with _$CreateLeaveRequestResponse {
  const factory CreateLeaveRequestResponse({
    @Default('') String status,
    @Default('') String message,
    LeaveRequest? data,
  }) = _CreateLeaveRequestResponse;
}
