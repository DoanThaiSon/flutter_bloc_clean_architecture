import 'package:domain/domain.dart';
import 'package:injectable/injectable.dart';

import '../../../../../data.dart';

@Injectable()
class ApiLeaveRequestDataMapper extends BaseDataMapper<ApiLeaveRequestData, LeaveRequest> {
  ApiLeaveRequestDataMapper(this._userDataMapper);

  final ApiUserDataMapper _userDataMapper;

  @override
  LeaveRequest mapToEntity(ApiLeaveRequestData? data) {
    return LeaveRequest(
      id: data?.id ?? '',
      userId: data?.userId ?? '',
      creatorName: data?.creatorName??'',
      dayType: data?.dayType ?? '',
      shift: data?.shift??'',
      leaveCodeId: data?.leaveCodeId??'',
      startDate: data?.startDate??'',
      endDate: data?.endDate??'',
      totalDays: data?.totalDays ?? 0,
      reason: data?.reason ?? '',
      status: data?.status ?? '',
      approvedBy: data?.approvedBy ?? '',
      approvedAt: data?.approvedAt??'',
      rejectionReason: data?.rejectionReason ?? '',
      createdAt: data?.createdAt??'',
      updatedAt: data?.updatedAt??'',
      destroy: data?.destroy ?? false,
      approver: data?.approver != null
          ? User(
              id: data?.approver?.id??'',
              email: data?.approver?.email ?? '',
              name: data?.approver?.username ?? '',
            )
          : null,
    );
  }
}

@Injectable()
class ApiLeaveRequestResponseDataMapper
    extends BaseDataMapper<ApiLeaveRequestResponse, LeaveRequestResponse> {
  ApiLeaveRequestResponseDataMapper(this._leaveRequestDataMapper);

  final ApiLeaveRequestDataMapper _leaveRequestDataMapper;

  @override
  LeaveRequestResponse mapToEntity(ApiLeaveRequestResponse? data) {
    return LeaveRequestResponse(
      status: data?.status ?? '',
      message: data?.message ?? '',
      data: _leaveRequestDataMapper.mapToListEntity(data?.data),
      page: data?.page ?? 1,
      limit: data?.limit ?? 10,
      total: data?.total ?? 0,
    );
  }
}
