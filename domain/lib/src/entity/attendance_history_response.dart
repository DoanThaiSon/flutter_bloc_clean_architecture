import 'package:freezed_annotation/freezed_annotation.dart';
import 'attendance_history.dart';

part 'attendance_history_response.freezed.dart';

@freezed
class AttendanceHistoryResponse with _$AttendanceHistoryResponse {
  const factory AttendanceHistoryResponse({
    @Default('') String status,
    @Default('') String message,
    AttendanceHistory? attendanceHistory,
  }) = _AttendanceHistoryResponse;
}
