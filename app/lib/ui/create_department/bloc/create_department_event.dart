import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../app.dart';

part 'create_department_event.freezed.dart';

abstract class CreateDepartmentEvent extends BaseBlocEvent {
  const CreateDepartmentEvent();
}

@freezed
class CreateDepartmentPageInitiated extends CreateDepartmentEvent
    with _$CreateDepartmentPageInitiated {
  const factory CreateDepartmentPageInitiated() =
      _CreateDepartmentPageInitiated;
}

@freezed
class DepartmentNameChanged extends CreateDepartmentEvent
    with _$DepartmentNameChanged {
  const factory DepartmentNameChanged({required String name}) =
      _DepartmentNameChanged;
}

@freezed
class DepartmentCodeChanged extends CreateDepartmentEvent
    with _$DepartmentCodeChanged {
  const factory DepartmentCodeChanged({required String code}) =
      _DepartmentCodeChanged;
}

@freezed
class DepartmentDescriptionChanged extends CreateDepartmentEvent
    with _$DepartmentDescriptionChanged {
  const factory DepartmentDescriptionChanged({required String description}) =
      _DepartmentDescriptionChanged;
}

@freezed
class ManagerSelected extends CreateDepartmentEvent with _$ManagerSelected {
  const factory ManagerSelected({required String managerId}) = _ManagerSelected;
}

@freezed
class GetManagersEvent extends CreateDepartmentEvent with _$GetManagersEvent {
  const factory GetManagersEvent() = _GetManagersEvent;
}

@freezed
class CreateDepartmentButtonPressed extends CreateDepartmentEvent
    with _$CreateDepartmentButtonPressed {
  const factory CreateDepartmentButtonPressed() =
      _CreateDepartmentButtonPressed;
}

@freezed
class ClearCreateDepartmentErrorMessage extends CreateDepartmentEvent
    with _$ClearCreateDepartmentErrorMessage {
  const factory ClearCreateDepartmentErrorMessage() =
      _ClearCreateDepartmentErrorMessage;
}
