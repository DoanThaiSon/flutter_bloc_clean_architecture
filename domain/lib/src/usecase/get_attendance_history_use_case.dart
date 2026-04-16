import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

import '../../domain.dart';

part 'get_attendance_history_use_case.freezed.dart';

@Injectable()
class GetAttendanceHistoryUseCase
    extends BaseFutureUseCase<GetAttendanceHistoryInput, GetAttendanceHistoryOutput> {
  const GetAttendanceHistoryUseCase(this._repository);

  final Repository _repository;

  @protected
  @override
  Future<GetAttendanceHistoryOutput> buildUseCase(GetAttendanceHistoryInput input) async {
    final response = await _repository.getAttendanceHistory(
      startDate: input.startDate,
      endDate: input.endDate,
    );

    return GetAttendanceHistoryOutput(
      status: response.status,
      message: response.message,
      attendanceHistory: response.attendanceHistory,
    );
  }
}

@freezed
class GetAttendanceHistoryInput extends BaseInput with _$GetAttendanceHistoryInput {
  const factory GetAttendanceHistoryInput({
    required String startDate,
    required String endDate,
  }) = _GetAttendanceHistoryInput;
}

@freezed
class GetAttendanceHistoryOutput extends BaseOutput with _$GetAttendanceHistoryOutput {
  const GetAttendanceHistoryOutput._();

  const factory GetAttendanceHistoryOutput({
    @Default('') String status,
    @Default('') String message,
    AttendanceHistory? attendanceHistory,
  }) = _GetAttendanceHistoryOutput;
}
