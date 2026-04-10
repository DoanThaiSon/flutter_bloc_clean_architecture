import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../base/bloc/base_bloc_event.dart';

part 'attendance_profile_event.freezed.dart';

abstract class AttendanceProfileEvent extends BaseBlocEvent {
  const AttendanceProfileEvent();
}

@freezed
class AttendanceProfilePageInitiated extends AttendanceProfileEvent
    with _$AttendanceProfilePageInitiated {
  const factory AttendanceProfilePageInitiated() = _AttendanceProfilePageInitiated;
}
