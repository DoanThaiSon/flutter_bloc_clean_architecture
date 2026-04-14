import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../base/bloc/base_bloc_event.dart';

part 'attendance_home_event.freezed.dart';

abstract class AttendanceHomeEvent extends BaseBlocEvent {
  const AttendanceHomeEvent();
}

@freezed
class AttendanceHomePageInitiated extends AttendanceHomeEvent with _$AttendanceHomePageInitiated {
  const factory AttendanceHomePageInitiated() = _AttendanceHomePageInitiated;
}

@freezed
class TimeUpdated extends AttendanceHomeEvent with _$TimeUpdated {
  const factory TimeUpdated({required String currentTime}) = _TimeUpdated;
}

@freezed
class CheckoutButtonPressed extends AttendanceHomeEvent with _$CheckoutButtonPressed {
  const factory CheckoutButtonPressed() = _CheckoutButtonPressed;
}

@freezed
class CheckInButtonPressed extends AttendanceHomeEvent with _$CheckInButtonPressed{
  const factory CheckInButtonPressed() = _CheckInButtonPressed;
}

@freezed
class CheckLocationPermission extends AttendanceHomeEvent with _$CheckLocationPermission {
  const factory CheckLocationPermission() = _CheckLocationPermission;
}

@freezed
class OpenLocationSettings extends AttendanceHomeEvent with _$OpenLocationSettings {
  const factory OpenLocationSettings() = _OpenLocationSettings;
}
