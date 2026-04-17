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
    @Default(1) int currentManagerPage,
    @Default(false) bool hasMoreManagers,
    @Default(false) bool isLoadingMoreManagers,
    @Default(LoadDataStatus.init) LoadDataStatus loadMoreManagersStatus,
    @Default(LoadDataStatus.init) LoadDataStatus createDepartmentStatus,
    String? errorCreateDepartmentMessage,

    @Default([]) List<Department> departments,
    @Default(LoadDataStatus.init) LoadDataStatus getDepartmentStatus,
    @Default(1) int currentPage,
    @Default(false) bool hasMoreData,
    @Default(false) bool isLoadingMore,
    @Default(LoadDataStatus.init) LoadDataStatus loadMoreDepartmentStatus,
    String? errorMessage,

    AppException? loadDataException,
  }) = _CreateDepartmentState;
}

extension CreateDepartmentStateX on CreateDepartmentState {
  bool get isFormValid =>
      departmentName.isNotEmpty && departmentCode.isNotEmpty;
  bool get canLoadMore => hasMoreData && !isLoadingMore;
  bool get canLoadMoreManagers => hasMoreManagers && !isLoadingMoreManagers;
}
