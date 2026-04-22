import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

import '../../domain.dart';

part 'get_department_detail_use_case.freezed.dart';

@Injectable()
class GetDepartmentDetailUseCase extends BaseFutureUseCase<
    GetDepartmentDetailInput, GetDepartmentDetailOutput> {
  const GetDepartmentDetailUseCase(this._repository);

  final Repository _repository;

  @override
  Future<GetDepartmentDetailOutput> buildUseCase(
      GetDepartmentDetailInput input) async {
    return GetDepartmentDetailOutput(
      department: await _repository.getDepartmentDetail(
        departmentId: input.departmentId,
      ),
    );
  }
}

@freezed
class GetDepartmentDetailInput extends BaseInput
    with _$GetDepartmentDetailInput {
  const factory GetDepartmentDetailInput({
    required String departmentId,
  }) = _GetDepartmentDetailInput;
}

@freezed
class GetDepartmentDetailOutput extends BaseOutput with _$GetDepartmentDetailOutput{
  const GetDepartmentDetailOutput._();

  const factory GetDepartmentDetailOutput({
    required Department department,
  }) = _GetDepartmentDetailOutput;
}
