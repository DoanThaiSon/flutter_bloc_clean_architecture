import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import '../../domain.dart';

part 'delete_department_use_case.freezed.dart';

@Injectable()
class DeleteDepartmentUseCase
    extends BaseFutureUseCase<DeleteDepartmentInput, DeleteDepartmentOutput> {
  const DeleteDepartmentUseCase(this._repository);

  final Repository _repository;

  @protected
  @override
  Future<DeleteDepartmentOutput> buildUseCase(DeleteDepartmentInput input) async {
    await _repository.deleteDepartment(departmentId: input.departmentId);

    return const DeleteDepartmentOutput(success: true);
  }
}

@freezed
class DeleteDepartmentInput extends BaseInput with _$DeleteDepartmentInput {
  const factory DeleteDepartmentInput({
    required String departmentId,
  }) = _DeleteDepartmentInput;
}

@freezed
class DeleteDepartmentOutput extends BaseOutput with _$DeleteDepartmentOutput {
  const DeleteDepartmentOutput._();

  const factory DeleteDepartmentOutput({
    required bool success,
  }) = _DeleteDepartmentOutput;
}
