import 'package:freezed_annotation/freezed_annotation.dart';
import 'attendance.dart';

part 'checkout_response.freezed.dart';

@freezed
class CheckoutResponse with _$CheckoutResponse {
  const factory CheckoutResponse({
    required String status,
    required String message,
    required Attendance attendance,
  }) = _CheckoutResponse;
}
