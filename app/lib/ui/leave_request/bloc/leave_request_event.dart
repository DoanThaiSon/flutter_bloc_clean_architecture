import 'package:domain/domain.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../app.dart';
part 'leave_request_event.freezed.dart';

abstract class LeaveRequestEvent extends BaseBlocEvent {
  const LeaveRequestEvent();
}

@freezed
class LeaveRequestTabChanged extends LeaveRequestEvent
    with _$LeaveRequestTabChanged {
  const factory LeaveRequestTabChanged({
    required int tabIndex,
  }) = _LeaveRequestTabChanged;
}

@freezed
class GetLeaveCodes extends LeaveRequestEvent with _$GetLeaveCodes {
  const factory GetLeaveCodes() = _GetLeaveCodes;
}

@freezed
class LeaveTypeChanged extends LeaveRequestEvent with _$LeaveTypeChanged {
  const factory LeaveTypeChanged({required LeaveType leaveType}) =
      _LeaveTypeChanged;
}

@freezed
class ShiftChanged extends LeaveRequestEvent with _$ShiftChanged {
  const factory ShiftChanged({required Shift shift}) = _ShiftChanged;
}

@freezed
class LeaveCodeChanged extends LeaveRequestEvent with _$LeaveCodeChanged {
  const factory LeaveCodeChanged({required String leaveCode}) =
      _LeaveCodeChanged;
}

@freezed
class DateChanged extends LeaveRequestEvent with _$DateChanged {
  const factory DateChanged({required DateTime date}) = _DateChanged;
}

@freezed
class StartDateChanged extends LeaveRequestEvent with _$StartDateChanged {
  const factory StartDateChanged({required DateTime date}) = _StartDateChanged;
}

@freezed
class EndDateChanged extends LeaveRequestEvent with _$EndDateChanged {
  const factory EndDateChanged({required DateTime date}) = _EndDateChanged;
}

@freezed
class ReasonChanged extends LeaveRequestEvent with _$ReasonChanged {
  const factory ReasonChanged({required String reason}) = _ReasonChanged;
}

@freezed
class SubmitButtonPressed extends LeaveRequestEvent with _$SubmitButtonPressed {
  const factory SubmitButtonPressed() = _SubmitButtonPressed;
}

@freezed
class ApproveLeaveRequestButtonPressed extends LeaveRequestEvent
    with _$ApproveLeaveRequestButtonPressed {
  const factory ApproveLeaveRequestButtonPressed({
    required String leaveRequestId,
  }) = _ApproveLeaveRequestButtonPressed;
}

@freezed
class RejectLeaveRequestButtonPressed extends LeaveRequestEvent
    with _$RejectLeaveRequestButtonPressed {
  const factory RejectLeaveRequestButtonPressed({
    required String leaveRequestId,
    required String rejectionReason,
  }) = _RejectLeaveRequestButtonPressed;
}

@freezed
class DeleteLeaveRequestButtonPressed extends LeaveRequestEvent
    with _$DeleteLeaveRequestButtonPressed {
  const factory DeleteLeaveRequestButtonPressed({
    required String leaveRequestId,
  }) = _DeleteLeaveRequestButtonPressed;
}

@freezed
class UpdateLeaveRequestButtonPressed extends LeaveRequestEvent
    with _$UpdateLeaveRequestButtonPressed {
  const factory UpdateLeaveRequestButtonPressed({
    required String leaveRequestId,
  }) = _UpdateLeaveRequestButtonPressed;
}

@freezed
class LoadLeaveRequestForEdit extends LeaveRequestEvent
    with _$LoadLeaveRequestForEdit {
  const factory LoadLeaveRequestForEdit({
    required LeaveType leaveType,
    required String reason,
    Shift? shift,
    String? leaveCodeId,
    String? leaveCodeName,
    DateTime? selectedDate,
    DateTime? startDate,
    DateTime? endDate,
  }) = _LoadLeaveRequestForEdit;
}

@freezed
class LeaveRequestPageInitiated extends LeaveRequestEvent
    with _$LeaveRequestPageInitiated {
  const factory LeaveRequestPageInitiated() = _LeaveRequestPageInitiated;
}

@freezed
class LoadMoreLeaveRequests extends LeaveRequestEvent
    with _$LoadMoreLeaveRequests {
  const factory LoadMoreLeaveRequests() = _LoadMoreLeaveRequests;
}
@freezed
class ClearUpdateLeaveRequestErrorMessage extends LeaveRequestEvent
    with _$ClearUpdateLeaveRequestErrorMessage {
  const factory ClearUpdateLeaveRequestErrorMessage() = _ClearUpdateLeaveRequestErrorMessage;
}
@freezed
class ClearCreateLeaveRequestErrorMessage extends LeaveRequestEvent
    with _$ClearCreateLeaveRequestErrorMessage {
  const factory ClearCreateLeaveRequestErrorMessage() = _ClearCreateLeaveRequestErrorMessage;
}
