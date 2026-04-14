import 'package:auto_route/auto_route.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:domain/domain.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../app.dart' hide getIt;
import '../../common_view/ui_button.dart';
import '../../services/location_service.dart';
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
  final CarouselSliderController _carouselController =
      CarouselSliderController();

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
    _requestLocationPermission();
  }

  Future<void> _requestLocationPermission() async {
    final locationService = getIt.get<LocationService>();
    await locationService.requestLocationPermission();
  }

  @override
  Widget buildPage(BuildContext context) {
    return CommonScaffold(
      backgroundColor: AppColors.current.whiteColor,
      body: SafeArea(
        child: _renderBodyWidget(context),
      ),
    );
  }

  Widget _renderBodyWidget(BuildContext context) {
    return BlocBuilder<WelcomeBloc, WelcomeState>(builder: (context, state) {
      return Column(
        children: [
          _buildHeader(context),
          Expanded(
            child: CarouselSlider(
              carouselController: _carouselController,
              items: [
                _buildSlide1(),
                _buildSlide2(),
                _buildSlide3(),
              ],
              options: CarouselOptions(
                height: double.infinity,
                viewportFraction: 1.0,
                enableInfiniteScroll: false,
                onPageChanged: (index, reason) {
                  bloc.add(PageChanged(slideIndex: index));
                },
              ),
            ),
          ),
          _buildBottomSection(state),
        ],
      );
    });
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: Dimens.d16.responsive(),
        vertical: Dimens.d12.responsive(),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'CÔNG CÁN',
            style: AppTextStyles.titleTextDefault(
              fontSize: Dimens.d20.responsive(),
              fontWeight: FontWeight.w700,
              color: AppColors.current.blackColor,
            ),
          ),
          TextButton(
            onPressed: () {
              navigator.replaceAll([const AppRouteInfo.loginAttendance()]);
            },
            child: Text(
              'Bỏ qua',
              style: AppTextStyles.titleTextDefault(
                fontSize: Dimens.d14.responsive(),
                fontWeight: FontWeight.w500,
                color: AppColors.current.secondaryTextColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSlide1() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: Dimens.d24.responsive()),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: Dimens.d300.responsive(),
            height: Dimens.d300.responsive(),
            decoration: BoxDecoration(
              color: const Color(0xFF5DAFB8),
              borderRadius: BorderRadius.circular(Dimens.d32.responsive()),
            ),
            child: Center(
              child: Image.asset(
                Assets.images.pictures.slide1.path,
                width: Dimens.d250.responsive(),
                height: Dimens.d250.responsive(),
                fit: BoxFit.contain,
              ),
            ),
          ),
          SizedBox(height: Dimens.d40.responsive()),
          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              style: AppTextStyles.titleTextDefault(
                fontSize: Dimens.d32.responsive(),
                fontWeight: FontWeight.w700,
                color: AppColors.current.blackColor,
              ),
              children: [
                const TextSpan(text: 'Chấm công '),
                TextSpan(
                  text: 'hiện đại',
                  style: AppTextStyles.titleTextDefault(
                    fontSize: Dimens.d32.responsive(),
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF0052CC),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: Dimens.d16.responsive()),
          Text(
            'Sử dụng công nghệ định vị và nhận diện để chấm công chính xác chỉ với một chạm.',
            textAlign: TextAlign.center,
            style: AppTextStyles.titleTextDefault(
              fontSize: Dimens.d14.responsive(),
              fontWeight: FontWeight.w400,
              color: AppColors.current.secondaryTextColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSlide2() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: Dimens.d24.responsive()),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: Dimens.d300.responsive(),
            height: Dimens.d300.responsive(),
            decoration: BoxDecoration(
              color: const Color(0xFF5DAFB8),
              borderRadius: BorderRadius.circular(Dimens.d32.responsive()),
            ),
            child: Center(
              child: Image.asset(
                Assets.images.pictures.slide2.path,
                width: Dimens.d250.responsive(),
                height: Dimens.d250.responsive(),
                fit: BoxFit.contain,
              ),
            ),
          ),
          SizedBox(height: Dimens.d40.responsive()),
          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              style: AppTextStyles.titleTextDefault(
                fontSize: Dimens.d32.responsive(),
                fontWeight: FontWeight.w700,
                color: AppColors.current.blackColor,
              ),
              children: [
                const TextSpan(text: 'Nghỉ phép\n'),
                TextSpan(
                  text: 'dễ dàng',
                  style: AppTextStyles.titleTextDefault(
                    fontSize: Dimens.d32.responsive(),
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF0052CC),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: Dimens.d16.responsive()),
          Text(
            'Gửi đơn xin nghỉ phép, theo dõi trạng thái phê duyệt và số ngày phép còn lại ngay trên ứng dụng.',
            textAlign: TextAlign.center,
            style: AppTextStyles.titleTextDefault(
              fontSize: Dimens.d14.responsive(),
              fontWeight: FontWeight.w400,
              color: AppColors.current.secondaryTextColor,
            ),
          ),
          // SizedBox(height: Dimens.d32.responsive()),
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.center,
          //   children: [
          //     _buildStatCard(
          //       icon: Icons.calendar_today,
          //       label: 'NGÀY CÒN LẠI',
          //       value: '12.5',
          //       color: const Color(0xFF0052CC),
          //     ),
          //     SizedBox(width: Dimens.d16.responsive()),
          //     _buildStatCard(
          //       icon: Icons.pending_actions,
          //       label: 'ĐANG CHỜ',
          //       value: '02',
          //       color: const Color(0xFFE53935),
          //     ),
          //   ],
          // ),
        ],
      ),
    );
  }

  Widget _buildSlide3() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: Dimens.d24.responsive()),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: Dimens.d300.responsive(),
            height: Dimens.d300.responsive(),
            decoration: BoxDecoration(
              color: const Color(0xFFF5F5F5),
              borderRadius: BorderRadius.circular(Dimens.d32.responsive()),
            ),
            child: Center(
              child: Image.asset(
                Assets.images.pictures.slide3.path,
                width: Dimens.d250.responsive(),
                height: Dimens.d250.responsive(),
                fit: BoxFit.contain,
              ),
            ),
          ),
          SizedBox(height: Dimens.d40.responsive()),
          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              style: AppTextStyles.titleTextDefault(
                fontSize: Dimens.d32.responsive(),
                fontWeight: FontWeight.w700,
                color: AppColors.current.blackColor,
              ),
              children: [
                const TextSpan(text: 'Thống kê '),
                TextSpan(
                  text: 'minh bạch',
                  style: AppTextStyles.titleTextDefault(
                    fontSize: Dimens.d32.responsive(),
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF0052CC),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: Dimens.d16.responsive()),
          Text(
            'Theo dõi lịch sử làm việc, số ngày công và hiệu suất làm việc của bạn một cách trực quan.',
            textAlign: TextAlign.center,
            style: AppTextStyles.titleTextDefault(
              fontSize: Dimens.d14.responsive(),
              fontWeight: FontWeight.w400,
              color: AppColors.current.secondaryTextColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomSection(WelcomeState state) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: Dimens.d24.responsive()),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(3, (index) {
              return Container(
                width: state.slideId == index
                    ? Dimens.d24.responsive()
                    : Dimens.d8.responsive(),
                height: Dimens.d8.responsive(),
                margin:
                    EdgeInsets.symmetric(horizontal: Dimens.d4.responsive()),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(Dimens.d4.responsive()),
                  color: state.slideId == index
                      ? const Color(0xFF0052CC)
                      : AppColors.current.secondaryTextColor
                          .withValues(alpha: 0.3),
                ),
              );
            }),
          ),
          SizedBox(height: Dimens.d24.responsive()),
          UIButton(
            width: double.infinity,
            height: Dimens.d56.responsive(),
            radius: Dimens.d28.responsive(),
            color: const Color(0xFF0052CC),
            text: state.slideId == 2 ? 'Bắt đầu ngay' : 'Tiếp tục',
            textSize: Dimens.d16.responsive(),
            fontWeight: FontWeight.w600,
            onTap: () {
              if (state.slideId == 2) {
                navigator.replaceAll([const AppRouteInfo.loginAttendance()]);
              } else {
                _carouselController.nextPage(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                );
              }
            },
          ),
          SizedBox(height: Dimens.d16.responsive()),
          Text(
            'SONDT DEV © 2024',
            style: AppTextStyles.titleTextDefault(
              fontSize: Dimens.d11.responsive(),
              fontWeight: FontWeight.w500,
              color: AppColors.current.secondaryTextColor,
            ),
          ),
        ],
      ),
    );
  }
}
