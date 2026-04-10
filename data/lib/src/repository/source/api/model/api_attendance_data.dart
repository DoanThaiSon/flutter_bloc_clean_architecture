import 'package:freezed_annotation/freezed_annotation.dart';

part 'api_attendance_data.freezed.dart';
part 'api_attendance_data.g.dart';

@freezed
class ApiAttendanceDataResponse with _$ApiAttendanceDataResponse{
  const factory ApiAttendanceDataResponse({
    @JsonKey(name: 'data') ApiAttendanceData? apiAttendanceData,
  }) = _ApiAttendanceDataResponse;

  factory ApiAttendanceDataResponse.fromJson(Map<String, dynamic> json) =>
      _$ApiAttendanceDataResponseFromJson(json);
}


@freezed
class ApiAttendanceData with _$ApiAttendanceData {
  const factory ApiAttendanceData({
    @JsonKey(name: '_id') String? id,
    @JsonKey(name: 'userId') String? userId,
    @JsonKey(name: 'date') String? date,
    @JsonKey(name: 'checkInTime') String? checkInTime,
    @JsonKey(name: 'checkInLocation') ApiLocationData? checkInLocation,
    @JsonKey(name: 'checkOutHistory') List<ApiCheckOutHistoryData>? checkOutHistory,
    @JsonKey(name: 'status') String? status,
    @JsonKey(name: 'checkOutTime') String? checkOutTime,
    @JsonKey(name: 'checkOutLocation') ApiLocationData? checkOutLocation,
    @JsonKey(name: 'workingHours') double? workingHours,
    @JsonKey(name: 'createdAt') String? createdAt,
    @JsonKey(name: 'updatedAt') String? updatedAt,
    @JsonKey(name: '_destroy') bool? destroy,
    @JsonKey(name: 'timeline') List<ApiTimelineData>? timeline,
    @JsonKey(name: 'summary') ApiAttendanceSummaryData? summary,
  }) = _ApiAttendanceData;

  factory ApiAttendanceData.fromJson(Map<String, dynamic> json) =>
      _$ApiAttendanceDataFromJson(json);
}

@freezed
class ApiLocationData with _$ApiLocationData {
  const factory ApiLocationData({
    @JsonKey(name: 'latitude') double? latitude,
    @JsonKey(name: 'longitude') double? longitude,
  }) = _ApiLocationData;

  factory ApiLocationData.fromJson(Map<String, dynamic> json) =>
      _$ApiLocationDataFromJson(json);
}

@freezed
class ApiCheckOutHistoryData with _$ApiCheckOutHistoryData {
  const factory ApiCheckOutHistoryData({
    @JsonKey(name: 'time') String? time,
    @JsonKey(name: 'location') ApiLocationData? location,
  }) = _ApiCheckOutHistoryData;

  factory ApiCheckOutHistoryData.fromJson(Map<String, dynamic> json) =>
      _$ApiCheckOutHistoryDataFromJson(json);
}

@freezed
class ApiTimelineData with _$ApiTimelineData {
  const factory ApiTimelineData({
    @JsonKey(name: 'type') String? type,
    @JsonKey(name: 'time') String? time,
    @JsonKey(name: 'location') ApiLocationData? location,
  }) = _ApiTimelineData;

  factory ApiTimelineData.fromJson(Map<String, dynamic> json) =>
      _$ApiTimelineDataFromJson(json);
}

@freezed
class ApiAttendanceSummaryData with _$ApiAttendanceSummaryData {
  const factory ApiAttendanceSummaryData({
    @JsonKey(name: 'totalCheckouts') int? totalCheckouts,
    @JsonKey(name: 'workingHours') double? workingHours,
    @JsonKey(name: 'status') String? status,
  }) = _ApiAttendanceSummaryData;

  factory ApiAttendanceSummaryData.fromJson(Map<String, dynamic> json) =>
      _$ApiAttendanceSummaryDataFromJson(json);
}
