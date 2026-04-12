import 'package:freezed_annotation/freezed_annotation.dart';

part 'leave_code.freezed.dart';

@freezed
class LeaveCode with _$LeaveCode {
  const factory LeaveCode({
    @Default('') String id,
    @Default('') String name,
    @Default('') String code,
    @Default('') String description,
    @Default(false) bool isActive,
  }) = _LeaveCode;
}

@freezed
class LeaveCodeResponse with _$LeaveCodeResponse {
  const factory LeaveCodeResponse({
    @Default('') String status,
    @Default('') String message,
    @Default([]) List<LeaveCode> data,
  }) = _LeaveCodeResponse;
}
