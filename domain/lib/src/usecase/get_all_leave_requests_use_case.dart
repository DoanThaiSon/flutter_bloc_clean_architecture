import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import '../../domain.dart';

part 'get_all_leave_requests_use_case.freezed.dart';

@Injectable()
class GetAllLeaveRequestsUseCase
    extends BaseFutureUseCase<GetAllLeaveRequestsInput, GetAllLeaveRequestsOutput> {
  const GetAllLeaveRequestsUseCase(this._repository);

  final Repository _repository;

  @protected
  @override
  Future<GetAllLeaveRequestsOutput> buildUseCase(GetAllLeaveRequestsInput input) async {
    final response = await _repository.getAllLeaveRequests(
      page: input.page,
      limit: input.limit,
      status: input.status
    );

    return GetAllLeaveRequestsOutput(
      leaveRequestResponse: response
    );
  }
}

@freezed
class GetAllLeaveRequestsInput extends BaseInput with _$GetAllLeaveRequestsInput {
  const factory GetAllLeaveRequestsInput({
    @Default(1) int page,
    @Default(10) int limit,
    String? status
  }) = _GetAllLeaveRequestsInput;
}

@freezed
class GetAllLeaveRequestsOutput extends BaseOutput with _$GetAllLeaveRequestsOutput {
  const GetAllLeaveRequestsOutput._();

  const factory GetAllLeaveRequestsOutput({
    required LeaveRequestResponse leaveRequestResponse,
  }) = _GetAllLeaveRequestsOutput;
}
