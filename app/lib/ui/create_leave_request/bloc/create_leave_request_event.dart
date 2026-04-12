import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../base/bloc/base_bloc_event.dart';

part 'create_leave_request_event.freezed.dart';

abstract class CreateLeaveRequestEvent extends BaseBlocEvent {
  const CreateLeaveRequestEvent();
}

@freezed
class CreateLeaveRequestPageInitiated extends CreateLeaveRequestEvent
    with _$CreateLeaveRequestPageInitiated {
  const factory CreateLeaveRequestPageInitiated() =
      _CreateLeaveRequestPageInitiated;
}

@freezed
class LeaveTypeChanged extends CreateLeaveRequestEvent
    with _$LeaveTypeChanged {
  const factory LeaveTypeChanged({required String leaveType}) =
      _LeaveTypeChanged;
}

@freezed
class ShiftChanged extends CreateLeaveRequestEvent with _$ShiftChanged {
  const factory ShiftChanged({required String shift}) = _ShiftChanged;
}

@freezed
class LeaveCodeChanged extends CreateLeaveRequestEvent
    with _$LeaveCodeChanged {
  const factory LeaveCodeChanged({required String leaveCode}) =
      _LeaveCodeChanged;
}

@freezed
class DateChanged extends CreateLeaveRequestEvent with _$DateChanged {
  const factory DateChanged({required DateTime date}) = _DateChanged;
}

@freezed
class StartDateChanged extends CreateLeaveRequestEvent with _$StartDateChanged {
  const factory StartDateChanged({required DateTime date}) = _StartDateChanged;
}

@freezed
class EndDateChanged extends CreateLeaveRequestEvent with _$EndDateChanged {
  const factory EndDateChanged({required DateTime date}) = _EndDateChanged;
}

@freezed
class ReasonChanged extends CreateLeaveRequestEvent with _$ReasonChanged {
  const factory ReasonChanged({required String reason}) = _ReasonChanged;
}

@freezed
class SubmitButtonPressed extends CreateLeaveRequestEvent
    with _$SubmitButtonPressed {
  const factory SubmitButtonPressed() = _SubmitButtonPressed;
}
