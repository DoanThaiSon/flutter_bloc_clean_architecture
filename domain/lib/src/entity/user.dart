import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:shared/shared.dart';

import '../../domain.dart';

part 'user.freezed.dart';

@freezed
class User with _$User {
  const factory User({
    @Default(User.defaultId) String id,
    @Default(User.defaultEmail) String email,
    @Default(User.defaultName) String name,
    @Default(User.defaultEmployeeCode) String employeeCode,
    @Default(User.defaultBirthday) DateTime? birthday,
    @Default(User.defaultPhoneNumber) String phoneNumber,
    @Default(User.defaultAvatar) ImageUrl avatar,
    @Default(User.defaultGender) Gender gender,
    @Default(User.defaultJoinDate) DateTime? joinDate,
    @Default(User.defaultDepartment) Department? department,
    @Default(User.defaultRole) String role,
    @Default(User.defaultIsManager) bool isManager,
    @Default(User.defaultManagedDepartments)
    List<Department>? managedDepartments,
  }) = _User;

  static const defaultId = '';
  static const defaultEmail = '';
  static const defaultName = '';
  static const defaultEmployeeCode = '';
  static const defaultPhoneNumber = '';
  static const DateTime? defaultBirthday = null;
  static const defaultAvatar = ImageUrl();
  static const defaultGender = Gender.defaultValue;
  static const DateTime? defaultJoinDate = null;
  static const defaultDepartment = Department();
  static const defaultRole = 'user';
  static const defaultIsManager = false;
  static const List<Department> defaultManagedDepartments = [];
}
