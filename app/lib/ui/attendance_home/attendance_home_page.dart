import 'package:auto_route/auto_route.dart';
import 'package:domain/domain.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared/shared.dart';
import '../../app.dart';
import '../../common_view/popup/common_show_snack_bar.dart';
import '../../common_view/ui_button.dart';
import '../../services/location_service.dart';
import 'bloc/attendance_home.dart';

@RoutePage()
class AttendanceHomePage extends StatefulWidget {
  const AttendanceHomePage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _AttendanceHomePageState();
  }
}

class _AttendanceHomePageState
    extends BasePageState<AttendanceHomePage, AttendanceHomeBloc>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    bloc.add(const AttendanceHomePageInitiated());
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      bloc.add(const CheckLocationPermission());
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    bloc.add(const CheckLocationPermission());
  }

  @override
  Widget buildPage(BuildContext context) {
    return CommonScaffold(
      backgroundColor: AppColors.current.backgroundLayer1,
      body: BlocConsumer<AttendanceHomeBloc, AttendanceHomeState>(
          listener: (context, state) {
            if (state.checkInStatus == LoadDataStatus.success ||
                state.checkOutStatus == LoadDataStatus.success) {
              showAppSnackBar(
                context,
                message: 'Chấm công thành công',
                backgroundColor: AppColors.current.blackColor,
              );
            }
          },
          buildWhen: (previous, current) =>
              previous.currentTime != current.currentTime ||
              previous.user != current.user ||
              previous.locationPermissionStatus !=
                  current.locationPermissionStatus ||
              previous.checkInStatus != current.checkInStatus ||
              previous.checkOutStatus != current.checkOutStatus ||
              previous.attendance?.checkInTime !=
                  current.attendance?.checkInTime ||
              previous.attendance?.checkOutTime !=
                  current.attendance?.checkOutTime ||
              previous.attendance?.timeline != current.attendance?.timeline,
          builder: (context, state) {
            return SafeArea(
              child: RefreshIndicator(
                color: AppColors.current.blackColor,
                backgroundColor: AppColors.current.whiteColor,
                onRefresh: () async {
                  bloc.add(const AttendanceHomePageInitiated());
                },
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Padding(
                    padding: EdgeInsets.all(Dimens.d16.responsive()),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildHeader(state),
                        SizedBox(height: Dimens.d24.responsive()),
                        _buildDateDisplay(),
                        SizedBox(height: Dimens.d24.responsive()),
                        _buildTimeCard(state),
                        SizedBox(
                          height: Dimens.d24.responsive(),
                        ),
                        _buildWorkManagement(state)
                      ],
                    ),
                  ),
                ),
              ),
            );
          }),
    );
  }

  Widget _buildHeader(AttendanceHomeState state) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Container(
              width: Dimens.d40.responsive(),
              height: Dimens.d40.responsive(),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.current.blackColor,
              ),
              child: Icon(
                Icons.person,
                color: AppColors.current.whiteColor,
                size: Dimens.d24.responsive(),
              ),
            ),
            SizedBox(
              width: Dimens.d10.responsive(),
            ),
            _buildGreeting(state),
          ],
        ),
        Icon(
          Icons.notifications,
          color: AppColors.current.blackColor,
          size: Dimens.d24.responsive(),
        ),
      ],
    );
  }

  Widget _buildGreeting(AttendanceHomeState state) {
    return Text(
      'Xin chào, ${state.user?.name}',
      style: AppTextStyles.titleTextDefault(
        fontSize: Dimens.d14.responsive(),
        fontWeight: FontWeight.bold,
        color: AppColors.current.blackColor,
      ),
    );
  }

  Widget _buildDateDisplay() {
    final formattedDate = DateTime.now().toVietnameseDateString();

    return Text(
      formattedDate,
      style: AppTextStyles.titleTextDefault(
        fontSize: Dimens.d24.responsive(),
        fontWeight: FontWeight.w700,
        color: AppColors.current.blackColor,
      ),
    );
  }

  Widget _buildTimeCard(AttendanceHomeState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Chấm công',
          style: AppTextStyles.titleTextDefault(fontWeight: FontWeight.bold),
        ),
        SizedBox(
          height: Dimens.d10.responsive(),
        ),
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(Dimens.d24.responsive()),
          decoration: BoxDecoration(
            color: AppColors.current.whiteColor,
            borderRadius: BorderRadius.circular(Dimens.d24.responsive()),
            boxShadow: [
              BoxShadow(
                color: AppColors.current.blackColor.withValues(alpha: 0.05),
                blurRadius: 20,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: [
              Text(
                state.currentTime,
                style: AppTextStyles.titleTextDefault(
                  fontSize: Dimens.d56.responsive(),
                  fontWeight: FontWeight.w700,
                  color: AppColors.current.blackColor,
                ),
              ),
              SizedBox(
                height: Dimens.d24.responsive(),
              ),
              _buildCheckInOutButtons(state),
            ],
          ),
        ),
      ],
    );
  }

  String _formatTime(DateTime? dateTime) {
    if (dateTime == null) {
      return '--:--';
    } else {
      final hour = dateTime.hour.toString().padLeft(2, '0');
      final minute = dateTime.minute.toString().padLeft(2, '0');

      return '$hour:$minute';
    }
  }

  String formatWorkingHours(double hours) {
    if (hours == 0) {
      return '--:--';
    } else {
      final int h = hours.floor();
      final int m = ((hours - h) * 60).round();

      return '${h}h${m}';
    }
  }

  Widget _buildCheckInOutButtons(AttendanceHomeState state) {
    final isLocationDenied =
        state.locationPermissionStatus == LocationPermissionStatus.denied ||
            state.locationPermissionStatus ==
                LocationPermissionStatus.deniedForever ||
            state.locationPermissionStatus ==
                LocationPermissionStatus.serviceDisabled;

    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _buildActionButton(
                icon: Icons.login,
                label: 'GIỜ VÀO',
                colorIcon: AppColors.current.blackColor,
                textColor: AppColors.current.blackColor,
                time: _formatTime(state.attendance?.checkInTime),
              ),
            ),
            SizedBox(width: Dimens.d16.responsive()),
            Expanded(
              child: _buildActionButton(
                icon: Icons.logout,
                colorIcon: AppColors.current.redColor,
                label: 'GIỜ RA',
                textColor: AppColors.current.redColor,
                time: _formatTime(state.attendance?.checkOutTime),
              ),
            ),
            SizedBox(width: Dimens.d16.responsive()),
            Expanded(
              child: _buildActionButton(
                icon: Icons.access_time,
                colorIcon: AppColors.current.completeTextColor,
                label: 'GIỜ LÀM',
                textColor: AppColors.current.completeTextColor,
                time: formatWorkingHours(state.attendance?.workingHours ?? 0),
              ),
            ),
          ],
        ),
        SizedBox(
          height: Dimens.d24.responsive(),
        ),
        UIButton(
          radius: Dimens.d16.responsive(),
          color: isLocationDenied
              ? AppColors.current.secondaryTextColor
              : AppColors.current.blackColor,
          text: 'Chấm công',
          isLoading: state.checkInStatus == LoadDataStatus.loading ||
              state.checkOutStatus == LoadDataStatus.loading,
          onTap: isLocationDenied
              ? null
              : () {
                  if (state.attendance?.checkInTime == null) {
                    bloc.add(const CheckInButtonPressed());
                  } else {
                    bloc.add(const CheckoutButtonPressed());
                  }
                },
        ),
        if (isLocationDenied) ...[
          SizedBox(height: Dimens.d16.responsive()),
          _buildLocationPermissionWarning(state),
        ],
      ],
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required String time,
    Color? colorIcon,
    Color? textColor,
  }) {
    return Container(
      padding: EdgeInsets.all(Dimens.d8.responsive()),
      decoration: BoxDecoration(
        color: AppColors.current.backgroundLayer1,
        borderRadius: BorderRadius.circular(Dimens.d16.responsive()),
      ),
      child: Column(
        children: [
          IntrinsicHeight(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Expanded(
                  child: Icon(
                    icon,
                    size: Dimens.d16.responsive(),
                    color: colorIcon ?? AppColors.current.secondaryTextColor,
                  ),
                ),
                Expanded(
                  child: Center(
                    child: Text(
                      label,
                      style: AppTextStyles.titleTextDefault(
                        fontSize: Dimens.d12.responsive(),
                        fontWeight: FontWeight.w600,
                        color:
                            textColor ?? AppColors.current.secondaryTextColor,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: Dimens.d8.responsive()),
          Text(
            time,
            style: AppTextStyles.titleTextDefault(
              fontSize: Dimens.d18.responsive(),
              fontWeight: FontWeight.w700,
              color: AppColors.current.blackColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLocationPermissionWarning(AttendanceHomeState state) {
    String message =
        'Quyền truy cập vị trí bị từ chối. Ứng dụng cần quyền truy cập vị trí để hoạt động. Vui lòng cấp quyền trong cài đặt.';

    if (state.locationPermissionStatus ==
        LocationPermissionStatus.serviceDisabled) {
      message =
          'Dịch vụ định vị đang tắt. Vui lòng bật GPS trong cài đặt thiết bị.';
    }

    return Container(
      padding: EdgeInsets.all(Dimens.d16.responsive()),
      decoration: BoxDecoration(
        color: AppColors.current.redColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(Dimens.d12.responsive()),
        border: Border.all(
          color: AppColors.current.blackColor.withValues(alpha: 0.5),
          width: Dimens.d1.responsive(),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            message,
            style: AppTextStyles.titleTextDefault(
                fontSize: Dimens.d13.responsive(),
                color: AppColors.current.blackColor,
                fontWeight: FontWeight.w500),
          ),
          SizedBox(height: Dimens.d12.responsive()),
          SizedBox(
            width: double.infinity,
            child: UIButton(
              radius: Dimens.d12.responsive(),
              color: AppColors.current.whiteColor,
              text: 'Cài đặt',
              textColor: AppColors.current.blackColor,
              height: Dimens.d40.responsive(),
              onTap: () {
                bloc.add(const OpenLocationSettings());
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAction(
      {required Function()? onTap,
      required String icon,
      required String actionName}) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: Dimens.d50.responsive(),
            height: Dimens.d50.responsive(),
            padding: EdgeInsets.all(Dimens.d8.responsive()),
            decoration: const BoxDecoration(
              color: AppColors.neutral100,
              shape: BoxShape.circle,
            ),
            child: Padding(
              padding: EdgeInsets.all(Dimens.d4.responsive()),
              child: Image.asset(
                icon,
                width: Dimens.d30.responsive(),
                height: Dimens.d30.responsive(),
              ),
            ),
          ),
          SizedBox(
            height: Dimens.d5.responsive(),
          ),
          Text(
            actionName,
            style: AppTextStyles.titleTextDefault(
                fontWeight: FontWeight.w600,
                color: AppColors.current.blackColor),
          )
        ],
      ),
    );
  }

  Widget _buildWorkManagement(AttendanceHomeState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quản lý công việc',
          style: AppTextStyles.titleTextDefault(fontWeight: FontWeight.bold),
        ),
        SizedBox(
          height: Dimens.d10.responsive(),
        ),
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(Dimens.d24.responsive()),
          decoration: BoxDecoration(
            color: AppColors.current.whiteColor,
            borderRadius: BorderRadius.circular(Dimens.d16.responsive()),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildAction(
                  onTap: () =>
                      navigator.push(const AppRouteInfo.leaveRequest()),
                  icon: Assets.images.icons.healthCheck.path,
                  actionName: 'Xin nghỉ'),
              SizedBox(
                width: Dimens.d24.responsive(),
              ),
              _buildAction(
                  onTap: () {},
                  icon: Assets.images.icons.overtime.path,
                  actionName: 'Làm thêm'),
              SizedBox(
                width: Dimens.d24.responsive(),
              ),
              _buildAction(
                  onTap: () {},
                  icon: Assets.images.icons.workFromHome.path,
                  actionName: 'Làm từ xa'),
            ],
          ),
        ),
      ],
    );
  }
}
