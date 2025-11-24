import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../app.dart';

part 'language_event.freezed.dart';

abstract class LanguageEvent extends BaseBlocEvent {
  const LanguageEvent();
}

@freezed
class LanguagePageInitiated extends LanguageEvent with _$LanguagePageInitiated {
  const factory LanguagePageInitiated() = _LanguagePageInitiated;
}
