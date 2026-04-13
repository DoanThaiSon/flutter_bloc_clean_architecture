import 'package:domain/domain.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../../app.dart';
import 'leave_request.dart';

@Injectable()
class LeaveRequestBloc extends BaseBloc<LeaveRequestEvent, LeaveRequestState> {
  LeaveRequestBloc(
    this._getLeaveRequestsUseCase,
    this._getAllLeaveRequestsUseCase,
    this._getLeaveCodesUseCase,
    this._createLeaveRequestUseCase,
    this._approveLeaveRequestUseCase,
    this._rejectLeaveRequestUseCase,
    this._deleteLeaveRequestUseCase,
    this._updateLeaveRequestUseCase,
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
    on<ApproveLeaveRequestButtonPressed>(
      _onApproveLeaveRequestButtonPressed,
      transformer: log(),
    );
    on<RejectLeaveRequestButtonPressed>(
      _onRejectLeaveRequestButtonPressed,
      transformer: log(),
    );
    on<DeleteLeaveRequestButtonPressed>(
      _onDeleteLeaveRequestButtonPressed,
      transformer: log(),
    );
    on<UpdateLeaveRequestButtonPressed>(
      _onUpdateLeaveRequestButtonPressed,
      transformer: log(),
    );
    on<LoadLeaveRequestForEdit>(
      _onLoadLeaveRequestForEdit,
      transformer: log(),
    );
  }

  final GetLeaveRequestsUseCase _getLeaveRequestsUseCase;
  final GetAllLeaveRequestsUseCase _getAllLeaveRequestsUseCase;
  final GetLeaveCodesUseCase _getLeaveCodesUseCase;
  final CreateLeaveRequestUseCase _createLeaveRequestUseCase;
  final ApproveLeaveRequestUseCase _approveLeaveRequestUseCase;
  final RejectLeaveRequestUseCase _rejectLeaveRequestUseCase;
  final DeleteLeaveRequestUseCase _deleteLeaveRequestUseCase;
  final UpdateLeaveRequestUseCase _updateLeaveRequestUseCase;

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

          // Load pending count first
          final pendingOutput = await _getAllLeaveRequestsUseCase.execute(
            const GetAllLeaveRequestsInput(
                page: 1, limit: 100, status: 'pending'),
          );
          final pendingCount = pendingOutput.leaveRequestResponse.data.length;

          // Load data based on selected tab (default is tab 0 - "Tất cả")
          await _loadLeaveRequestsByTab(state.selectedTabIndex, emit);

          emit(state.copyWith(
            pendingCount: pendingCount,
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
        handleLoading: false,
        doOnSubscribe: () async => emit(state.copyWith(
              getLeaveRequestResponseStatus: LoadDataStatus.init,
            )),
        action: () async {
          emit(state.copyWith(
            selectedTabIndex: event.tabIndex,
            getLeaveRequestResponseStatus: LoadDataStatus.loading,
          ));

          await _loadLeaveRequestsByTab(event.tabIndex, emit);

          emit(state.copyWith(
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

  Future<void> _loadLeaveRequestsByTab(
    int tabIndex,
    Emitter<LeaveRequestState> emit,
  ) async {
    LeaveRequestResponse response;

    if (tabIndex == 0) {
      // Tab "Tất cả" - call API /leave-requests/all
      final output = await _getAllLeaveRequestsUseCase.execute(
        const GetAllLeaveRequestsInput(page: 1, limit: 100),
      );
      response = output.leaveRequestResponse;
    } else if (tabIndex == 2) {
      // Tab "Cần duyệt" - call API /leave-requests/all with status=pending
      final output = await _getAllLeaveRequestsUseCase.execute(
        const GetAllLeaveRequestsInput(page: 1, limit: 100, status: 'pending'),
      );
      response = output.leaveRequestResponse;
    } else {
      // Tab "Của tôi" (1) - call API /leave-requests/my-requests
      final output = await _getLeaveRequestsUseCase.execute(
        const GetLeaveRequestsInput(page: 1, limit: 100),
      );
      response = output.leaveRequestResponse;
    }

    emit(state.copyWith(leaveRequests: response));
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

    // Determine which date fields to keep based on new leave type
    if (event.leaveType == 'Nghỉ nhiều ngày') {
      // Switching to multi-day: keep startDate/endDate, clear selectedDate
      emit(state.copyWith(
        selectedLeaveType: event.leaveType,
        selectedShift: shift,
        selectedDate: null,
        // Keep startDate, endDate, reason, selectedLeaveCode
      ));
    } else {
      // Switching to single day or half day: keep selectedDate, clear startDate/endDate
      emit(state.copyWith(
        selectedLeaveType: event.leaveType,
        selectedShift: shift,
        startDate: null,
        endDate: null,
        // Keep selectedDate, reason, selectedLeaveCode
      ));
    }
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

    // Only update leave code, don't reset other fields
    emit(state.copyWith(
      selectedLeaveCode: event.leaveCode,
      selectedLeaveCodeId: leaveCode.id.isNotEmpty ? leaveCode.id : null,
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
          emit(
              state.copyWith(createLeaveRequestStatus: LoadDataStatus.success));
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
          await navigator.pop(result: true, useRootNavigator: true);
          emit(state.copyWith(
            createLeaveRequestStatus: LoadDataStatus.init,
          ));
        });
  }

  Future<void> _onApproveLeaveRequestButtonPressed(
    ApproveLeaveRequestButtonPressed event,
    Emitter<LeaveRequestState> emit,
  ) async {
    await runBlocCatching(
      action: () async {
        await _approveLeaveRequestUseCase.execute(
          ApproveLeaveRequestInput(leaveRequestId: event.leaveRequestId),
        );

        await _onLeaveRequestTabChanged(
          LeaveRequestTabChanged(tabIndex: state.selectedTabIndex),
          emit,
        );
      },
      handleLoading: true,
      handleError: true,
    );
  }

  Future<void> _onRejectLeaveRequestButtonPressed(
    RejectLeaveRequestButtonPressed event,
    Emitter<LeaveRequestState> emit,
  ) async {
    await runBlocCatching(
      action: () async {
        await _rejectLeaveRequestUseCase.execute(
          RejectLeaveRequestInput(
            leaveRequestId: event.leaveRequestId,
            rejectionReason: event.rejectionReason,
          ),
        );

        // Reload data for current tab
        await _onLeaveRequestTabChanged(
          LeaveRequestTabChanged(tabIndex: state.selectedTabIndex),
          emit,
        );
      },
      handleLoading: true,
      handleError: true,
    );
  }

  Future<void> _onDeleteLeaveRequestButtonPressed(
    DeleteLeaveRequestButtonPressed event,
    Emitter<LeaveRequestState> emit,
  ) async {
    await runBlocCatching(
        handleLoading: false,
        doOnSubscribe: () async => emit(
              state.copyWith(
                deleteLeaveRequestStatus: LoadDataStatus.init,
              ),
            ),
        action: () async {
          emit(state.copyWith(
            deleteLeaveRequestStatus: LoadDataStatus.loading,
          ));
          await _deleteLeaveRequestUseCase.execute(
            DeleteLeaveRequestInput(
              leaveRequestId: event.leaveRequestId,
            ),
          );
          emit(
              state.copyWith(deleteLeaveRequestStatus: LoadDataStatus.success));
          await _onLeaveRequestTabChanged(
            LeaveRequestTabChanged(tabIndex: state.selectedTabIndex),
            emit,
          );
        },
        handleError: true,
        doOnError: (e) async {
          emit(
            state.copyWith(
                loadDataException: e,
                deleteLeaveRequestStatus: LoadDataStatus.fail),
          );
        },
        doOnEventCompleted: () async {
          emit(state.copyWith(
            deleteLeaveRequestStatus: LoadDataStatus.init,
          ));
        });
  }

  Future<void> _onUpdateLeaveRequestButtonPressed(
    UpdateLeaveRequestButtonPressed event,
    Emitter<LeaveRequestState> emit,
  ) async {
    await runBlocCatching(
        handleLoading: false,
        doOnSubscribe: () async => emit(
              state.copyWith(
                updateLeaveRequestStatus: LoadDataStatus.init,
              ),
            ),
        action: () async {
          emit(state.copyWith(
            updateLeaveRequestStatus: LoadDataStatus.loading,
          ));
          final selectedLeaveCode = state.leaveCodes.firstWhere(
            (code) => code.name == state.selectedLeaveCode,
          );

          String dayType;
          String shift;

          if (state.selectedLeaveType == 'Nghỉ 1 ngày' ||
              state.selectedLeaveType == 'Nghỉ nhiều ngày') {
            dayType = 'full_day';
            shift = 'full_day';
          } else {
            dayType = 'half_day';
            shift = state.selectedShift == 'Ca sáng' ? 'morning' : 'afternoon';
          }

          String startDate;
          String endDate;

          if (state.selectedLeaveType == 'Nghỉ nhiều ngày') {
            startDate = _formatDateForApi(state.startDate!);
            endDate = _formatDateForApi(state.endDate!);
          } else {
            startDate = _formatDateForApi(state.selectedDate!);
            endDate = _formatDateForApi(state.selectedDate!);
          }

          await _updateLeaveRequestUseCase.execute(
            UpdateLeaveRequestInput(
              leaveRequestId: event.leaveRequestId,
              dayType: dayType,
              shift: shift,
              leaveCodeId: selectedLeaveCode.id,
              startDate: startDate,
              endDate: endDate,
              reason: state.reason ?? '',
            ),
          );
          emit(
              state.copyWith(updateLeaveRequestStatus: LoadDataStatus.success));
        },
        handleError: true,
        doOnError: (e) async {
          emit(
            state.copyWith(
                loadDataException: e,
                updateLeaveRequestStatus: LoadDataStatus.fail),
          );
        },
        doOnEventCompleted: () async {
          await navigator.pop(result: true, useRootNavigator: true);
          emit(state.copyWith(
            updateLeaveRequestStatus: LoadDataStatus.init,
          ));
        });
  }

  String _formatDateForApi(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  void _onLoadLeaveRequestForEdit(
    LoadLeaveRequestForEdit event,
    Emitter<LeaveRequestState> emit,
  ) {
    emit(state.copyWith(
      selectedLeaveType: event.leaveType,
      selectedShift: event.shift,
      selectedLeaveCode: event.leaveCodeName,
      selectedLeaveCodeId: event.leaveCodeId,
      selectedDate: event.selectedDate,
      startDate: event.startDate,
      endDate: event.endDate,
      reason: event.reason,
    ));
  }
}
