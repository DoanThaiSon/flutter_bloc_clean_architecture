import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import '../../domain.dart';

part 'update_leave_request_use_case.freezed.dart';

@Injectable()
class UpdateLeaveRequestUseCase
    extends BaseFutureUseCase<UpdateLeaveRequestInput, UpdateLeaveRequestOutput> {
  const UpdateLeaveRequestUseCase(this._repository);

  final Repository _repository;

  @protected
  @override
  Future<UpdateLeaveRequestOutput> buildUseCase(UpdateLeaveRequestInput input) async {
    await _repository.updateLeaveRequest(
      leaveRequestId: input.leaveRequestId,
      dayType: input.dayType,
      shift: input.shift,
      leaveCodeId: input.leaveCodeId,
      startDate: input.startDate,
      endDate: input.endDate,
      reason: input.reason,
    );

    return const UpdateLeaveRequestOutput(success: true);
  }
}

@freezed
class UpdateLeaveRequestInput extends BaseInput with _$UpdateLeaveRequestInput {
  const factory UpdateLeaveRequestInput({
    required String leaveRequestId,
    required String dayType,
    required String shift,
    required String leaveCodeId,
    required String startDate,
    required String endDate,
    required String reason,
  }) = _UpdateLeaveRequestInput;
}

@freezed
class UpdateLeaveRequestOutput extends BaseOutput with _$UpdateLeaveRequestOutput {
  const UpdateLeaveRequestOutput._();

  const factory UpdateLeaveRequestOutput({
    required bool success,
  }) = _UpdateLeaveRequestOutput;
}
