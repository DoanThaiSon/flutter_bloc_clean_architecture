import 'package:freezed_annotation/freezed_annotation.dart';
import 'attendance.dart';

part 'attendance_history.freezed.dart';

@freezed
class AttendanceHistory with _$AttendanceHistory {
  const factory AttendanceHistory({
    @Default([]) List<Attendance> attendances,
    @Default([]) List<LeaveRecord> leaveRecords,
    AttendanceHistorySummary? summary,
  }) = _AttendanceHistory;
}

@freezed
class LeaveRecord with _$LeaveRecord {
  const factory LeaveRecord({
    DateTime? date,
    @Default('') String status,
    @Default('') String dayType,
    @Default('') String shift,
    @Default('') String reason,
    LeaveCodeInfo? leaveCode,
    @Default('') String leaveRequestId,
  }) = _LeaveRecord;
}

@freezed
class LeaveCodeInfo with _$LeaveCodeInfo {
  const factory LeaveCodeInfo({
    @Default('') String name,
    @Default('') String code,
  }) = _LeaveCodeInfo;
}

@freezed
class AttendanceHistorySummary with _$AttendanceHistorySummary {
  const factory AttendanceHistorySummary({
    @Default(0) int totalDays,
    @Default(0.0) double totalWorkingHours,
    @Default(0) int present,
    @Default(0) int late,
    @Default(0) int absent,
    @Default(0.0) double leave,
    @Default(0) int halfDay,
  }) = _AttendanceHistorySummary;
}
