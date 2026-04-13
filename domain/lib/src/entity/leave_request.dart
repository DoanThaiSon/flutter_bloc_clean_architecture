import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain.dart';

part 'leave_request.freezed.dart';

@freezed
class LeaveRequest with _$LeaveRequest {
  const factory LeaveRequest({
    @Default('') String id,
    @Default('') String userId,
    @Default('') String dayType,
    @Default('') String shift,
    @Default('') String leaveCodeId,
    @Default('') String creatorName,
    @Default('') String startDate,
    @Default('') String endDate,
    @Default(0) int totalDays,
    @Default('') String reason,
    @Default('') String status,
    @Default('') String approvedBy,
    @Default('') String approvedAt,
    @Default('') String rejectionReason,
    @Default('') String createdAt,
    @Default('') String updatedAt,
    @Default(false) bool destroy,
    User? approver,
  }) = _LeaveRequest;
}

@freezed
class LeaveRequestResponse with _$LeaveRequestResponse {
  const factory LeaveRequestResponse({
    @Default('') String status,
    @Default('') String message,
    @Default([]) List<LeaveRequest> data,
    @Default(1) int page,
    @Default(10) int limit,
    @Default(0) int total,
  }) = _LeaveRequestResponse;
}
