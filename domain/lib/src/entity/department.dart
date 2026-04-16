import 'package:freezed_annotation/freezed_annotation.dart';

part 'department.freezed.dart';

@freezed
class Department with _$Department {
  const factory Department({
    @Default('') String id,
    @Default('') String name,
    @Default('') String code,
    @Default('') String description,
    @Default('') String managerId,
  }) = _Department;
}
