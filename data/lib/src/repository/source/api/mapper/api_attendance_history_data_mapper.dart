import 'package:domain/domain.dart';
import 'package:injectable/injectable.dart';

import '../../../../../data.dart';

@Injectable()
class ApiAttendanceHistoryDataMapper
    extends BaseDataMapper<ApiAttendanceHistoryData, AttendanceHistory> {
  ApiAttendanceHistoryDataMapper(
    this._attendanceDataMapper,
    this._leaveRecordDataMapper,
    this._attendanceHistorySummaryDataMapper,
  );

  final ApiAttendanceDataMapper _attendanceDataMapper;
  final ApiLeaveRecordDataMapper _leaveRecordDataMapper;
  final ApiAttendanceHistorySummaryDataMapper _attendanceHistorySummaryDataMapper;

  @override
  AttendanceHistory mapToEntity(ApiAttendanceHistoryData? data) {
    return AttendanceHistory(
      attendances: _attendanceDataMapper.mapToListEntity(data?.attendances),
      leaveRecords: _leaveRecordDataMapper.mapToListEntity(data?.leaveRecords),
      summary: _attendanceHistorySummaryDataMapper.mapToEntity(data?.summary),
    );
  }
}

@Injectable()
class ApiLeaveRecordDataMapper
    extends BaseDataMapper<ApiLeaveRecordData, LeaveRecord> {
  ApiLeaveRecordDataMapper(this._leaveCodeInfoDataMapper);

  final ApiLeaveCodeInfoDataMapper _leaveCodeInfoDataMapper;

  @override
  LeaveRecord mapToEntity(ApiLeaveRecordData? data) {
    return LeaveRecord(
      date: data?.date != null ? DateTime.tryParse(data!.date!) : null,
      status: data?.status ?? '',
      dayType: data?.dayType ?? '',
      shift: data?.shift ?? '',
      reason: data?.reason ?? '',
      leaveCode: _leaveCodeInfoDataMapper.mapToEntity(data?.leaveCode),
      leaveRequestId: data?.leaveRequestId ?? '',
    );
  }
}

@Injectable()
class ApiLeaveCodeInfoDataMapper
    extends BaseDataMapper<ApiLeaveCodeInfoData, LeaveCodeInfo> {
  @override
  LeaveCodeInfo mapToEntity(ApiLeaveCodeInfoData? data) {
    return LeaveCodeInfo(
      name: data?.name ?? '',
      code: data?.code ?? '',
    );
  }
}

@Injectable()
class ApiAttendanceHistorySummaryDataMapper
    extends BaseDataMapper<ApiAttendanceHistorySummaryData, AttendanceHistorySummary> {
  @override
  AttendanceHistorySummary mapToEntity(ApiAttendanceHistorySummaryData? data) {
    return AttendanceHistorySummary(
      totalDays: data?.totalDays ?? 0,
      totalWorkingHours: data?.totalWorkingHours ?? 0.0,
      present: data?.present ?? 0,
      late: data?.late ?? 0,
      absent: data?.absent ?? 0,
      leave: data?.leave ?? 0,
      halfDay: data?.halfDay ?? 0,
    );
  }
}
