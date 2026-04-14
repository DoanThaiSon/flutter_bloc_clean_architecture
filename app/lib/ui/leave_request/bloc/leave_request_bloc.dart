import 'package:domain/domain.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:resources/resources.dart';
import 'package:shared/shared.dart';
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
    this._repository,
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
    on<LoadMoreLeaveRequests>(
      _onLoadMoreLeaveRequests,
      transformer: log(),
    );
    on<ClearUpdateLeaveRequestErrorMessage>(
      _onClearUpdateLeaveRequestErrorMessage,
      transformer: log(),
    );
    on<ClearCreateLeaveRequestErrorMessage>(
      _onClearCreateLeaveRequestErrorMessage,
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
  final Repository _repository;

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
          final user = _repository.getUserPreference();

          final defaultTab = user.role == 'user' ? 1 : 0;

          emit(state.copyWith(
            currentUser: user,
            selectedTabIndex: defaultTab,
            currentPage: 1,
            hasMoreData: false,
            getLeaveRequestResponseStatus: LoadDataStatus.loading,
          ));

          if (user.role != 'user') {
            await _updatePendingCount(emit);
          }

          await _loadLeaveRequestsByTab(defaultTab, emit, page: 1);

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
            currentPage: 1,
            hasMoreData: false,
          ));

          if (state.currentUser?.role != 'user') {
            await _updatePendingCount(emit);
          }

          await _loadLeaveRequestsByTab(event.tabIndex, emit, page: 1);

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
    Emitter<LeaveRequestState> emit, {
    required int page,
    bool isLoadMore = false,
  }) async {
    LeaveRequestResponse response;
    const limit = 20;

    if (tabIndex == 0) {
      final output = await _getAllLeaveRequestsUseCase.execute(
        GetAllLeaveRequestsInput(page: page, limit: limit),
      );
      response = output.leaveRequestResponse;
    } else if (tabIndex == 2) {
      final output = await _getAllLeaveRequestsUseCase.execute(
        GetAllLeaveRequestsInput(page: page, limit: limit, status: 'pending'),
      );
      response = output.leaveRequestResponse;
    } else {
      final output = await _getLeaveRequestsUseCase.execute(
        GetLeaveRequestsInput(page: page, limit: limit),
      );
      response = output.leaveRequestResponse;
    }

    final hasMore = response.data.length >= limit;

    if (isLoadMore) {
      final currentData = state.leaveRequests?.data ?? [];
      final updatedResponse = response.copyWith(
        data: [...currentData, ...response.data],
      );
      emit(state.copyWith(
        leaveRequests: updatedResponse,
        currentPage: page,
        hasMoreData: hasMore,
      ));
    } else {
      emit(state.copyWith(
        leaveRequests: response,
        currentPage: page,
        hasMoreData: hasMore,
      ));
    }
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
    Shift? shift;
    if (event.leaveType == LeaveType.oneDay ||
        event.leaveType == LeaveType.multipleDays) {
      shift = Shift.fullDay;
    }

    if (event.leaveType == LeaveType.multipleDays) {
      emit(state.copyWith(
        selectedLeaveType: event.leaveType,
        selectedShift: shift,
        selectedDate: null,
      ));
    } else {
      emit(state.copyWith(
        selectedLeaveType: event.leaveType,
        selectedShift: shift,
        startDate: null,
        endDate: null,
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

          final dayType = state.selectedLeaveType!.apiValue;
          final shift = state.selectedShift!.apiValue;

          String startDate;
          String endDate;

          if (state.selectedLeaveType == LeaveType.multipleDays) {
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
        handleError: false,
        doOnError: (e) async {
          String errorMessage = 'Có lỗi xảy ra';
          if (e is RemoteException) {
            errorMessage = e.generalServerMessage ?? 'Có lỗi xảy ra';
          }
          emit(
            state.copyWith(
                loadDataException: e,
                createLeaveRequestStatus: LoadDataStatus.fail,
            createLeaveRequestErrorMessage: errorMessage),
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
        handleLoading: false,
        doOnSubscribe: () async => emit(
              state.copyWith(
                approveLeaveRequestStatus: LoadDataStatus.init,
              ),
            ),
        action: () async {
          emit(state.copyWith(
            approveLeaveRequestStatus: LoadDataStatus.loading,
          ));
          await _approveLeaveRequestUseCase.execute(
            ApproveLeaveRequestInput(leaveRequestId: event.leaveRequestId),
          );
          emit(state.copyWith(
              approveLeaveRequestStatus: LoadDataStatus.success));
          await _updatePendingCount(emit);

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
                approveLeaveRequestStatus: LoadDataStatus.fail),
          );
        },
        doOnEventCompleted: () async {
          emit(state.copyWith(
            approveLeaveRequestStatus: LoadDataStatus.init,
          ));
        });
  }

  Future<void> _onRejectLeaveRequestButtonPressed(
    RejectLeaveRequestButtonPressed event,
    Emitter<LeaveRequestState> emit,
  ) async {
    await runBlocCatching(
        handleLoading: false,
        doOnSubscribe: () async => emit(
              state.copyWith(
                rejectLeaveRequestStatus: LoadDataStatus.init,
              ),
            ),
        action: () async {
          emit(state.copyWith(
            rejectLeaveRequestStatus: LoadDataStatus.loading,
          ));

          await _rejectLeaveRequestUseCase.execute(
            RejectLeaveRequestInput(
              leaveRequestId: event.leaveRequestId,
              rejectionReason: event.rejectionReason,
            ),
          );
          emit(
              state.copyWith(rejectLeaveRequestStatus: LoadDataStatus.success));

          await _updatePendingCount(emit);

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
                rejectLeaveRequestStatus: LoadDataStatus.fail),
          );
        },
        doOnEventCompleted: () async {
          emit(state.copyWith(
            rejectLeaveRequestStatus: LoadDataStatus.init,
          ));
        });
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
          await Future.delayed(Duration.zero);
          emit(state.copyWith(deleteLeaveRequestStatus: LoadDataStatus.init));

          await _updatePendingCount(emit);
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

          final dayType = state.selectedLeaveType!.apiValue;
          final shift = state.selectedShift!.apiValue;

          String startDate;
          String endDate;

          if (state.selectedLeaveType == LeaveType.multipleDays) {
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
        handleError: false,
        doOnError: (e) async {
          String errorMessage = 'Có lỗi xảy ra';
          if (e is RemoteException) {
            errorMessage = e.generalServerMessage ?? 'Có lỗi xảy ra';
          }
          emit(
            state.copyWith(
                loadDataException: e,
                updateLeaveRequestStatus: LoadDataStatus.fail,
                updateLeaveRequestErrorMessage: errorMessage),
          );
        },
        doOnEventCompleted: () async {
          await navigator.pop(result: true, useRootNavigator: true);
          emit(state.copyWith(
            updateLeaveRequestStatus: LoadDataStatus.init,
          ));
        });
  }

  Future<void> _onClearUpdateLeaveRequestErrorMessage(
    ClearUpdateLeaveRequestErrorMessage event,
    Emitter<LeaveRequestState> emit,
  ) async {
    emit(state.copyWith(updateLeaveRequestErrorMessage: null));
  }

  Future<void> _onClearCreateLeaveRequestErrorMessage(
    ClearCreateLeaveRequestErrorMessage event,
    Emitter<LeaveRequestState> emit,
  ) async {
    emit(state.copyWith(createLeaveRequestErrorMessage: null));
  }

  String _formatDateForApi(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  Future<void> _updatePendingCount(Emitter<LeaveRequestState> emit) async {
    try {
      final pendingOutput = await _getAllLeaveRequestsUseCase.execute(
        const GetAllLeaveRequestsInput(page: 1, limit: 100, status: 'pending'),
      );
      final pendingCount = pendingOutput.leaveRequestResponse.data.length;
      emit(state.copyWith(pendingCount: pendingCount));
    } catch (e) {
      // Nếu có lỗi khi lấy pending count, không làm gì (giữ nguyên giá trị cũ)
      logD('Error updating pending count: $e');
    }
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

  Future<void> _onLoadMoreLeaveRequests(
    LoadMoreLeaveRequests event,
    Emitter<LeaveRequestState> emit,
  ) async {
    if (!state.canLoadMore) {
      return;
    }

    await runBlocCatching(
      handleLoading: false,
      doOnSubscribe: () async => emit(
        state.copyWith(
          loadMoreStatus: LoadDataStatus.init,
          isLoadingMore: true,
        ),
      ),
      action: () async {
        emit(state.copyWith(
          loadMoreStatus: LoadDataStatus.loading,
        ));

        final nextPage = state.currentPage + 1;
        await _loadLeaveRequestsByTab(
          state.selectedTabIndex,
          emit,
          page: nextPage,
          isLoadMore: true,
        );

        emit(state.copyWith(
          loadMoreStatus: LoadDataStatus.success,
        ));
      },
      handleError: true,
      doOnError: (e) async {
        emit(
          state.copyWith(
            loadDataException: e,
            loadMoreStatus: LoadDataStatus.fail,
          ),
        );
      },
      doOnEventCompleted: () async {
        emit(state.copyWith(
          loadMoreStatus: LoadDataStatus.init,
          isLoadingMore: false,
        ));
      },
    );
  }
}
