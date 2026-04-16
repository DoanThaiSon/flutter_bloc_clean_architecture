import 'package:freezed_annotation/freezed_annotation.dart';
import 'api_attendance_data.dart';

part 'api_attendance_history_data.g.dart';
part 'api_attendance_history_data.freezed.dart';

@freezed
class ApiAttendanceHistoryData with _$ApiAttendanceHistoryData {
  const factory ApiAttendanceHistoryData({
    @JsonKey(name: 'attendances') List<ApiAttendanceData>? attendances,
    @JsonKey(name: 'leaveRecords') List<ApiLeaveRecordData>? leaveRecords,
    @JsonKey(name: 'summary') ApiAttendanceHistorySummaryData? summary,
  }) = _ApiAttendanceHistoryData;

  factory ApiAttendanceHistoryData.fromJson(Map<String, dynamic> json) =>
      _$ApiAttendanceHistoryDataFromJson(json);
}

@freezed
class ApiLeaveRecordData with _$ApiLeaveRecordData {
  const factory ApiLeaveRecordData({
    @JsonKey(name: 'date') String? date,
    @JsonKey(name: 'status') String? status,
    @JsonKey(name: 'dayType') String? dayType,
    @JsonKey(name: 'shift') String? shift,
    @JsonKey(name: 'reason') String? reason,
    @JsonKey(name: 'leaveCode') ApiLeaveCodeInfoData? leaveCode,
    @JsonKey(name: 'leaveRequestId') String? leaveRequestId,
  }) = _ApiLeaveRecordData;

  factory ApiLeaveRecordData.fromJson(Map<String, dynamic> json) =>
      _$ApiLeaveRecordDataFromJson(json);
}

@freezed
class ApiLeaveCodeInfoData with _$ApiLeaveCodeInfoData {
  const factory ApiLeaveCodeInfoData({
    @JsonKey(name: 'name') String? name,
    @JsonKey(name: 'code') String? code,
  }) = _ApiLeaveCodeInfoData;

  factory ApiLeaveCodeInfoData.fromJson(Map<String, dynamic> json) =>
      _$ApiLeaveCodeInfoDataFromJson(json);
}

@freezed
class ApiAttendanceHistorySummaryData with _$ApiAttendanceHistorySummaryData {
  const factory ApiAttendanceHistorySummaryData({
    @JsonKey(name: 'totalDays') int? totalDays,
    @JsonKey(name: 'totalWorkingHours') double? totalWorkingHours,
    @JsonKey(name: 'present') int? present,
    @JsonKey(name: 'late') int? late,
    @JsonKey(name: 'absent') int? absent,
    @JsonKey(name: 'leave') double? leave,
    @JsonKey(name: 'halfDay') int? halfDay,
  }) = _ApiAttendanceHistorySummaryData;

  factory ApiAttendanceHistorySummaryData.fromJson(Map<String, dynamic> json) =>
      _$ApiAttendanceHistorySummaryDataFromJson(json);
}
