import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

import '../../domain.dart';

part 'get_users_use_case.freezed.dart';

@Injectable()
class GetUsersUseCase
    extends BaseFutureUseCase<GetUsersInput, GetUsersOutput> {
  const GetUsersUseCase(this._repository);

  final Repository _repository;

  @override
  Future<GetUsersOutput> buildUseCase(GetUsersInput input) async {
    return GetUsersOutput(
      users: await _repository.getUsers(
        page: input.page,
        limit: input.limit,
      ),
    );
  }
}

@freezed
class GetUsersInput extends BaseInput with _$GetUsersInput {
  const factory GetUsersInput({
    @Default(1) int page,
    @Default(20) int limit,
  }) = _GetUsersInput;
}

@freezed
class GetUsersOutput extends BaseOutput with _$GetUsersOutput {
  const GetUsersOutput._();

  const factory GetUsersOutput({
    @Default([]) List<User> users,
  }) = _GetUsersOutput;
}
