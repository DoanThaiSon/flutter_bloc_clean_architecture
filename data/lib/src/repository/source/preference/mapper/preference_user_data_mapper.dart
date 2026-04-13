import 'package:domain/domain.dart';
import 'package:injectable/injectable.dart';

import '../../../../../data.dart';

@Injectable()
class PreferenceUserDataMapper extends BaseDataMapper<PreferenceUserData, User>
    with DataMapperMixin {
  @override
  User mapToEntity(PreferenceUserData? data) {
    return User(
      id: data?.id.hashCode ?? User.defaultId,
      email: data?.email ?? User.defaultEmail,
      name: data?.name ?? User.defaultName,
      role: data?.role ?? User.defaultRole,
    );
  }

  @override
  PreferenceUserData mapToData(User entity) {
    return PreferenceUserData(
      id: entity.id.toString(),
      email: entity.email,
      name: entity.name,
      role: entity.role,
    );
  }
}
