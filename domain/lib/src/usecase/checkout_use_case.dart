import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import '../../domain.dart';
part 'checkout_use_case.freezed.dart';

@Injectable()
class CheckoutUseCase extends BaseFutureUseCase<CheckoutInput, CheckoutOutput> {
  const CheckoutUseCase(this._repository);

  final Repository _repository;

  @protected
  @override
  Future<CheckoutOutput> buildUseCase(CheckoutInput input) async {
    final response = await _repository.checkout(
      latitude: input.latitude,
      longitude: input.longitude,
    );

    return CheckoutOutput(
      attendance: response.attendance,
    );
  }
}

@freezed
class CheckoutInput extends BaseInput with _$CheckoutInput {
  const factory CheckoutInput({
    required double latitude,
    required double longitude,
  }) = _CheckoutInput;
}

@freezed
class CheckoutOutput extends BaseOutput with _$CheckoutOutput {
  const factory CheckoutOutput({
    required Attendance attendance,
  }) = _CheckoutOutput;
}
