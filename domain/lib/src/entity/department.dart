import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain.dart';

part 'department.freezed.dart';


@freezed
class DepartmentDetailResponseData with _$DepartmentDetailResponseData {
  const factory DepartmentDetailResponseData({
    @Default('') String status,
    @Default('') String message,
    Department? department,
  }) = _DepartmentDetailResponseData;
}

@freezed
class Department with _$Department {
  const factory Department({
    @Default('') String id,
    @Default('') String name,
    @Default('') String code,
    @Default('') String description,
    @Default('') String managerId,
    User? manager
  }) = _Department;
}
