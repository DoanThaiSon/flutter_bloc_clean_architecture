import 'package:domain/domain.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:shared/shared.dart';
import '../../../base/bloc/base_bloc_state.dart';

part 'attendance_history_state.freezed.dart';

@freezed
class AttendanceHistoryState extends BaseBlocState with _$AttendanceHistoryState {
  const factory AttendanceHistoryState({
    @Default(0) int selectedMonth,
    @Default(0) int selectedYear,
    DateTime? selectedDate,
    AttendanceHistory? attendanceHistory,
    @Default(LoadDataStatus.init) LoadDataStatus loadDataStatus,
    AppException? loadDataException,
  }) = _AttendanceHistoryState;
}
