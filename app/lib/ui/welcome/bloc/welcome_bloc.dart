import 'dart:async';

import 'package:domain/domain.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../app.dart';
import 'welcome.dart';

@Injectable()
class WelcomeBloc extends BaseBloc<WelcomeEvent, WelcomeState> {
  WelcomeBloc(this.saveIsFirstLaunchAppUseCase) : super(const WelcomeState()) {
    on<WelcomePageInitiated>(
      _onWelcomePageInitiated,
      transformer: log(),
    );

    on<PageChanged>(
      _onPageChanged,
      transformer: log(),
    );
  }
  final SaveIsFirstLaunchAppUseCase saveIsFirstLaunchAppUseCase;

  final List<Slide> slides = [
    Slide(
        0,
        'Tiện lợi và An toàn Tuyệt Đối',
        'Chào mừng đến với PhenikaaXDrive!\nTrải nghiệm sự tự do tuyệt đối với dịch vụ đặt xe tự lái',
        Assets.images.pictures.slide1.path),
    Slide(1, 'Đặt xe dễ dàng', 'Theo dõi hành trình, điều chỉnh điểm đến, và trải nghiệm sự khác biệt, đón đầu xu thế',
        Assets.images.pictures.slide2.path),
    Slide(
        2,
        'Tận hưởng hành trình',
        'Tận hưởng hành trình thoải mái, góp phần xây dựng một thành phố xanh và thông minh hơn. Bắt đầu ngay!',
        Assets.images.pictures.slide3.path)
  ];

  FutureOr<void> _onWelcomePageInitiated(WelcomePageInitiated event, Emitter<WelcomeState> emit) async {
    await saveIsFirstLaunchAppUseCase.execute(const SaveIsFirstLaunchAppInput(isFirstLaunchApp: true));
    emit(state.copyWith(slideId: event.slideIndex, slides: slides));
  }

  FutureOr<void> _onPageChanged(PageChanged event, Emitter<WelcomeState> emit) {
    emit(state.copyWith(slideId: event.slideIndex));
  }
}
