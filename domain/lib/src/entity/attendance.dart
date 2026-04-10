import 'package:freezed_annotation/freezed_annotation.dart';

part 'attendance.freezed.dart';

@freezed
class Attendance with _$Attendance {
  const factory Attendance({
    @Default('') String id,
    @Default('') String userId,
    DateTime? date,
    DateTime? checkInTime,
    AttendanceLocation? checkInLocation,
    @Default([]) List<CheckOutHistory> checkOutHistory,
    @Default(AttendanceStatus.absent) AttendanceStatus status,
    DateTime? checkOutTime,
    AttendanceLocation? checkOutLocation,
    @Default(0.0) double workingHours,
    DateTime? createdAt,
    DateTime? updatedAt,
    @Default([]) List<AttendanceRecord> timeline,
    AttendanceSummary? summary,
  }) = _Attendance;
}

@freezed
class AttendanceLocation with _$AttendanceLocation {
  const factory AttendanceLocation({
    @Default(0.0) double latitude,
    @Default(0.0) double longitude,
  }) = _AttendanceLocation;
}

@freezed
class CheckOutHistory with _$CheckOutHistory {
  const factory CheckOutHistory({
    DateTime? time,
    AttendanceLocation? location,
  }) = _CheckOutHistory;
}

@freezed
class AttendanceRecord with _$AttendanceRecord {
  const factory AttendanceRecord({
    @Default(TimelineType.checkIn) TimelineType type,
    DateTime? time,
    AttendanceLocation? location,
  }) = _AttendanceRecord;
}

@freezed
class AttendanceSummary with _$AttendanceSummary {
  const factory AttendanceSummary({
    @Default(0) int totalCheckouts,
    @Default(0.0) double workingHours,
    @Default(AttendanceStatus.absent) AttendanceStatus status,
  }) = _AttendanceSummary;
}

enum AttendanceStatus {
  present,
  absent,
  late,
  earlyLeave;

  static AttendanceStatus fromString(String? value) {
    switch (value?.toLowerCase()) {
      case 'present':
        return AttendanceStatus.present;
      case 'absent':
        return AttendanceStatus.absent;
      case 'late':
        return AttendanceStatus.late;
      case 'early_leave':
      case 'earlyleave':
        return AttendanceStatus.earlyLeave;
      default:
        return AttendanceStatus.absent;
    }
  }
}

enum TimelineType {
  checkIn,
  checkOut;

  static TimelineType fromString(String? value) {
    switch (value?.toLowerCase()) {
      case 'check-in':
      case 'checkin':
        return TimelineType.checkIn;
      case 'check-out':
      case 'checkout':
        return TimelineType.checkOut;
      default:
        return TimelineType.checkIn;
    }
  }
}
