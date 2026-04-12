import 'package:domain/domain.dart';
import 'package:injectable/injectable.dart';
import '../../../../../data.dart';

@Injectable()
class ApiLeaveCodeDataMapper
    extends BaseDataMapper<ApiLeaveCodeData, LeaveCode> {
  @override
  LeaveCode mapToEntity(ApiLeaveCodeData? data) {
    return LeaveCode(
      id: data?.id ?? '',
      name: data?.name ?? '',
      code: data?.code ?? '',
      description: data?.description ?? '',
      isActive: data?.isActive ?? false,
    );
  }
}

@Injectable()
class ApiLeaveCodeResponseDataMapper
    extends BaseDataMapper<ApiLeaveCodeResponse, LeaveCodeResponse> {
  ApiLeaveCodeResponseDataMapper(this._leaveCodeDataMapper);

  final ApiLeaveCodeDataMapper _leaveCodeDataMapper;

  @override
  LeaveCodeResponse mapToEntity(ApiLeaveCodeResponse? data) {
    return LeaveCodeResponse(
      status: data?.status ?? '',
      message: data?.message ?? '',
      data: data?.data?.map(_leaveCodeDataMapper.mapToEntity).toList() ?? [],
    );
  }
}
