import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

import '../../domain.dart';

part 'get_departments_use_case.freezed.dart';

@Injectable()
class GetDepartmentsUseCase
    extends BaseFutureUseCase<GetDepartmentsInput, GetDepartmentsOutput> {
  const GetDepartmentsUseCase(this._repository);

  final Repository _repository;

  @override
  Future<GetDepartmentsOutput> buildUseCase(GetDepartmentsInput input) async {
    return GetDepartmentsOutput(
      departments: await _repository.getDepartments(
        page: input.page,
        limit: input.limit,
        query: input.query,
      ),
    );
  }
}

@freezed
class GetDepartmentsInput extends BaseInput with _$GetDepartmentsInput {
  const factory GetDepartmentsInput(
      {@Default(1) int page,
      @Default(20) int limit,
      String? query}) = _GetDepartmentsInput;
}

@freezed
class GetDepartmentsOutput extends BaseOutput with _$GetDepartmentsOutput {
  const GetDepartmentsOutput._();

  const factory GetDepartmentsOutput({
    @Default([]) List<Department> departments,
  }) = _GetDepartmentsOutput;
}
