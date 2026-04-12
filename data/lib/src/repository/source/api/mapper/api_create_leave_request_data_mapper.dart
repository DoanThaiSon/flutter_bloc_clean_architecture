import 'package:domain/domain.dart';
import 'package:injectable/injectable.dart';

import '../../../../../data.dart';
import '../model/api_create_leave_request_data.dart';
import 'api_leave_request_data_mapper.dart';
import 'base/base_success_response_mapper.dart';

@Injectable()
class ApiCreateLeaveRequestResponseDataMapper extends BaseDataMapper<
    ApiCreateLeaveRequestResponse, CreateLeaveRequestResponse> {
  ApiCreateLeaveRequestResponseDataMapper(this._leaveRequestDataMapper);

  final ApiLeaveRequestDataMapper _leaveRequestDataMapper;

  @override
  CreateLeaveRequestResponse mapToEntity(
      ApiCreateLeaveRequestResponse? data) {
    return CreateLeaveRequestResponse(
      status: data?.status ?? '',
      message: data?.message ?? '',
      data: data?.data != null
          ? _leaveRequestDataMapper.mapToEntity(data!.data)
          : null,
    );
  }
}
