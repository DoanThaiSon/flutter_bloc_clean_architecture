import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import '../../domain.dart';

part 'reject_leave_request_use_case.freezed.dart';

@Injectable()
class RejectLeaveRequestUseCase
    extends BaseFutureUseCase<RejectLeaveRequestInput, RejectLeaveRequestOutput> {
  const RejectLeaveRequestUseCase(this._repository);

  final Repository _repository;

  @protected
  @override
  Future<RejectLeaveRequestOutput> buildUseCase(RejectLeaveRequestInput input) async {
    await _repository.rejectLeaveRequest(
      leaveRequestId: input.leaveRequestId,
      rejectionReason: input.rejectionReason,
    );

    return const RejectLeaveRequestOutput(success: true);
  }
}

@freezed
class RejectLeaveRequestInput extends BaseInput with _$RejectLeaveRequestInput {
  const factory RejectLeaveRequestInput({
    required String leaveRequestId,
    required String rejectionReason,
  }) = _RejectLeaveRequestInput;
}

@freezed
class RejectLeaveRequestOutput extends BaseOutput with _$RejectLeaveRequestOutput {
  const RejectLeaveRequestOutput._();

  const factory RejectLeaveRequestOutput({
    required bool success,
  }) = _RejectLeaveRequestOutput;
}
