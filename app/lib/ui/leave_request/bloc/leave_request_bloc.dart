import 'package:domain/domain.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../../app.dart';
import 'leave_request.dart';

@Injectable()
class LeaveRequestBloc extends BaseBloc<LeaveRequestEvent, LeaveRequestState> {
  LeaveRequestBloc(
    this._getLeaveRequestsUseCase,
    this._getLeaveCodesUseCase,
    this._createLeaveRequestUseCase,
  ) : super(const LeaveRequestState()) {
    on<LeaveRequestPageInitiated>(
      _onLeaveRequestPageInitiated,
      transformer: log(),
    );

    on<LeaveRequestTabChanged>(
      _onLeaveRequestTabChanged,
      transformer: log(),
    );
    on<GetLeaveCodes>(
      _onGetLeaveCodes,
      transformer: log(),
    );
    on<LeaveTypeChanged>(
      _onLeaveTypeChanged,
      transformer: log(),
    );
    on<ShiftChanged>(
      _onShiftChanged,
      transformer: log(),
    );
    on<LeaveCodeChanged>(
      _onLeaveCodeChanged,
      transformer: log(),
    );
    on<DateChanged>(
      _onDateChanged,
      transformer: log(),
    );
    on<StartDateChanged>(
      _onStartDateChanged,
      transformer: log(),
    );
    on<EndDateChanged>(
      _onEndDateChanged,
      transformer: log(),
    );
    on<ReasonChanged>(
      _onReasonChanged,
      transformer: log(),
    );
    on<SubmitButtonPressed>(
      _onSubmitButtonPressed,
      transformer: log(),
    );
  }

  final GetLeaveRequestsUseCase _getLeaveRequestsUseCase;
  final GetLeaveCodesUseCase _getLeaveCodesUseCase;
  final CreateLeaveRequestUseCase _createLeaveRequestUseCase;

  Future<void> _onLeaveRequestPageInitiated(
    LeaveRequestPageInitiated event,
    Emitter<LeaveRequestState> emit,
  ) async {
    await runBlocCatching(
        handleLoading: false,
        doOnSubscribe: () async => emit(state.copyWith(
              getLeaveRequestResponseStatus: LoadDataStatus.init,
            )),
        action: () async {
          emit(state.copyWith(
            getLeaveRequestResponseStatus: LoadDataStatus.loading,
          ));
          final output = await _getLeaveRequestsUseCase.execute(
            const GetLeaveRequestsInput(page: 1, limit: 10),
          );
          emit(state.copyWith(
            leaveRequests: output.leaveRequestResponse,
            getLeaveRequestResponseStatus: LoadDataStatus.success,
          ));
        },
        handleError: true,
        doOnError: (e) async {
          emit(
            state.copyWith(
                loadDataException: e,
                getLeaveRequestResponseStatus: LoadDataStatus.fail),
          );
        },
        doOnEventCompleted: () async {
          emit(state.copyWith(
            getLeaveRequestResponseStatus: LoadDataStatus.init,
          ));
        });
  }

  Future<void> _onLeaveRequestTabChanged(
    LeaveRequestTabChanged event,
    Emitter<LeaveRequestState> emit,
  ) async {
    await runBlocCatching(
      action: () async {
        emit(state.copyWith(selectedTabIndex: event.tabIndex));
      },
    );
  }

  Future<void> _onGetLeaveCodes(
    GetLeaveCodes event,
    Emitter<LeaveRequestState> emit,
  ) async {
    await runBlocCatching(
        handleLoading: false,
        doOnSubscribe: () async => emit(
              state.copyWith(
                getLeaveCodesStatus: LoadDataStatus.init,
              ),
            ),
        action: () async {
          emit(state.copyWith(
            getLeaveCodesStatus: LoadDataStatus.loading,
          ));

          final output = await _getLeaveCodesUseCase.execute(
            const GetLeaveCodesInput(),
          );

          emit(state.copyWith(
              leaveCodes: output.leaveCodeResponse.data,
              getLeaveCodesStatus: LoadDataStatus.success));
        },
        handleError: true,
        doOnError: (e) async {
          emit(
            state.copyWith(
                loadDataException: e, getLeaveCodesStatus: LoadDataStatus.fail),
          );
        },
        doOnEventCompleted: () async {
          emit(state.copyWith(
            getLeaveCodesStatus: LoadDataStatus.init,
          ));
        });
  }

  void _onLeaveTypeChanged(
    LeaveTypeChanged event,
    Emitter<LeaveRequestState> emit,
  ) {
    String? shift;
    if (event.leaveType == 'Nghỉ 1 ngày' ||
        event.leaveType == 'Nghỉ nhiều ngày') {
      shift = 'Cả ngày';
    }

    emit(state.copyWith(
      selectedLeaveType: event.leaveType,
      selectedShift: shift,
      selectedLeaveCode: null,
      selectedDate: null,
      startDate: null,
      endDate: null,
      reason: null,
    ));
  }

  void _onShiftChanged(
    ShiftChanged event,
    Emitter<LeaveRequestState> emit,
  ) {
    emit(state.copyWith(selectedShift: event.shift));
  }

  void _onLeaveCodeChanged(
    LeaveCodeChanged event,
    Emitter<LeaveRequestState> emit,
  ) {
    final leaveCode = state.leaveCodes.firstWhere(
      (code) => code.name == event.leaveCode,
      orElse: () => const LeaveCode(),
    );

    emit(state.copyWith(
      selectedLeaveCode: event.leaveCode,
      selectedLeaveCodeId: leaveCode.id.isNotEmpty ? leaveCode.id : null,
      selectedDate: null,
      startDate: null,
      endDate: null,
      reason: null,
    ));
  }

  void _onDateChanged(
    DateChanged event,
    Emitter<LeaveRequestState> emit,
  ) {
    emit(state.copyWith(selectedDate: event.date));
  }

  void _onStartDateChanged(
    StartDateChanged event,
    Emitter<LeaveRequestState> emit,
  ) {
    emit(state.copyWith(
      startDate: event.date,
      endDate: null,
    ));
  }

  void _onEndDateChanged(
    EndDateChanged event,
    Emitter<LeaveRequestState> emit,
  ) {
    emit(state.copyWith(endDate: event.date));
  }

  void _onReasonChanged(
    ReasonChanged event,
    Emitter<LeaveRequestState> emit,
  ) {
    emit(state.copyWith(reason: event.reason));
  }

  Future<void> _onSubmitButtonPressed(
    SubmitButtonPressed event,
    Emitter<LeaveRequestState> emit,
  ) async {
    await runBlocCatching(
        handleLoading: false,
        doOnSubscribe: () async => emit(
              state.copyWith(
                createLeaveRequestStatus: LoadDataStatus.init,
              ),
            ),
        action: () async {
          emit(state.copyWith(
            createLeaveRequestStatus: LoadDataStatus.loading,
          ));
          if (!state.isFormValid) {
            return;
          }
          String dayType = 'full_day';
          if (state.selectedLeaveType == 'Nghỉ nửa ngày') {
            dayType = 'half_day';
          } else if (state.selectedLeaveType == 'Nghỉ nhiều ngày') {
            dayType = 'multiple_days';
          }

          // Map shift
          String shift = 'full_day';
          if (state.selectedShift == 'Ca sáng') {
            shift = 'morning';
          } else if (state.selectedShift == 'Ca chiều') {
            shift = 'afternoon';
          }

          // Format dates
          String startDate;
          String endDate;

          if (state.selectedLeaveType == 'Nghỉ nhiều ngày') {
            startDate = _formatDateForApi(state.startDate!);
            endDate = _formatDateForApi(state.endDate!);
          } else {
            startDate = _formatDateForApi(state.selectedDate!);
            endDate = _formatDateForApi(state.selectedDate!);
          }

          await _createLeaveRequestUseCase.execute(
            CreateLeaveRequestInput(
              dayType: dayType,
              shift: shift,
              leaveCodeId: state.selectedLeaveCodeId!,
              startDate: startDate,
              endDate: endDate,
              reason: state.reason!,
            ),
          );

          // final output = await _getLeaveCodesUseCase.execute(
          //   const GetLeaveCodesInput(),
          // );

          emit(state.copyWith(
              // leaveCodes: output.response.,
              createLeaveRequestStatus: LoadDataStatus.success));
        },
        handleError: true,
        doOnError: (e) async {
          emit(
            state.copyWith(
                loadDataException: e,
                createLeaveRequestStatus: LoadDataStatus.fail),
          );
        },
        doOnEventCompleted: () async {
          navigator.pop(result: true, useRootNavigator: true);
          emit(state.copyWith(
            createLeaveRequestStatus: LoadDataStatus.init,
          ));
        });
  }

  String _formatDateForApi(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }
}
