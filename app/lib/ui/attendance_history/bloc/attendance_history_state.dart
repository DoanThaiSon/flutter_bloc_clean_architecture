import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../base/bloc/base_bloc_state.dart';

part 'attendance_history_state.freezed.dart';

@freezed
class AttendanceHistoryState extends BaseBlocState with _$AttendanceHistoryState {
  const factory AttendanceHistoryState({
    @Default('') String selectedMonth,
    @Default([]) List<dynamic> attendanceRecords,
  }) = _AttendanceHistoryState;
}
