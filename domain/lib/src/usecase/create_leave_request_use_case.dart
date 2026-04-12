import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

import '../../domain.dart';

part 'create_leave_request_use_case.freezed.dart';

@Injectable()
class CreateLeaveRequestUseCase extends BaseFutureUseCase<
    CreateLeaveRequestInput, CreateLeaveRequestOutput> {
  const CreateLeaveRequestUseCase(this._repository);

  final Repository _repository;

  @protected
  @override
  Future<CreateLeaveRequestOutput> buildUseCase(
      CreateLeaveRequestInput input) async {
    final response = await _repository.createLeaveRequest(
      dayType: input.dayType,
      shift: input.shift,
      leaveCodeId: input.leaveCodeId,
      startDate: input.startDate,
      endDate: input.endDate,
      reason: input.reason,
    );

    return CreateLeaveRequestOutput(response: response);
  }
}

@freezed
class CreateLeaveRequestInput extends BaseInput
    with _$CreateLeaveRequestInput {
  const factory CreateLeaveRequestInput({
    required String dayType,
    required String shift,
    required String leaveCodeId,
    required String startDate,
    required String endDate,
    required String reason,
  }) = _CreateLeaveRequestInput;
}

@freezed
class CreateLeaveRequestOutput extends BaseOutput
    with _$CreateLeaveRequestOutput {
  const CreateLeaveRequestOutput._();

  const factory CreateLeaveRequestOutput({
    required CreateLeaveRequestResponse response,
  }) = _CreateLeaveRequestOutput;
}
