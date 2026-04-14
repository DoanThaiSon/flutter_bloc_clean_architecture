import 'dart:async';
import 'package:data/data.dart';
import 'package:domain/domain.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../../base/bloc/base_bloc.dart';
import 'attendance_profile.dart';

@Injectable()
class AttendanceProfileBloc
    extends BaseBloc<AttendanceProfileEvent, AttendanceProfileState> {
  AttendanceProfileBloc(
      this._logoutUseCase, this._appPreferences, this._repository)
      : super(const AttendanceProfileState()) {
    on<AttendanceProfilePageInitiated>(
      _onPageInitiated,
      transformer: log(),
    );
    on<LogoutButtonPressed>(
      _onLogoutButtonPressed,
      transformer: log(),
    );
  }

  final LogoutUseCase _logoutUseCase;
  final AppPreferences _appPreferences;
  final Repository _repository;

  Future<void> _onPageInitiated(
    AttendanceProfilePageInitiated event,
    Emitter<AttendanceProfileState> emit,
  ) async {
    return runBlocCatching(action: () async {
      final user = _repository.getUserPreference();
      emit(state.copyWith(
        user: user,
      ));
    });
  }

  FutureOr<void> _onLogoutButtonPressed(
    LogoutButtonPressed event,
    Emitter<AttendanceProfileState> emit,
  ) async {
    return runBlocCatching(
      action: () async {
        final refreshToken = await _appPreferences.refreshToken;
        await _logoutUseCase.execute(LogoutInput(refreshToken: refreshToken));
      },
    );
  }
}
