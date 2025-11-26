import 'package:auto_route/auto_route.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:domain/domain.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared/shared.dart';

import '../../app.dart';
import 'bloc/welcome.dart';

@RoutePage(name: 'WelcomePageRoute')
class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _WelcomePageState();
  }
}

class _WelcomePageState extends BasePageState<WelcomePage, WelcomeBloc> {
  @override
  void initState() {
    bloc.add(const WelcomePageInitiated(slideIndex: 0));
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
      ),
    );
  }

  @override
  Widget buildPage(BuildContext context) {
    return CommonScaffold(
      body: Center(
        child: _renderBodyWidget(context),
      ),
    );
  }

  Widget _renderBodyWidget(BuildContext context) {
    final double deviceWidth = context.deviceWidth;
    final double deviceHeight = context.deviceHeight;

    return BlocBuilder<WelcomeBloc, WelcomeState>(builder: (context, state) {
      final slides = state.slides;
      return Container(
        width: deviceWidth,
        height: deviceHeight,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(Assets.images.pictures.background.path),
            fit: BoxFit.cover,
          ),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            CarouselSlider(
              items: slides.map((item) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    AssetGenImage(item.image).image(),
                    Text(
                      textAlign: TextAlign.center,
                      item.title,
                      style: AppTextStyles.title1SemiBold(color: AppColors.current.primaryTextColor),
                    ),
                   const SizedBox(height: Dimens.d8,),
                    SizedBox(
                      width: deviceWidth - 48,
                      child: Column(children: [
                        if (item.id == 0) ...[
                          RichText(
                            textAlign: TextAlign.center,
                            text: TextSpan(
                              style: AppTextStyles.body2Medium(
                                  color: AppColors.current.secondaryTextColor),
                              children: [
                                // TextSpan(
                                //   text: 'Xin chào',
                                // ),
                                // TextSpan(
                                //   text: ' Đây là tiêu đề!\n',
                                //   style: AppTextStyles.body2Medium(color: AppColors.current.textFocusColor),
                                // ),
                                // TextSpan(
                                //   text: 'Đây là nội dung',
                                // ),
                              ],
                            ),
                          )
                        ] else ...[
                          Text(
                            textAlign: TextAlign.center,
                            item.description,
                            style: TextStyle(
                              color: AppColors.current.secondaryColor,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ]),
                    ),
                  ],
                );
              }).toList(),
              options: CarouselOptions(
                enlargeFactor: 0.1,
                enlargeCenterPage: true,
                height: deviceHeight - (kToolbarHeight * 2),
                // autoPlay: true,
                aspectRatio: 16 / 9,
                viewportFraction: 1,
                enableInfiniteScroll: false,
                onPageChanged: (index, reason) {
                  bloc.add(PageChanged(slideIndex: index));
                },
              ),
            ),
            Positioned(
              top: kToolbarHeight * 1.8,
              child: Row(
                children: <Widget>[
                  AssetGenImage(Assets.images.icons.xIcon.path).image(
                    height: 24,
                    fit: BoxFit.contain,
                  ),
                  const SizedBox(height: Dimens.d4,),
                  Text(
                    'PHENIKAA-X ',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: AppColors.current.primaryColor,
                    ),
                  ),
                  Text(
                    'DRIVE',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: AppColors.current.orange500Color,
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              bottom: deviceWidth / 4,
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: slides.asMap().entries.map((entry) {
                    final index = entry.key;
                    return GestureDetector(
                      onTap: () {
                        bloc.add(PageChanged(slideIndex: index));
                      },
                      child: Container(
                        width: state.slideId == index ? 10.0 : 8.0,
                        height: state.slideId == index ? 10.0 : 8.0,
                        margin: const EdgeInsets.symmetric(horizontal: 6.0),
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color:
                                state.slideId == index ? AppColors.current.primaryColor : AppColors.current.grayColor),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
            Positioned(
              bottom: 28,
              child: SizedBox(
                width: deviceWidth - 32,
                child: Button(
                  title: 'Bắt đầu',
                  onPressed: () {
                    navigator.replaceAll([const AppRouteInfo.login()]);
                  },
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}
