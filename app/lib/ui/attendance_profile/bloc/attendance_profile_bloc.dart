import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../../base/bloc/base_bloc.dart';
import 'attendance_profile.dart';

@Injectable()
class AttendanceProfileBloc
    extends BaseBloc<AttendanceProfileEvent, AttendanceProfileState> {
  AttendanceProfileBloc() : super(const AttendanceProfileState()) {
    on<AttendanceProfilePageInitiated>(
      _onPageInitiated,
      transformer: log(),
    );
  }

  Future<void> _onPageInitiated(
    AttendanceProfilePageInitiated event,
    Emitter<AttendanceProfileState> emit,
  ) async {
    // Initialize page data
  }
}
