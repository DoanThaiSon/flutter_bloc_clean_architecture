import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:domain/domain.dart';
import 'package:intl/intl.dart';
import '../../../app.dart';
import 'leave_request.dart';

@Injectable()
class LeaveRequestBloc extends BaseBloc<LeaveRequestEvent, LeaveRequestState> {
  LeaveRequestBloc(this._getLeaveRequestsUseCase)
      : super(const LeaveRequestState()) {
    on<LeaveRequestPageInitiated>(
      _onLeaveRequestPageInitiated,
      transformer: log(),
    );

    on<LeaveRequestTabChanged>(
      _onLeaveRequestTabChanged,
      transformer: log(),
    );
  }

  final GetLeaveRequestsUseCase _getLeaveRequestsUseCase;

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
        emit(state.copyWith(leaveRequests: output.leaveRequestResponse,   getLeaveRequestResponseStatus: LoadDataStatus.success,));
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
        }
    );
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
}
