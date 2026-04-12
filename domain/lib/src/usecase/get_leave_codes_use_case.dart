import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

import '../../domain.dart';

part 'get_leave_codes_use_case.freezed.dart';

@Injectable()
class GetLeaveCodesUseCase
    extends BaseFutureUseCase<GetLeaveCodesInput, GetLeaveCodesOutput> {
  const GetLeaveCodesUseCase(this._repository);

  final Repository _repository;

  @protected
  @override
  Future<GetLeaveCodesOutput> buildUseCase(GetLeaveCodesInput input) async {
    final response = await _repository.getLeaveCodes();

    return GetLeaveCodesOutput(leaveCodeResponse: response);
  }
}

@freezed
class GetLeaveCodesInput extends BaseInput with _$GetLeaveCodesInput {
  const factory GetLeaveCodesInput() = _GetLeaveCodesInput;
}

@freezed
class GetLeaveCodesOutput extends BaseOutput with _$GetLeaveCodesOutput {
  const GetLeaveCodesOutput._();

  const factory GetLeaveCodesOutput({
    required LeaveCodeResponse leaveCodeResponse,
  }) = _GetLeaveCodesOutput;
}
