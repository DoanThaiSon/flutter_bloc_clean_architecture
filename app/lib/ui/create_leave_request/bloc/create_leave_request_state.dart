import 'package:domain/domain.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:shared/shared.dart';

import '../../../base/bloc/base_bloc_state.dart';

part 'create_leave_request_state.freezed.dart';

@freezed
class CreateLeaveRequestState extends BaseBlocState
    with _$CreateLeaveRequestState {
  const CreateLeaveRequestState._();

  const factory CreateLeaveRequestState({
    @Default(false) bool isLoading,
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
  }) = _CreateLeaveRequestState;

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
