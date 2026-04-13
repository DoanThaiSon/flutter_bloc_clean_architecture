import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import '../../domain.dart';

part 'delete_leave_request_use_case.freezed.dart';

@Injectable()
class DeleteLeaveRequestUseCase
    extends BaseFutureUseCase<DeleteLeaveRequestInput, DeleteLeaveRequestOutput> {
  const DeleteLeaveRequestUseCase(this._repository);

  final Repository _repository;

  @protected
  @override
  Future<DeleteLeaveRequestOutput> buildUseCase(DeleteLeaveRequestInput input) async {
    await _repository.deleteLeaveRequest(leaveRequestId: input.leaveRequestId);

    return const DeleteLeaveRequestOutput(success: true);
  }
}

@freezed
class DeleteLeaveRequestInput extends BaseInput with _$DeleteLeaveRequestInput {
  const factory DeleteLeaveRequestInput({
    required String leaveRequestId,
  }) = _DeleteLeaveRequestInput;
}

@freezed
class DeleteLeaveRequestOutput extends BaseOutput with _$DeleteLeaveRequestOutput {
  const DeleteLeaveRequestOutput._();

  const factory DeleteLeaveRequestOutput({
    required bool success,
  }) = _DeleteLeaveRequestOutput;
}
