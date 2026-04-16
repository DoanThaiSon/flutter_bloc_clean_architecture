import 'package:freezed_annotation/freezed_annotation.dart';
import 'api_attendance_history_data.dart';

part 'api_attendance_history_data_response.g.dart';
part 'api_attendance_history_data_response.freezed.dart';

@freezed
class ApiAttendanceHistoryDataResponse with _$ApiAttendanceHistoryDataResponse {
  const factory ApiAttendanceHistoryDataResponse({
    @JsonKey(name: 'status') String? status,
    @JsonKey(name: 'message') String? message,
    @JsonKey(name: 'data') ApiAttendanceHistoryData? data,
  }) = _ApiAttendanceHistoryDataResponse;

  factory ApiAttendanceHistoryDataResponse.fromJson(Map<String, dynamic> json) =>
      _$ApiAttendanceHistoryDataResponseFromJson(json);
}
