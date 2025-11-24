import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:shared/shared.dart';

import '../../../app.dart';

part 'language_state.freezed.dart';

@freezed
class LanguageState extends BaseBlocState with _$LanguageState {
  const factory LanguageState({
    AppException? exception,
  }) = _LanguageState;
}
