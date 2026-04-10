import 'package:domain/domain.dart';
import 'package:injectable/injectable.dart';
import '../../../../../data.dart';

@Injectable()
class ApiCheckoutResponseDataMapper {
  const ApiCheckoutResponseDataMapper(this._attendanceMapper);

  final ApiAttendanceDataMapper _attendanceMapper;

  CheckoutResponse mapToEntity(ApiCheckoutResponseData? data) {
    return CheckoutResponse(
      status: data?.status??'',
      message: data?.message??'',
      attendance: _attendanceMapper.mapToEntity(data?.data),
    );
  }
}
