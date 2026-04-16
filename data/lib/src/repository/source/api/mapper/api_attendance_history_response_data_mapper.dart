import 'package:domain/domain.dart';
import 'package:injectable/injectable.dart';

import '../../../../../data.dart';

@Injectable()
class ApiAttendanceHistoryResponseDataMapper
    extends BaseDataMapper<ApiAttendanceHistoryDataResponse, AttendanceHistoryResponse> {
  ApiAttendanceHistoryResponseDataMapper(this._attendanceHistoryDataMapper);

  final ApiAttendanceHistoryDataMapper _attendanceHistoryDataMapper;

  @override
  AttendanceHistoryResponse mapToEntity(ApiAttendanceHistoryDataResponse? data) {
    return AttendanceHistoryResponse(
      status: data?.status ?? '',
      message: data?.message ?? '',
      attendanceHistory: _attendanceHistoryDataMapper.mapToEntity(data?.data),
    );
  }
}
