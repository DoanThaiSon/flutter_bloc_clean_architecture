import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import '../../domain.dart';

part 'update_department_use_case.freezed.dart';

@Injectable()
class UpdateDepartmentUseCase
    extends BaseFutureUseCase<UpdateDepartmentInput, UpdateDepartmentOutput> {
  const UpdateDepartmentUseCase(this._repository);

  final Repository _repository;

  @protected
  @override
  Future<UpdateDepartmentOutput> buildUseCase(UpdateDepartmentInput input) async {
    final department = await _repository.updateDepartment(
      departmentId: input.departmentId,
      name: input.name,
      code: input.code,
      description: input.description,
      managerId: input.managerId,
    );
    return UpdateDepartmentOutput(department: department);
  }
}

@freezed
class UpdateDepartmentInput extends BaseInput with _$UpdateDepartmentInput {
  const factory UpdateDepartmentInput({
    required String departmentId,
    required String name,
    required String code,
    String? description,
    String? managerId,
  }) = _UpdateDepartmentInput;
}

@freezed
class UpdateDepartmentOutput extends BaseOutput with _$UpdateDepartmentOutput {
  const UpdateDepartmentOutput._();

  const factory UpdateDepartmentOutput({
    required Department department,
  }) = _UpdateDepartmentOutput;
}
