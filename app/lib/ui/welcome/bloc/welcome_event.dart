import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../app.dart';

part 'welcome_event.freezed.dart';

abstract class WelcomeEvent extends BaseBlocEvent {
  const WelcomeEvent();
}

@freezed
class WelcomePageInitiated extends WelcomeEvent with _$WelcomePageInitiated {
  const factory WelcomePageInitiated({
    required int slideIndex,
  }) = _WelcomePageInitiated;

}

@freezed
class PageChanged extends WelcomeEvent with _$PageChanged {
  const factory PageChanged({
    required int slideIndex,
  }) = _PageChanged;

}

