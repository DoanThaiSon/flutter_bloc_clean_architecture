import 'package:domain/domain.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../base/bloc/base_bloc_state.dart';

part 'welcome_state.freezed.dart';

@freezed
class WelcomeState extends BaseBlocState with _$WelcomeState {
  const factory WelcomeState({
    @Default(0) int slideId,
    @Default([]) List<Slide> slides
  }) = _WelcomeState;
}
