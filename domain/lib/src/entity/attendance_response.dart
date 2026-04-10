import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain.dart';

part 'attendance_response.freezed.dart';

@freezed
class AttendanceResponse with _$AttendanceResponse {
  const factory AttendanceResponse({
    @Default('') String status,
    @Default('') String message,
    Attendance? attendance,
  }) = _AttendanceResponse;
}
