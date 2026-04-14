import 'dart:async';

import 'package:domain/domain.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../../base/bloc/base_bloc.dart';
import '../../../services/location_service.dart';
import 'attendance_home.dart';

@Injectable()
class AttendanceHomeBloc
    extends BaseBloc<AttendanceHomeEvent, AttendanceHomeState> {
  AttendanceHomeBloc(
    this._repository,
    this._getTodayAttendanceUseCase,
    this._checkoutUseCase,
    this._checkInUseCase,
    this._locationService,
  ) : super(const AttendanceHomeState()) {
    on<AttendanceHomePageInitiated>(
      _onPageInitiated,
      transformer: log(),
    );
    on<TimeUpdated>(
      _onTimeUpdated,
      transformer: log(),
    );
    on<CheckoutButtonPressed>(
      _onCheckoutButtonPressed,
      transformer: log(),
    );
    on<CheckInButtonPressed>(
      _onCheckInButtonPressed,
      transformer: log(),
    );
    on<CheckLocationPermission>(
      _onCheckLocationPermission,
      transformer: log(),
    );
    on<OpenLocationSettings>(
      _onOpenLocationSettings,
      transformer: log(),
    );
  }

  final Repository _repository;
  final GetTodayAttendanceUseCase _getTodayAttendanceUseCase;
  final CheckoutUseCase _checkoutUseCase;
  final CheckInUseCase _checkInUseCase;
  final LocationService _locationService;
  Timer? _timer;

  Future<void> _onPageInitiated(
    AttendanceHomePageInitiated event,
    Emitter<AttendanceHomeState> emit,
  ) async {
    await runBlocCatching(
        handleLoading: false,
        doOnSubscribe: () async => emit(state.copyWith(
              getTodayAttendanceStatus: LoadDataStatus.init,
            )),
        action: () async {
          emit(state.copyWith(
            getTodayAttendanceStatus: LoadDataStatus.loading,
          ));

          final user = _repository.getUserPreference();
          final output = await _getTodayAttendanceUseCase.execute(
            const GetTodayAttendanceInput(),
          );

          // Chỉ kiểm tra trạng thái quyền vị trí (đã được yêu cầu ở MainPage)
          final permissionStatus =
              await _locationService.checkLocationPermission();

          final now = DateTime.now();
          emit(state.copyWith(
            user: user,
            attendance: output.attendance,
            currentTime: _formatTime(now),
            locationPermissionStatus: permissionStatus,
            getTodayAttendanceStatus: LoadDataStatus.success,
          ));
          _startTimer();
        },
        handleError: true,
        doOnError: (e) async {
          emit(
            state.copyWith(
                loadDataException: e,
                getTodayAttendanceStatus: LoadDataStatus.fail),
          );
        },
        doOnEventCompleted: () async {
          emit(state.copyWith(
            getTodayAttendanceStatus: LoadDataStatus.init,
          ));
        });
  }

  void _onTimeUpdated(
    TimeUpdated event,
    Emitter<AttendanceHomeState> emit,
  ) {
    emit(state.copyWith(currentTime: event.currentTime));
  }

  Future<void> _onCheckoutButtonPressed(
    CheckoutButtonPressed event,
    Emitter<AttendanceHomeState> emit,
  ) async {
    await runBlocCatching(
        handleLoading: false,
        doOnSubscribe: () async => emit(state.copyWith(
              checkOutStatus: LoadDataStatus.init,
            )),
        action: () async {
          emit(state.copyWith(
            checkOutStatus: LoadDataStatus.loading,
          ));

          // Lấy vị trí hiện tại
          final position = await _locationService.getCurrentLocation();
          if (position == null) {
            throw Exception(
                'Không thể lấy vị trí. Vui lòng bật GPS và cấp quyền truy cập vị trí.');
          }

          final output = await _checkoutUseCase.execute(
            CheckoutInput(
              latitude: position.latitude,
              longitude: position.longitude,
            ),
          );

          emit(state.copyWith(
            attendance: output.attendance,
            checkOutStatus: LoadDataStatus.success,
          ));
        },
        handleError: true,
        doOnError: (e) async {
          emit(
            state.copyWith(
                loadDataException: e, checkOutStatus: LoadDataStatus.fail),
          );
        },
        doOnEventCompleted: () async {
          emit(state.copyWith(
            checkOutStatus: LoadDataStatus.init,
          ));
        });
  }

  Future<void> _onCheckInButtonPressed(
    CheckInButtonPressed event,
    Emitter<AttendanceHomeState> emit,
  ) async {
    await runBlocCatching(
        handleLoading: false,
        doOnSubscribe: () async => emit(state.copyWith(
              checkInStatus: LoadDataStatus.init,
            )),
        action: () async {
          emit(state.copyWith(
            checkInStatus: LoadDataStatus.loading,
          ));

          // Lấy vị trí hiện tại
          final position = await _locationService.getCurrentLocation();
          if (position == null) {
            throw Exception(
                'Không thể lấy vị trí. Vui lòng bật GPS và cấp quyền truy cập vị trí.');
          }

          final output = await _checkInUseCase.execute(
            CheckInInput(
              latitude: position.latitude,
              longitude: position.longitude,
            ),
          );

          emit(state.copyWith(
            attendance: output.attendance,
            checkInStatus: LoadDataStatus.success,
          ));
        },
        handleError: true,
        doOnError: (e) async {
          emit(
            state.copyWith(
                loadDataException: e, checkInStatus: LoadDataStatus.fail),
          );
        },
        doOnEventCompleted: () async {
          emit(state.copyWith(
            checkInStatus: LoadDataStatus.init,
          ));
        });
  }

  Future<void> _onCheckLocationPermission(
    CheckLocationPermission event,
    Emitter<AttendanceHomeState> emit,
  ) async {
    final permissionStatus = await _locationService.checkLocationPermission();
    emit(state.copyWith(locationPermissionStatus: permissionStatus));
  }

  Future<void> _onOpenLocationSettings(
    OpenLocationSettings event,
    Emitter<AttendanceHomeState> emit,
  ) async {
    await _locationService.openLocationSettings();
    // Không cần kiểm tra lại ở đây vì didChangeAppLifecycleState sẽ tự động kiểm tra
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      final now = DateTime.now();
      add(TimeUpdated(currentTime: _formatTime(now)));
    });
  }

  String _formatTime(DateTime dateTime) {
    final hour = dateTime.hour.toString().padLeft(2, '0');
    final minute = dateTime.minute.toString().padLeft(2, '0');

    return '$hour:$minute';
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }
}
