import 'package:domain/domain.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:shared/shared.dart';
import '../../../base/bloc/base_bloc_state.dart';
import '../../../services/location_service.dart';

part 'attendance_home_state.freezed.dart';

@freezed
class AttendanceHomeState extends BaseBlocState with _$AttendanceHomeState {
  const factory AttendanceHomeState({
    User? user,
    Attendance? attendance,
    @Default('') String currentTime,
    @Default(LoadDataStatus.init) LoadDataStatus getTodayAttendanceStatus,
    @Default(LoadDataStatus.init) LoadDataStatus checkOutStatus,
    @Default(LoadDataStatus.init) LoadDataStatus checkInStatus,
    @Default(LocationPermissionStatus.granted) LocationPermissionStatus locationPermissionStatus,
    AppException? loadDataException,
  }) = _AttendanceHomeState;
}
