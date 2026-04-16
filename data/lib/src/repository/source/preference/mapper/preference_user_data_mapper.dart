import 'package:domain/domain.dart';
import 'package:injectable/injectable.dart';

import '../../../../../data.dart';

@Injectable()
class PreferenceUserDataMapper extends BaseDataMapper<PreferenceUserData, User>
    with DataMapperMixin {
  PreferenceUserDataMapper(
      this._genderDataMapper, this._apiDepartmentDataMapper);

  final GenderDataMapper _genderDataMapper;
  final ApiDepartmentDataMapper _apiDepartmentDataMapper;

  @override
  User mapToEntity(PreferenceUserData? data) {
    return User(
        id: data?.id ?? User.defaultId,
        email: data?.email ?? User.defaultEmail,
        name: data?.name ?? User.defaultName,
        employeeCode: data?.employeeCode ?? User.defaultEmployeeCode,
        phoneNumber: data?.phoneNumber ?? User.defaultPhoneNumber,
        birthday: data?.birthday != null
            ? DateTime.tryParse(data!.birthday!)
            : User.defaultBirthday,
        joinDate: data?.joinDate != null
            ? DateTime.tryParse(data!.joinDate!)
            : User.defaultJoinDate,
        gender: _genderDataMapper.mapToEntity(data?.gender),
        department: Department(
          id: data?.departmentId ?? '',
          name: data?.departmentName ?? '',
          code: data?.departmentCode ?? '',
          description: data?.departmentDescription ?? '',
        ),
        role: data?.role ?? User.defaultRole,
        isManager: data?.isManager ?? false,
        managedDepartments:
            _apiDepartmentDataMapper.mapToListEntity(data?.managedDepartments));
  }

  @override
  PreferenceUserData mapToData(User entity) {
    return PreferenceUserData(
        id: entity.id,
        email: entity.email,
        name: entity.name,
        employeeCode: entity.employeeCode,
        phoneNumber: entity.phoneNumber,
        birthday: entity.birthday?.toIso8601String(),
        joinDate: entity.joinDate?.toIso8601String(),
        gender: _genderDataMapper.mapToData(entity.gender),
        departmentId: entity.department?.id ?? '',
        departmentName: entity.department?.name ?? '',
        departmentCode: entity.department?.code ?? '',
        departmentDescription: entity.department?.description ?? '',
        role: entity.role,
        isManager: entity.isManager);
  }
}
