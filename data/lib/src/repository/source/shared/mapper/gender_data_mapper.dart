import 'package:dartx/dartx.dart';
import 'package:domain/domain.dart';
import 'package:injectable/injectable.dart';

import '../../../../../data.dart';

@Injectable()
class GenderDataMapper extends BaseDataMapper<String, Gender> with DataMapperMixin {
  @override
  Gender mapToEntity(String? data) {
    return Gender.values.firstOrNullWhere((element) => element.serverValue == data) ??
        Gender.unknown;
  }

  @override
  String mapToData(Gender entity) {
    return entity.serverValue;
  }
}
