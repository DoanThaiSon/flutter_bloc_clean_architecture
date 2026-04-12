import 'package:domain/domain.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:shared/shared.dart';
import '../../../app.dart';

part 'leave_request_state.freezed.dart';

@freezed
class LeaveRequestState extends BaseBlocState with _$LeaveRequestState {
  const LeaveRequestState._();
  const factory LeaveRequestState({
    LeaveRequestResponse? leaveRequests,
    @Default(LoadDataStatus.init) LoadDataStatus getLeaveRequestResponseStatus,
    @Default(0) int selectedTabIndex,
    String? selectedLeaveType,
    String? selectedShift,
    String? selectedLeaveCode,
    String? selectedLeaveCodeId,
    DateTime? selectedDate,
    DateTime? startDate,
    DateTime? endDate,
    String? reason,
    @Default([]) List<LeaveCode> leaveCodes,
    @Default(LoadDataStatus.init) LoadDataStatus getLeaveCodesStatus,
    @Default(LoadDataStatus.init) LoadDataStatus createLeaveRequestStatus,
    AppException? loadDataException,
  }) = _LeaveRequestState;

  double get totalDays {
    if (selectedLeaveType == null) {
      return 0;
    }

    if (selectedLeaveType == 'Nghỉ nửa ngày') {
      return 0.5;
    } else if (selectedLeaveType == 'Nghỉ 1 ngày') {
      return 1.0;
    } else if (selectedLeaveType == 'Nghỉ nhiều ngày') {
      if (startDate != null && endDate != null) {
        final difference = endDate!.difference(startDate!).inDays + 1;
        return difference.toDouble();
      }
      return 0;
    }
    return 0;
  }

  bool get isFormValid {
    if (selectedLeaveType == null ||
        selectedLeaveCodeId == null ||
        reason == null ||
        reason!.trim().isEmpty) {
      return false;
    }

    if (selectedLeaveType == 'Nghỉ nhiều ngày') {
      return startDate != null && endDate != null;
    } else {
      return selectedDate != null;
    }
  }
}



