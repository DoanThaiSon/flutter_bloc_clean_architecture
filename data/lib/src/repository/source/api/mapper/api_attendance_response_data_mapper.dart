import 'package:domain/domain.dart';
import 'package:injectable/injectable.dart';

import '../../../../../data.dart';

@Injectable()
class ApiAttendanceResponseDataMapper extends BaseDataMapper<ApiAttendanceDataResponse, AttendanceResponse> {
  ApiAttendanceResponseDataMapper(this._attendanceDataMapper);

  final ApiAttendanceDataMapper _attendanceDataMapper;

  @override
  AttendanceResponse mapToEntity(ApiAttendanceDataResponse? data) {
    return AttendanceResponse(
      attendance:  _attendanceDataMapper.mapToEntity(data?.apiAttendanceData),
    );
  }
}
