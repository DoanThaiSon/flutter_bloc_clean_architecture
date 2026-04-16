import 'package:auto_route/auto_route.dart';
import 'package:domain/domain.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:resources/resources.dart';
import '../../app.dart';
import '../../common_view/common_confirm_dialog.dart';
import 'bloc/attendance_profile.dart';

@RoutePage()
class AttendanceProfilePage extends StatefulWidget {
  const AttendanceProfilePage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _AttendanceProfilePageState();
  }
}

class _AttendanceProfilePageState
    extends BasePageState<AttendanceProfilePage, AttendanceProfileBloc> {
  @override
  void initState() {
    super.initState();
    bloc.add(const AttendanceProfilePageInitiated());
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget buildPage(BuildContext context) {
    return CommonScaffold(
      backgroundColor: AppColors.current.backgroundLayer1,
      body: BlocBuilder<AttendanceProfileBloc, AttendanceProfileState>(
          builder: (context, state) {
        return SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                _buildProfileSection(state),
                SizedBox(height: Dimens.d24.responsive()),
                _buildAccountSettings(),
                SizedBox(height: Dimens.d16.responsive()),
                _buildDeleteAccount(),
                SizedBox(height: Dimens.d16.responsive()),
                _buildPrivacy(),
                SizedBox(height: Dimens.d16.responsive()),
                _buildLanguage(),
                SizedBox(height: Dimens.d24.responsive()),
                _buildLogoutButton(),
                SizedBox(height: Dimens.d16.responsive()),
                _buildVersionInfo(),
                SizedBox(height: Dimens.d24.responsive()),
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget _buildProfileSection(AttendanceProfileState state) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: Dimens.d16.responsive()),
      child: Column(
        children: [
          Stack(
            children: [
              Container(
                width: Dimens.d100.responsive(),
                height: Dimens.d100.responsive(),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppColors.current.blackColor,
                    width: Dimens.d3.responsive(),
                  ),
                  color: AppColors.current.whiteColor,
                ),
                child: Icon(
                  Icons.person,
                  size: Dimens.d50.responsive(),
                  color: AppColors.current.blackColor,
                ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  width: Dimens.d32.responsive(),
                  height: Dimens.d32.responsive(),
                  decoration: BoxDecoration(
                    color: AppColors.current.blackColor,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppColors.current.whiteColor,
                      width: Dimens.d2.responsive(),
                    ),
                  ),
                  child: Icon(
                    Icons.edit,
                    size: Dimens.d16.responsive(),
                    color: AppColors.current.whiteColor,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: Dimens.d16.responsive()),
          Text(
            state.user?.name ?? '',
            style: AppTextStyles.titleTextDefault(
              fontSize: Dimens.d20.responsive(),
              fontWeight: FontWeight.w700,
              color: AppColors.current.blackColor,
            ),
          ),
          SizedBox(height: Dimens.d8.responsive()),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildInfoChip('Email', state.user?.employeeCode ?? ''),
              SizedBox(width: Dimens.d16.responsive()),
              _buildInfoChip(
                'PHÒNG BAN',
                '${state.user?.department?.name ?? ''} (${state.user?.isManager == true ? 'CBQL' : 'Nhân viên'})',
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoChip(String label, String value) {
    return Column(
      children: [
        Text(
          label,
          style: AppTextStyles.titleTextDefault(
            fontSize: Dimens.d10.responsive(),
            fontWeight: FontWeight.w600,
            color: AppColors.current.secondaryTextColor,
          ),
        ),
        SizedBox(height: Dimens.d4.responsive()),
        Text(
          value,
          style: AppTextStyles.titleTextDefault(
            fontSize: Dimens.d14.responsive(),
            fontWeight: FontWeight.w700,
            color: AppColors.current.blackColor,
          ),
        ),
      ],
    );
  }

  Widget _buildAccountSettings() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: Dimens.d16.responsive()),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'CÀI ĐẶT TÀI KHOẢN',
            style: AppTextStyles.titleTextDefault(
              fontSize: Dimens.d12.responsive(),
              fontWeight: FontWeight.w600,
              color: AppColors.current.secondaryTextColor,
            ),
          ),
          SizedBox(height: Dimens.d12.responsive()),
          _buildSettingItem(
              icon: Icons.person_outline,
              title: 'Thông tin cá nhân',
              subtitle: 'Cập nhật hồ sơ & liên hệ',
              backgroundColor: AppColors.current.tertiaryColor,
              onTap: () {}),
          SizedBox(height: Dimens.d12.responsive()),
          _buildSettingItem(
              icon: Icons.lock_outline,
              title: 'Đổi mật khẩu',
              subtitle: 'Bảo mật tài khoản của bạn',
              backgroundColor: AppColors.current.tertiaryColor,
              onTap: () {}),
        ],
      ),
    );
  }

  Widget _buildDeleteAccount() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: Dimens.d16.responsive()),
      child: _buildSettingItem(
          icon: Icons.no_accounts_rounded,
          title: 'Xóa tài khoản',
          subtitle: 'Xóa vĩnh viễn tài khoản khi không còn sử dụng App',
          backgroundColor: AppColors.current.redColor.withValues(alpha: 0.1),
          iconColor: AppColors.current.redColor,
          onTap: () {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return CustomConfirmDialog(
                  icon: Image.asset(
                    Assets.images.icons.error.path,
                    width: Dimens.d46,
                    height: Dimens.d46,
                  ),
                  description: S.current.deleteAccountDescription,
                  confirmText: S.current.confirm,
                  colorConfirmButton: AppColors.current.redColor,
                  onConfirm: () async {
                    bloc.add(const LogoutButtonPressed());
                    await navigator.pop(useRootNavigator: true);
                  },
                  onCancel: () {
                    navigator.pop(useRootNavigator: true);
                  },
                );
              },
            );
          }),
    );
  }

  Widget _buildPrivacy() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: Dimens.d16.responsive()),
      child: _buildSettingItem(
          icon: Icons.security_rounded,
          title: 'Điều khoản và chính sách',
          subtitle: 'Chính sách bảo vệ quyền riêng tư',
          backgroundColor: AppColors.current.tertiaryColor,
          onTap: () {
            navigator.push(const AppRouteInfo.webView(
                url: 'https://phenikaa-x.com/privacy-policy',
                title: 'Điều khoản và chính sách'));
          }),
    );
  }

  Widget _buildLanguage() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: Dimens.d16.responsive()),
      child: _buildSettingItem(
          icon: Icons.translate,
          title: S.current.language,
          subtitle: 'Đổi ngôn ngữ của App',
          backgroundColor: AppColors.current.tertiaryColor,
          iconColor: AppColors.current.blackColor,
          onTap: () {
            navigator.push(const AppRouteInfo.language());
          }),
    );
  }

  Widget _buildSettingItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color backgroundColor,
    required Function() onTap,
    Color? iconColor,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(Dimens.d16.responsive()),
        decoration: BoxDecoration(
          color: AppColors.current.whiteColor,
          borderRadius: BorderRadius.circular(Dimens.d12.responsive()),
        ),
        child: Row(
          children: [
            Container(
              width: Dimens.d48.responsive(),
              height: Dimens.d48.responsive(),
              decoration: BoxDecoration(
                color: backgroundColor,
                borderRadius: BorderRadius.circular(Dimens.d12.responsive()),
              ),
              child: Icon(
                icon,
                size: Dimens.d24.responsive(),
                color: iconColor ?? AppColors.current.blackColor,
              ),
            ),
            SizedBox(width: Dimens.d12.responsive()),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTextStyles.titleTextDefault(
                      fontSize: Dimens.d14.responsive(),
                      fontWeight: FontWeight.w600,
                      color: AppColors.current.blackColor,
                    ),
                  ),
                  SizedBox(height: Dimens.d4.responsive()),
                  Text(
                    subtitle,
                    style: AppTextStyles.titleTextDefault(
                      fontSize: Dimens.d12.responsive(),
                      fontWeight: FontWeight.w400,
                      color: AppColors.current.secondaryTextColor,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right,
              color: AppColors.current.secondaryTextColor,
              size: Dimens.d20.responsive(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLogoutButton() {
    return GestureDetector(
      onTap: () async {
        await showDialog(
          context: context,
          builder: (BuildContext context) {
            return CustomConfirmDialog(
              icon: Image.asset(
                Assets.images.icons.triangleWarning.path,
                width: Dimens.d46,
                height: Dimens.d46,
              ),
              description: S.current.logoutConfirmationMessage,
              confirmText: S.current.confirm,
              colorConfirmButton: AppColors.current.blackColor,
              onConfirm: () async {
                bloc.add(const LogoutButtonPressed());
                await navigator.pop(useRootNavigator: true);
              },
              onCancel: () {
                navigator.pop(useRootNavigator: true);
              },
            );
          },
        );
      },
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: Dimens.d16.responsive()),
        child: Container(
          padding: EdgeInsets.all(Dimens.d16.responsive()),
          decoration: BoxDecoration(
            color: AppColors.current.redColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(Dimens.d12.responsive()),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.logout,
                color: AppColors.current.redColor,
                size: Dimens.d20.responsive(),
              ),
              SizedBox(width: Dimens.d8.responsive()),
              Text(
                'Đăng xuất',
                style: AppTextStyles.titleTextDefault(
                  fontSize: Dimens.d16.responsive(),
                  fontWeight: FontWeight.w700,
                  color: AppColors.current.redColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildVersionInfo() {
    return Text(
      'PHIÊN BẢN 2.4.0 (BUILD 120)',
      style: AppTextStyles.titleTextDefault(
        fontSize: Dimens.d11.responsive(),
        fontWeight: FontWeight.w400,
        color: AppColors.current.secondaryTextColor,
      ),
    );
  }
}
