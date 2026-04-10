import 'package:freezed_annotation/freezed_annotation.dart';
import 'api_attendance_data.dart';

part 'api_checkout_response_data.freezed.dart';
part 'api_checkout_response_data.g.dart';

@freezed
class ApiCheckoutResponseData with _$ApiCheckoutResponseData {
  const factory ApiCheckoutResponseData({
    required String status,
    required String message,
    required ApiAttendanceData data,
  }) = _ApiCheckoutResponseData;

  factory ApiCheckoutResponseData.fromJson(Map<String, dynamic> json) =>
      _$ApiCheckoutResponseDataFromJson(json);
}
