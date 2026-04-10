import 'package:freezed_annotation/freezed_annotation.dart';

part 'preference_user_data.freezed.dart';
part 'preference_user_data.g.dart';

@freezed
class PreferenceUserData with _$PreferenceUserData {
  const factory PreferenceUserData({
    @JsonKey(name: 'id') required String id,
    @JsonKey(name: 'email') required String email,
    @JsonKey(name: 'name') @Default('') String name,
  }) = _PreferenceUserData;

  const PreferenceUserData._();

  factory PreferenceUserData.fromJson(Map<String, dynamic> json) =>
      _$PreferenceUserDataFromJson(json);
}
