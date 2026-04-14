import 'package:domain/domain.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../base/bloc/base_bloc_state.dart';

part 'attendance_profile_state.freezed.dart';

@freezed
class AttendanceProfileState extends BaseBlocState with _$AttendanceProfileState {
  const factory AttendanceProfileState({
    User? user,
  }) = _AttendanceProfileState;
}
