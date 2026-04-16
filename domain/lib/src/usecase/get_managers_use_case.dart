import 'package:injectable/injectable.dart';

import '../../domain.dart';

@Injectable()
class GetManagersUseCase {
  const GetManagersUseCase(this._repository);

  final Repository _repository;

  Future<List<User>> call() async {
    return _repository.getManagers();
  }
}
