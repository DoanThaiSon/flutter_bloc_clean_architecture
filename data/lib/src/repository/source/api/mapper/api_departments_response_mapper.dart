import 'package:domain/domain.dart';
import 'package:injectable/injectable.dart';

import '../../../../../data.dart';

@Injectable()
class ApiDepartmentsResponseMapper
    extends BaseDataMapper<ApiDepartmentsResponse, List<Department>> {
  ApiDepartmentsResponseMapper(this._departmentDataMapper);

  final ApiDepartmentDataMapper _departmentDataMapper;

  @override
  List<Department> mapToEntity(ApiDepartmentsResponse? data) {
    return _departmentDataMapper.mapToListEntity(data?.data);
  }
}
