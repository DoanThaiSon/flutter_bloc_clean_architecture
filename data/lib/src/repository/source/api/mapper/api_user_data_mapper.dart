import 'package:domain/domain.dart';
import 'package:injectable/injectable.dart';
import 'package:shared/shared.dart';

import '../../../../../data.dart';

@Injectable()
class ApiUserDataMapper extends BaseDataMapper<ApiUserData, User> {
  ApiUserDataMapper(
    this._genderDataMapper,
    this._apiImageUrlDataMapper,
  );

  final GenderDataMapper _genderDataMapper;
  final ApiImageUrlDataMapper _apiImageUrlDataMapper;

  @override
  User mapToEntity(ApiUserData? data) {
    return User(
        id: data?.id ?? User.defaultId,
        email: data?.email ?? User.defaultEmail,
        name: data?.name??User.defaultName,
        employeeCode: data?.employeeCode??User.defaultEmployeeCode,
        birthday: DateTimeUtils.tryParse(
              date: data?.birthday,
              format: DateTimeFormatConstants.appServerResponse,
            ) ??
            User.defaultBirthday,
        phoneNumber: data?.phoneNumber??User.defaultPhoneNumber,
        // department: ,
        avatar: _apiImageUrlDataMapper.mapToEntity(data?.avatar),
        gender: _genderDataMapper.mapToEntity(data?.gender),
        role: data?.role ?? '');
  }
}
