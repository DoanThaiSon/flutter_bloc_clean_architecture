import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import '../../domain.dart';
part 'check_in_use_case.freezed.dart';

@Injectable()
class CheckInUseCase extends BaseFutureUseCase<CheckInInput, CheckInOutput> {
  const CheckInUseCase(this._repository);

  final Repository _repository;

  @protected
  @override
  Future<CheckInOutput> buildUseCase(CheckInInput input) async {
    final response = await _repository.checkIn(
      latitude: input.latitude,
      longitude: input.longitude,
    );

    return CheckInOutput(
      attendance: response.attendance,
    );
  }
}

@freezed
class CheckInInput extends BaseInput with _$CheckInInput {
  const factory CheckInInput({
    required double latitude,
    required double longitude,
  }) = _CheckInInput;
}

@freezed
class CheckInOutput extends BaseOutput with _$CheckInOutput {
  const factory CheckInOutput({
    required Attendance attendance,
  }) = _CheckInOutput;
}
