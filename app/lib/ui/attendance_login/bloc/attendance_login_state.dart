import 'package:domain/domain.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../base/bloc/base_bloc_state.dart';

part 'attendance_login_state.freezed.dart';

@freezed
class AttendanceLoginState extends BaseBlocState with _$AttendanceLoginState {
  const factory AttendanceLoginState({
    @Default('') String employeeId,
    @Default('') String password,
    @Default(false) bool isLoginButtonEnabled,
    @Default(false) bool isLoading,
    User? user,
  }) = _AttendanceLoginState;
}
