import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

import '../../domain.dart';

part 'create_department_use_case.freezed.dart';

@Injectable()
class CreateDepartmentUseCase
    extends BaseFutureUseCase<CreateDepartmentInput, CreateDepartmentOutput> {
  const CreateDepartmentUseCase(this._repository);

  final Repository _repository;

  @protected
  @override
  Future<CreateDepartmentOutput> buildUseCase(
      CreateDepartmentInput input) async {
    final response = await _repository.createDepartment(
      name: input.name,
      code: input.code,
      description: input.description,
      managerId: input.managerId,
    );

    return CreateDepartmentOutput(response: response);
  }
}

@freezed
class CreateDepartmentInput extends BaseInput with _$CreateDepartmentInput {
  const factory CreateDepartmentInput({
    required String name,
    required String code,
    String? description,
    String? managerId,
  }) = _CreateDepartmentInput;
}

@freezed
class CreateDepartmentOutput extends BaseOutput with _$CreateDepartmentOutput {
  const CreateDepartmentOutput._();

  const factory CreateDepartmentOutput({
    required Department response,
  }) = _CreateDepartmentOutput;
}
