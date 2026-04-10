import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

import '../../domain.dart';

part 'get_today_attendance_use_case.freezed.dart';

@Injectable()
class GetTodayAttendanceUseCase
    extends BaseFutureUseCase<GetTodayAttendanceInput, GetTodayAttendanceOutput> {
  const GetTodayAttendanceUseCase(this._repository);

  final Repository _repository;

  @protected
  @override
  Future<GetTodayAttendanceOutput> buildUseCase(GetTodayAttendanceInput input) async {
    final response = await _repository.getTodayAttendance();

    return GetTodayAttendanceOutput(
      status: response.status,
      message: response.message,
      attendance: response.attendance,
    );
  }
}

@freezed
class GetTodayAttendanceInput extends BaseInput with _$GetTodayAttendanceInput {
  const factory GetTodayAttendanceInput() = _GetTodayAttendanceInput;
}

@freezed
class GetTodayAttendanceOutput extends BaseOutput with _$GetTodayAttendanceOutput {
  const GetTodayAttendanceOutput._();

  const factory GetTodayAttendanceOutput({
    @Default('') String status,
    @Default('') String message,
    Attendance? attendance,
  }) = _GetTodayAttendanceOutput;
}
