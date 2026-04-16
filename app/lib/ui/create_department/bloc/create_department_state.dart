import 'package:domain/domain.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:shared/shared.dart';
import '../../../app.dart';

part 'create_department_state.freezed.dart';

@freezed
class CreateDepartmentState extends BaseBlocState with _$CreateDepartmentState {
  const factory CreateDepartmentState({
    @Default('') String departmentName,
    @Default('') String departmentCode,
    String? description,
    String? selectedManagerId,
    String? selectedManagerName,
    @Default([]) List<User> managers,
    @Default(LoadDataStatus.init) LoadDataStatus loadManagersStatus,
    @Default(LoadDataStatus.init) LoadDataStatus createDepartmentStatus,
    String? errorCreateDepartmentMessage,
    AppException? loadDataException,
  }) = _CreateDepartmentState;
}

extension CreateDepartmentStateX on CreateDepartmentState {
  bool get isFormValid =>
      departmentName.isNotEmpty && departmentCode.isNotEmpty;
}
