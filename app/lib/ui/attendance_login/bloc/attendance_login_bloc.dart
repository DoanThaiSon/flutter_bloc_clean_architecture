import 'package:domain/domain.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../../base/bloc/base_bloc.dart';
import '../../../navigation/routes/app_router.dart';
import 'attendance_login.dart';

@Injectable()
class AttendanceLoginBloc
    extends BaseBloc<AttendanceLoginEvent, AttendanceLoginState> {
  AttendanceLoginBloc(this._loginUseCase)
      : super(const AttendanceLoginState()) {
    on<LoginButtonPressed>(
      _onLoginButtonPressed,
      transformer: log(),
    );
    on<EmployeeIdChanged>(
      _onEmployeeIdChanged,
      transformer: log(),
    );
    on<PasswordChanged>(
      _onPasswordChanged,
      transformer: log(),
    );
  }

  final LoginUseCase _loginUseCase;

  Future<void> _onLoginButtonPressed(
    LoginButtonPressed event,
    Emitter<AttendanceLoginState> emit,
  ) async {
    await runBlocCatching(
      action: () async {
        final output = await _loginUseCase.execute(
          LoginInput(
            email: state.employeeId,
            password: state.password,
          ),
        );

        emit(state.copyWith(user: output.user));
        await navigator.replace(const AppRouteInfo.main());
      },
      doOnSubscribe: () async {
        emit(state.copyWith(isLoading: true));
      },
      doOnSuccessOrError: () async {
        emit(state.copyWith(isLoading: false));
      },
      handleLoading: false,
    );
  }

  void _onEmployeeIdChanged(
    EmployeeIdChanged event,
    Emitter<AttendanceLoginState> emit,
  ) {
    emit(state.copyWith(
      employeeId: event.employeeId,
      isLoginButtonEnabled:
          event.employeeId.isNotEmpty && state.password.isNotEmpty,
    ));
  }

  void _onPasswordChanged(
    PasswordChanged event,
    Emitter<AttendanceLoginState> emit,
  ) {
    emit(state.copyWith(
      password: event.password,
      isLoginButtonEnabled:
          state.employeeId.isNotEmpty && event.password.isNotEmpty,
    ));
  }
}
