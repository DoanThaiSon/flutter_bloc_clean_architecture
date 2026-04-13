import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import '../../domain.dart';

part 'approve_leave_request_use_case.freezed.dart';

@Injectable()
class ApproveLeaveRequestUseCase
    extends BaseFutureUseCase<ApproveLeaveRequestInput, ApproveLeaveRequestOutput> {
  const ApproveLeaveRequestUseCase(this._repository);

  final Repository _repository;

  @protected
  @override
  Future<ApproveLeaveRequestOutput> buildUseCase(ApproveLeaveRequestInput input) async {
    await _repository.approveLeaveRequest(leaveRequestId: input.leaveRequestId);

    return const ApproveLeaveRequestOutput(success: true);
  }
}

@freezed
class ApproveLeaveRequestInput extends BaseInput with _$ApproveLeaveRequestInput {
  const factory ApproveLeaveRequestInput({
    required String leaveRequestId,
  }) = _ApproveLeaveRequestInput;
}

@freezed
class ApproveLeaveRequestOutput extends BaseOutput with _$ApproveLeaveRequestOutput {
  const ApproveLeaveRequestOutput._();

  const factory ApproveLeaveRequestOutput({
    required bool success,
  }) = _ApproveLeaveRequestOutput;
}
