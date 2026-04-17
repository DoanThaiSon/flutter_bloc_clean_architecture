import 'dart:async';
import 'package:domain/domain.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:shared/shared.dart';
import '../../../app.dart';
import 'create_department_event.dart';
import 'create_department_state.dart';

@Injectable()
class CreateDepartmentBloc
    extends BaseBloc<CreateDepartmentEvent, CreateDepartmentState> {
  CreateDepartmentBloc(this._getUsersUseCase, this._createDepartmentUseCase,
      this._getDepartmentsUseCase)
      : super(const CreateDepartmentState()) {
    on<LoadDepartments>(
      _onLoadDepartments,
      transformer: log(),
    );
    on<LoadMoreDepartments>(
      _onLoadMoreDepartments,
      transformer: log(),
    );
    on<DepartmentNameChanged>(
      _onDepartmentNameChanged,
      transformer: log(),
    );
    on<DepartmentCodeChanged>(
      _onDepartmentCodeChanged,
      transformer: log(),
    );
    on<DepartmentDescriptionChanged>(
      _onDepartmentDescriptionChanged,
      transformer: log(),
    );
    on<ManagerSelected>(
      _onManagerSelected,
      transformer: log(),
    );
    on<GetManagersEvent>(
      _onGetManagers,
      transformer: log(),
    );
    on<LoadMoreManagers>(
      _onLoadMoreManagers,
      transformer: log(),
    );
    on<CreateDepartmentButtonPressed>(
      _onCreateDepartmentButtonPressed,
      transformer: log(),
    );
    on<ClearCreateDepartmentErrorMessage>(
      _onClearCreateDepartmentErrorMessage,
      transformer: log(),
    );
  }

  final GetUsersUseCase _getUsersUseCase;
  final CreateDepartmentUseCase _createDepartmentUseCase;
  final GetDepartmentsUseCase _getDepartmentsUseCase;
  static const int _limit = 20;

  FutureOr<void> _onDepartmentNameChanged(
    DepartmentNameChanged event,
    Emitter<CreateDepartmentState> emit,
  ) {
    emit(state.copyWith(departmentName: event.name));
  }

  FutureOr<void> _onDepartmentCodeChanged(
    DepartmentCodeChanged event,
    Emitter<CreateDepartmentState> emit,
  ) {
    emit(state.copyWith(departmentCode: event.code));
  }

  FutureOr<void> _onDepartmentDescriptionChanged(
    DepartmentDescriptionChanged event,
    Emitter<CreateDepartmentState> emit,
  ) {
    emit(state.copyWith(description: event.description));
  }

  FutureOr<void> _onManagerSelected(
    ManagerSelected event,
    Emitter<CreateDepartmentState> emit,
  ) {
    final manager = state.managers.firstWhere(
      (m) => m.id == event.managerId,
      orElse: () => const User(),
    );
    emit(state.copyWith(
      selectedManagerId: event.managerId,
      selectedManagerName: manager.name,
    ));
  }

  FutureOr<void> _onGetManagers(
    GetManagersEvent event,
    Emitter<CreateDepartmentState> emit,
  ) async {
    await runBlocCatching(
      handleLoading: false,
      doOnSubscribe: () async => emit(
        state.copyWith(
          loadManagersStatus: LoadDataStatus.init,
        ),
      ),
      action: () async {
        emit(state.copyWith(loadManagersStatus: LoadDataStatus.loading));
        final output = await _getUsersUseCase.execute(
          const GetUsersInput(page: 1, limit: _limit),
        );
        emit(state.copyWith(
          managers: output.users,
          loadManagersStatus: LoadDataStatus.success,
          currentManagerPage: 1,
          hasMoreManagers: output.users.length == _limit,
        ));
      },
      doOnError: (e) async {
        emit(state.copyWith(
          loadManagersStatus: LoadDataStatus.fail,
        ));
      },
      doOnEventCompleted: () async {
        emit(state.copyWith(
          loadManagersStatus: LoadDataStatus.init,
        ));
      },
    );
  }



  FutureOr<void> _onCreateDepartmentButtonPressed(
    CreateDepartmentButtonPressed event,
    Emitter<CreateDepartmentState> emit,
  ) async {
    await runBlocCatching(
        handleLoading: false,
        doOnSubscribe: () async => emit(state.copyWith(
              createDepartmentStatus: LoadDataStatus.init,
            )),
        action: () async {
          emit(state.copyWith(createDepartmentStatus: LoadDataStatus.loading));
          await _createDepartmentUseCase.execute(CreateDepartmentInput(
            name: state.departmentName,
            code: state.departmentCode,
            description: state.description,
            managerId: state.selectedManagerId,
          ));
          emit(state.copyWith(
            createDepartmentStatus: LoadDataStatus.success,
          ));
        },
        handleError: false,
        doOnError: (e) async {
          String errorMessage = 'Có lỗi xảy ra';
          if (e is RemoteException) {
            errorMessage = e.generalServerMessage ?? 'Có lỗi xảy ra';
          }
          emit(
            state.copyWith(
                loadDataException: e,
                createDepartmentStatus: LoadDataStatus.fail,
                errorCreateDepartmentMessage: errorMessage),
          );
        },
        doOnEventCompleted: () async {
          await navigator.pop(result: true, useRootNavigator: true);
          emit(state.copyWith(
            createDepartmentStatus: LoadDataStatus.init,
          ));
        });
  }

  Future<void> _onClearCreateDepartmentErrorMessage(
    ClearCreateDepartmentErrorMessage event,
    Emitter<CreateDepartmentState> emit,
  ) async {
    emit(state.copyWith(errorCreateDepartmentMessage: null));
  }

  FutureOr<void> _onLoadDepartments(
    LoadDepartments event,
    Emitter<CreateDepartmentState> emit,
  ) async {
    await runBlocCatching(
        handleLoading: false,
        doOnSubscribe: () async => emit(
              state.copyWith(
                getDepartmentStatus: LoadDataStatus.init,
              ),
            ),
        action: () async {
          emit(state.copyWith(
            getDepartmentStatus: LoadDataStatus.loading,
          ));

          final output = await _getDepartmentsUseCase.execute(
            const GetDepartmentsInput(page: 1, limit: _limit),
          );

          emit(state.copyWith(
            departments: output.departments,
            getDepartmentStatus: LoadDataStatus.success,
            currentPage: 1,
            hasMoreData: output.departments.length == _limit,
            errorMessage: null,
          ));
        },
        doOnError: (e) async {
          emit(state.copyWith(
            getDepartmentStatus: LoadDataStatus.fail,
            errorMessage: e.toString(),
          ));
        },
        doOnEventCompleted: () async {
          emit(state.copyWith(
            getDepartmentStatus: LoadDataStatus.init,
          ));
        });
  }

  FutureOr<void> _onLoadMoreDepartments(
    LoadMoreDepartments event,
    Emitter<CreateDepartmentState> emit,
  ) async {
    if (!state.canLoadMore) {
      return;
    }
    await runBlocCatching(
      handleLoading: false,
      doOnSubscribe: () async {
        emit(
          state.copyWith(
            loadMoreDepartmentStatus: LoadDataStatus.init,
            isLoadingMore: true,
          ),
        );
      },
      action: () async {
        emit(state.copyWith(
          loadMoreDepartmentStatus: LoadDataStatus.loading,
        ));

        final nextPage = state.currentPage + 1;

        final output = await _getDepartmentsUseCase.execute(
          GetDepartmentsInput(page: nextPage, limit: _limit),
        );

        emit(state.copyWith(
          departments: [...state.departments, ...output.departments],
          currentPage: nextPage,
          hasMoreData: output.departments.length == _limit,
          loadMoreDepartmentStatus: LoadDataStatus.success,
        ));
      },
      doOnError: (e) async {
        emit(state.copyWith(
            loadDataException: e,
            isLoadingMore: false,
            errorMessage: e.toString(),
            loadMoreDepartmentStatus: LoadDataStatus.fail));
      },
      doOnEventCompleted: () async {
        emit(state.copyWith(
          loadMoreDepartmentStatus: LoadDataStatus.init,
          isLoadingMore: false,
        ));
      },
    );
  }

  FutureOr<void> _onLoadMoreManagers(
    LoadMoreManagers event,
    Emitter<CreateDepartmentState> emit,
  ) async {
    if (!state.canLoadMoreManagers) {
      return;
    }
    await runBlocCatching(
      handleLoading: false,
      doOnSubscribe: () async {
        emit(
          state.copyWith(
            loadMoreManagersStatus: LoadDataStatus.init,
            isLoadingMoreManagers: true,
          ),
        );
      },
      action: () async {
        emit(state.copyWith(
          loadMoreManagersStatus: LoadDataStatus.loading,
        ));

        final nextPage = state.currentManagerPage + 1;

        final output = await _getUsersUseCase.execute(
          GetUsersInput(page: nextPage, limit: _limit),
        );

        emit(state.copyWith(
          managers: [...state.managers, ...output.users],
          currentManagerPage: nextPage,
          hasMoreManagers: output.users.length == _limit,
          loadMoreManagersStatus: LoadDataStatus.success,
        ));
      },
      doOnError: (e) async {
        emit(state.copyWith(
          loadDataException: e,
          isLoadingMoreManagers: false,
          loadMoreManagersStatus: LoadDataStatus.fail,
        ));
      },
      doOnEventCompleted: () async {
        emit(state.copyWith(
          loadMoreManagersStatus: LoadDataStatus.init,
          isLoadingMoreManagers: false,
        ));
      },
    );
  }
}
