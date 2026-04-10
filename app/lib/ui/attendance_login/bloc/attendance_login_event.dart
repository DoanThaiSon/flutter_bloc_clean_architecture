import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../base/bloc/base_bloc_event.dart';

part 'attendance_login_event.freezed.dart';

abstract class AttendanceLoginEvent extends BaseBlocEvent {
  const AttendanceLoginEvent();
}

@freezed
class LoginButtonPressed extends AttendanceLoginEvent with _$LoginButtonPressed {
  const factory LoginButtonPressed() = _LoginButtonPressed;
}

@freezed
class EmployeeIdChanged extends AttendanceLoginEvent with _$EmployeeIdChanged {
  const factory EmployeeIdChanged({required String employeeId}) = _EmployeeIdChanged;
}

@freezed
class PasswordChanged extends AttendanceLoginEvent with _$PasswordChanged {
  const factory PasswordChanged({required String password}) = _PasswordChanged;
}
