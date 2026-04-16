import 'dart:async';

import 'package:domain/domain.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../app.dart';
import 'main.dart';

@Injectable()
class MainBloc extends BaseBloc<MainEvent, MainState> {
  MainBloc(this._repository) : super(const MainState()) {
    on<MainPageInitiated>(
      _onMainPageInitiated,
      transformer: log(),
    );
  }
  final Repository _repository;

  FutureOr<void> _onMainPageInitiated(
      MainPageInitiated event, Emitter<MainState> emit) async {
    await runBlocCatching(
        handleLoading: false,
        action: () async {
          final user = _repository.getUserPreference();
          emit(state.copyWith(
            currentUser: user,
          ));
        });
  }
}
