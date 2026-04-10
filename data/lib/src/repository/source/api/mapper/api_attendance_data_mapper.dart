import 'package:domain/domain.dart';
import 'package:injectable/injectable.dart';

import '../../../../../data.dart';

@Injectable()
class ApiAttendanceDataMapper extends BaseDataMapper<ApiAttendanceData, Attendance> {
  @override
  Attendance mapToEntity(ApiAttendanceData? data) {
    return Attendance(
      id: data?.id ?? '',
      userId: data?.userId ?? '',
      date: _parseToLocalTime(data?.date),
      checkInTime: _parseToLocalTime(data?.checkInTime),
      checkInLocation: _mapLocation(data?.checkInLocation),
      checkOutHistory: data?.checkOutHistory?.map(_mapCheckOutHistory).toList() ?? [],
      status: AttendanceStatus.fromString(data?.status),
      checkOutTime: _parseToLocalTime(data?.checkOutTime),
      checkOutLocation: _mapLocation(data?.checkOutLocation),
      workingHours: data?.workingHours ?? 0.0,
      createdAt: _parseToLocalTime(data?.createdAt),
      updatedAt: _parseToLocalTime(data?.updatedAt),
      timeline: data?.timeline?.map(_mapTimeline).toList() ?? [],
      summary: _mapSummary(data?.summary),
    );
  }

  /// Parse UTC time string to local DateTime (Vietnam timezone)
  DateTime? _parseToLocalTime(String? dateTimeString) {
    if (dateTimeString == null) return null;
    
    final utcDateTime = DateTime.tryParse(dateTimeString);
    if (utcDateTime == null) return null;
    
    // Convert UTC to local time (device timezone)
    return utcDateTime.toLocal();
  }

  AttendanceLocation? _mapLocation(ApiLocationData? data) {
    if (data == null) {
      return null;
    }
    return AttendanceLocation(
      latitude: data.latitude ?? 0.0,
      longitude: data.longitude ?? 0.0,
    );
  }

  CheckOutHistory _mapCheckOutHistory(ApiCheckOutHistoryData data) {
    return CheckOutHistory(
      time: _parseToLocalTime(data.time),
      location: _mapLocation(data.location),
    );
  }

  AttendanceRecord _mapTimeline(ApiTimelineData data) {
    return AttendanceRecord(
      type: TimelineType.fromString(data.type),
      time: _parseToLocalTime(data.time),
      location: _mapLocation(data.location),
    );
  }

  AttendanceSummary? _mapSummary(ApiAttendanceSummaryData? data) {
    if (data == null) {
      return null;
    }
    return AttendanceSummary(
      totalCheckouts: data.totalCheckouts ?? 0,
      workingHours: data.workingHours ?? 0.0,
      status: AttendanceStatus.fromString(data.status),
    );
  }
}
