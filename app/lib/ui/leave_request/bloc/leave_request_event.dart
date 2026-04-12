import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../app.dart';

part 'leave_request_event.freezed.dart';

abstract class LeaveRequestEvent extends BaseBlocEvent {
  const LeaveRequestEvent();
}

@freezed
class LeaveRequestPageInitiated extends LeaveRequestEvent with _$LeaveRequestPageInitiated {
  const factory LeaveRequestPageInitiated() = _LeaveRequestPageInitiated;
}

@freezed
class LeaveRequestTabChanged extends LeaveRequestEvent with _$LeaveRequestTabChanged {
  const factory LeaveRequestTabChanged({
    required int tabIndex,
  }) = _LeaveRequestTabChanged;
}
