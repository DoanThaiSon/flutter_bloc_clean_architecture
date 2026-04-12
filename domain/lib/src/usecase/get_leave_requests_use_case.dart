import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

import '../../domain.dart';

part 'get_leave_requests_use_case.freezed.dart';

@Injectable()
class GetLeaveRequestsUseCase
    extends BaseFutureUseCase<GetLeaveRequestsInput, GetLeaveRequestsOutput> {
  const GetLeaveRequestsUseCase(this._repository);

  final Repository _repository;

  @protected
  @override
  Future<GetLeaveRequestsOutput> buildUseCase(GetLeaveRequestsInput input) async {
    final response = await _repository.getLeaveRequests(
      page: input.page,
      limit: input.limit,
    );

    return GetLeaveRequestsOutput(
      leaveRequestResponse: response
    );
  }
}

@freezed
class GetLeaveRequestsInput extends BaseInput with _$GetLeaveRequestsInput {
  const factory GetLeaveRequestsInput({
    @Default(1) int page,
    @Default(10) int limit,
  }) = _GetLeaveRequestsInput;
}

@freezed
class GetLeaveRequestsOutput extends BaseOutput with _$GetLeaveRequestsOutput {
  const GetLeaveRequestsOutput._();

  const factory GetLeaveRequestsOutput({
    required LeaveRequestResponse leaveRequestResponse,
  }) = _GetLeaveRequestsOutput;
}
