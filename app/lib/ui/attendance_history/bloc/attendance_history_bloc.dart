import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../../base/bloc/base_bloc.dart';
import 'attendance_history.dart';

@Injectable()
class AttendanceHistoryBloc
    extends BaseBloc<AttendanceHistoryEvent, AttendanceHistoryState> {
  AttendanceHistoryBloc() : super(const AttendanceHistoryState()) {
    on<AttendanceHistoryPageInitiated>(
      _onPageInitiated,
      transformer: log(),
    );
  }

  Future<void> _onPageInitiated(
    AttendanceHistoryPageInitiated event,
    Emitter<AttendanceHistoryState> emit,
  ) async {
    // Initialize page data
  }
}
