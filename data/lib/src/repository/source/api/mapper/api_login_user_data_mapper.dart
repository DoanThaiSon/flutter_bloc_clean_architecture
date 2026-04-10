import 'package:domain/domain.dart';
import 'package:injectable/injectable.dart';

import '../../../../../data.dart';

@Injectable()
class ApiLoginUserDataMapper extends BaseDataMapper<ApiLoginUserData, User> {
  @override
  User mapToEntity(ApiLoginUserData? data) {
    return User(
      id: data?.id?.hashCode ?? User.defaultId,
      email: data?.email ?? User.defaultEmail,
      name: data?.username ?? User.defaultName,
    );
  }
}
