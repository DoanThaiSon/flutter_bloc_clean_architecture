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
    @Default(LoadDataStatus.init) LoadDataStatus loadMoreStatus,
    @Default(0) int selectedTabIndex,
    @Default(0) int pendingCount,
    @Default(1) int currentPage,
    @Default(false) bool hasMoreData,
    @Default(false) bool isLoadingMore,
    LeaveType? selectedLeaveType,
    Shift? selectedShift,
    String? selectedLeaveCode,
    String? selectedLeaveCodeId,
    DateTime? selectedDate,
    DateTime? startDate,
    DateTime? endDate,
    String? reason,
    @Default([]) List<LeaveCode> leaveCodes,
    @Default(LoadDataStatus.init) LoadDataStatus getLeaveCodesStatus,
    @Default(LoadDataStatus.init) LoadDataStatus createLeaveRequestStatus,
    @Default(LoadDataStatus.init) LoadDataStatus deleteLeaveRequestStatus,
    @Default(LoadDataStatus.init) LoadDataStatus updateLeaveRequestStatus,
    @Default(LoadDataStatus.init) LoadDataStatus approveLeaveRequestStatus,
    @Default(LoadDataStatus.init) LoadDataStatus rejectLeaveRequestStatus,
    String? updateLeaveRequestErrorMessage,
    String? createLeaveRequestErrorMessage,
    AppException? loadDataException,
    User? currentUser,
  }) = _LeaveRequestState;

  double get totalDays {
    if (selectedLeaveType == null) {
      return 0;
    }

    if (selectedLeaveType == LeaveType.halfDay) {
      return 0.5;
    } else if (selectedLeaveType == LeaveType.oneDay) {
      return 1.0;
    } else if (selectedLeaveType == LeaveType.multipleDays) {
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

    if (selectedLeaveType == LeaveType.multipleDays) {
      return startDate != null && endDate != null;
    } else {
      return selectedDate != null;
    }
  }

  bool get isUserRole => currentUser?.role == 'user';

  bool get canLoadMore => hasMoreData && !isLoadingMore;
}
