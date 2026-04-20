import 'package:domain/domain.dart';
import 'package:injectable/injectable.dart';

import '../../../../../data.dart';

@Injectable()
class ApiDepartmentDetailResponseMapper extends BaseDataMapper<
    ApiDepartmentDetailResponseData, DepartmentDetailResponseData> {
  ApiDepartmentDetailResponseMapper(this._departmentDataMapper);

  final ApiDepartmentDataMapper _departmentDataMapper;

  @override
  DepartmentDetailResponseData mapToEntity(
      ApiDepartmentDetailResponseData? data) {
    return DepartmentDetailResponseData(
        status: data?.status ?? '',
        message: data?.message ?? '',
        department: _departmentDataMapper.mapToEntity(data?.data));
  }
}
