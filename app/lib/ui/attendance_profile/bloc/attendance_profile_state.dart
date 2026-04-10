import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../base/bloc/base_bloc_state.dart';

part 'attendance_profile_state.freezed.dart';

@freezed
class AttendanceProfileState extends BaseBlocState with _$AttendanceProfileState {
  const factory AttendanceProfileState({
    @Default('') String userName,
    @Default('') String employeeId,
    @Default('') String department,
  }) = _AttendanceProfileState;
}
