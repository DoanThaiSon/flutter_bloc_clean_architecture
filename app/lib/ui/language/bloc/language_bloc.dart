import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../app.dart';
import 'language_event.dart';
import 'language_state.dart';

@Injectable()
class LanguageBloc extends BaseBloc<LanguageEvent, LanguageState> {
  LanguageBloc() : super(const LanguageState()) {
    on<LanguagePageInitiated>(
      _onLanguagePageInitiated,
      transformer: log(),
    );
  }


  FutureOr<void> _onLanguagePageInitiated(
    LanguagePageInitiated event,
    Emitter<LanguageState> emit,
  ) async {
    await runBlocCatching(action: () async {});
  }
}
