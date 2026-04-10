import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../base/bloc/base_bloc_event.dart';

part 'attendance_history_event.freezed.dart';

abstract class AttendanceHistoryEvent extends BaseBlocEvent {
  const AttendanceHistoryEvent();
}

@freezed
class AttendanceHistoryPageInitiated extends AttendanceHistoryEvent
    with _$AttendanceHistoryPageInitiated {
  const factory AttendanceHistoryPageInitiated() = _AttendanceHistoryPageInitiated;
}
