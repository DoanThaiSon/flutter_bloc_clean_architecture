import 'package:domain/domain.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:shared/shared.dart';
import '../../../app.dart';

part 'leave_request_state.freezed.dart';

@freezed
class LeaveRequestState extends BaseBlocState with _$LeaveRequestState {
  const factory LeaveRequestState({
    LeaveRequestResponse? leaveRequests,
    @Default(LoadDataStatus.init) LoadDataStatus getLeaveRequestResponseStatus,
    @Default(0) int selectedTabIndex,
    AppException? loadDataException,
  }) = _LeaveRequestState;
}


