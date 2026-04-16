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
  CreateDepartmentBloc(
    this._getManagersUseCase,
    this._createDepartmentUseCase,
  ) : super(const CreateDepartmentState()) {
    on<CreateDepartmentPageInitiated>(
      _onPageInitiated,
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
    on<CreateDepartmentButtonPressed>(
      _onCreateDepartmentButtonPressed,
      transformer: log(),
    );
    on<ClearCreateDepartmentErrorMessage>(
      _onClearCreateDepartmentErrorMessage,
      transformer: log(),
    );

  }

  final GetManagersUseCase _getManagersUseCase;
  final CreateDepartmentUseCase _createDepartmentUseCase;

  FutureOr<void> _onPageInitiated(
    CreateDepartmentPageInitiated event,
    Emitter<CreateDepartmentState> emit,
  ) async {
    add(const GetManagersEvent());
  }

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
      // selectedManagerName: manager.username,
    ));
  }

  FutureOr<void> _onGetManagers(
    GetManagersEvent event,
    Emitter<CreateDepartmentState> emit,
  ) async {
    await runBlocCatching(
      action: () async {
        emit(state.copyWith(loadManagersStatus: LoadDataStatus.loading));
        final managers = await _getManagersUseCase();
        emit(state.copyWith(
          managers: managers,
          loadManagersStatus: LoadDataStatus.success,
        ));
      },
      doOnError: (e) async {
        emit(state.copyWith(
          loadManagersStatus: LoadDataStatus.fail,
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
}
