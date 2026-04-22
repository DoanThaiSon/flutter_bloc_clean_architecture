import 'package:domain/domain.dart';
import 'package:injectable/injectable.dart';

import '../../../../../data.dart';

@Injectable()
class ApiDepartmentDataMapper
    extends BaseDataMapper<ApiDepartmentData, Department> {
  @override
  Department mapToEntity(ApiDepartmentData? data) {
    return Department(
      id: data?.id ?? '',
      name: data?.name ?? '',
      code: data?.code ?? '',
      description: data?.description ?? '',
      managerId: data?.managerId ?? '',
      manager: data?.manager != null 
          ? _mapUserToEntity(data!.manager!)
          : null,
    );
  }

  // Map user inline để tránh circular dependency
  User _mapUserToEntity(ApiUserData data) {
    return User(
      id: data.id ?? '',
      email: data.email ?? '',
      name: data.username ?? '',
      employeeCode: data.employeeCode ?? '',
      phoneNumber: data.phoneNumber ?? '',
      birthday: data.birthday != null
          ? DateTime.tryParse(data.birthday!)
          : null,
      joinDate: data.joinDate != null
          ? DateTime.tryParse(data.joinDate!)
          : null,
      role: data.role ?? '',
      isManager: data.isManager ?? false,
    );
  }
}
