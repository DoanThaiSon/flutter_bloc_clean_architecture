import 'package:domain/domain.dart';
import 'package:injectable/injectable.dart';

import '../../../../../data.dart';
import '../model/api_department_data.dart';

@Injectable()
class ApiDepartmentDataMapper extends BaseDataMapper<ApiDepartmentData, Department> {
  @override
  Department mapToEntity(ApiDepartmentData? data) {
    return Department(
      id: data?.id ?? '',
      name: data?.name ?? '',
      code: data?.code ?? '',
      description: data?.description ?? '',
      managerId: data?.managerId ?? '',
    );
  }
}
