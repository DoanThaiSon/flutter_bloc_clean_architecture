import 'package:domain/domain.dart';
import 'package:injectable/injectable.dart';

import '../../../../../data.dart';
import '../model/api_department_data.dart';

@Injectable()
class ApiLoginUserDataMapper extends BaseDataMapper<ApiLoginUserData, User> {
  ApiLoginUserDataMapper(this._genderDataMapper, this._apiDepartmentDataMapper);

  final GenderDataMapper _genderDataMapper;
  final ApiDepartmentDataMapper _apiDepartmentDataMapper;

  @override
  User mapToEntity(ApiLoginUserData? data) {
    return User(
        id: data?.id?? User.defaultId,
        email: data?.email ?? User.defaultEmail,
        name: data?.username ?? User.defaultName,
        employeeCode: data?.employeeCode ?? User.defaultEmployeeCode,
        phoneNumber: data?.phoneNumber ?? User.defaultPhoneNumber,
        birthday: data?.dateOfBirth != null
            ? DateTime.tryParse(data!.dateOfBirth!)
            : User.defaultBirthday,
        joinDate: data?.joinDate != null
            ? DateTime.tryParse(data!.joinDate!)
            : User.defaultJoinDate,
        gender: _genderDataMapper.mapToEntity(data?.gender),
        department: data?.department != null
            ? Department(
                id: data!.department!.id ?? '',
                name: data.department!.name ?? '',
                code: data.department!.code ?? '',
                description: data.department!.description ?? '',
              )
            : User.defaultDepartment,
        role: data?.role ?? User.defaultRole,
        isManager: data?.isManager ?? User.defaultIsManager,
        managedDepartments:
            _apiDepartmentDataMapper.mapToListEntity(data?.managedDepartments)
    );
  }
}

@Injectable()
class ApiDepartmentDataMapper
    extends BaseDataMapper<ApiDepartmentData, Department> {
  ApiDepartmentDataMapper();

  @override
  Department mapToEntity(ApiDepartmentData? data) {
    return Department(
      id: data?.id ?? '',
      name: data?.name ?? '',
      code: data?.code ?? '',
      description: data?.description ?? '',
    );
  }
}
