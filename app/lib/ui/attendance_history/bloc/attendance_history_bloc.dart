import 'package:domain/domain.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../../base/bloc/base_bloc.dart';
import 'attendance_history.dart';

@Injectable()
class AttendanceHistoryBloc
    extends BaseBloc<AttendanceHistoryEvent, AttendanceHistoryState> {
  AttendanceHistoryBloc(this._getAttendanceHistoryUseCase)
      : super(AttendanceHistoryState(
          selectedMonth: DateTime.now().month,
          selectedYear: DateTime.now().year,
        )) {
    on<AttendanceHistoryPageInitiated>(
      _onPageInitiated,
      transformer: log(),
    );
    on<AttendanceHistoryMonthChanged>(
      _onMonthChanged,
      transformer: log(),
    );
    on<AttendanceHistoryDaySelected>(
      _onDaySelected,
      transformer: log(),
    );
  }

  final GetAttendanceHistoryUseCase _getAttendanceHistoryUseCase;

  Future<void> _onPageInitiated(
    AttendanceHistoryPageInitiated event,
    Emitter<AttendanceHistoryState> emit,
  ) async {
    await _loadAttendanceHistory(emit);
  }

  Future<void> _onMonthChanged(
    AttendanceHistoryMonthChanged event,
    Emitter<AttendanceHistoryState> emit,
  ) async {
    emit(state.copyWith(
      selectedMonth: event.month,
      selectedYear: event.year,
      selectedDate: null,
    ));
    await _loadAttendanceHistory(emit);
  }

  Future<void> _onDaySelected(
    AttendanceHistoryDaySelected event,
    Emitter<AttendanceHistoryState> emit,
  ) async {
    emit(state.copyWith(selectedDate: event.date));
  }

  Future<void> _loadAttendanceHistory(Emitter<AttendanceHistoryState> emit) async {
    await runBlocCatching(
      handleLoading: false,
      doOnSubscribe: () async => emit(state.copyWith(
        loadDataStatus: LoadDataStatus.init,
      )),
      action: () async {
        emit(state.copyWith(loadDataStatus: LoadDataStatus.loading));

        // Tính startDate và endDate cho tháng được chọn
        final firstDay = DateTime(state.selectedYear, state.selectedMonth, 1);
        final lastDay = DateTime(state.selectedYear, state.selectedMonth + 1, 0);

        final startDate = firstDay.toIso8601String();
        final endDate = lastDay.toIso8601String();

        final output = await _getAttendanceHistoryUseCase.execute(
          GetAttendanceHistoryInput(
            startDate: startDate,
            endDate: endDate,
          ),
        );

        emit(state.copyWith(
          attendanceHistory: output.attendanceHistory,
          loadDataStatus: LoadDataStatus.success,
        ));
      },
      handleError: true,
      doOnError: (e) async {
        emit(state.copyWith(
          loadDataException: e,
          loadDataStatus: LoadDataStatus.fail,
        ));
      },
      doOnEventCompleted: () async {
        emit(state.copyWith(loadDataStatus: LoadDataStatus.init));
      },
    );
  }
}
