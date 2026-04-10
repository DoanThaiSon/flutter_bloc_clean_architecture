import 'package:auto_route/auto_route.dart';
import '../../app.dart';
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
  Widget buildPage(BuildContext context) {
    return CommonScaffold(
      backgroundColor: AppColors.current.backgroundLayer1,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              _buildHeader(),
              SizedBox(height: Dimens.d24.responsive()),
              _buildProfileSection(),
              SizedBox(height: Dimens.d24.responsive()),
              _buildAccountSettings(),
              SizedBox(height: Dimens.d16.responsive()),
              _buildNotificationSettings(),
              SizedBox(height: Dimens.d16.responsive()),
              _buildCompanyPolicy(),
              SizedBox(height: Dimens.d16.responsive()),
              _buildHelpSection(),
              SizedBox(height: Dimens.d24.responsive()),
              _buildLogoutButton(),
              SizedBox(height: Dimens.d16.responsive()),
              _buildVersionInfo(),
              SizedBox(height: Dimens.d24.responsive()),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.all(Dimens.d16.responsive()),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                width: Dimens.d40.responsive(),
                height: Dimens.d40.responsive(),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.current.blue500Color,
                ),
                child: Icon(
                  Icons.person,
                  color: AppColors.current.whiteColor,
                  size: Dimens.d24.responsive(),
                ),
              ),
              SizedBox(width: Dimens.d12.responsive()),
              Text(
                'Chấm công',
                style: AppTextStyles.titleTextDefault(
                  fontSize: Dimens.d18.responsive(),
                  fontWeight: FontWeight.w700,
                  color: AppColors.current.blue500Color,
                ),
              ),
            ],
          ),
          Icon(
            Icons.notifications,
            color: AppColors.current.blue500Color,
            size: Dimens.d24.responsive(),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileSection() {
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
                    color: AppColors.current.blue500Color,
                    width: 3,
                  ),
                  color: AppColors.current.whiteColor,
                ),
                child: Icon(
                  Icons.person,
                  size: Dimens.d50.responsive(),
                  color: AppColors.current.blue500Color,
                ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  width: Dimens.d32.responsive(),
                  height: Dimens.d32.responsive(),
                  decoration: BoxDecoration(
                    color: AppColors.current.blue500Color,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppColors.current.whiteColor,
                      width: 2,
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
            'Nguyễn Minh Quân',
            style: AppTextStyles.titleTextDefault(
              fontSize: Dimens.d20.responsive(),
              fontWeight: FontWeight.w700,
              color: AppColors.current.primaryTextColor,
            ),
          ),
          SizedBox(height: Dimens.d8.responsive()),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildInfoChip('MÃ NHÂN VIÊN', 'VN-88291'),
              SizedBox(width: Dimens.d16.responsive()),
              _buildInfoChip('PHÒNG BAN', 'Kỹ thuật'),
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
            color: AppColors.current.blue500Color,
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
          ),
          SizedBox(height: Dimens.d12.responsive()),
          _buildSettingItem(
            icon: Icons.lock_outline,
            title: 'Đổi mật khẩu',
            subtitle: 'Bảo mật tài khoản của bạn',
            backgroundColor: AppColors.current.tertiaryColor,
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationSettings() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: Dimens.d16.responsive()),
      child: _buildSettingItem(
        icon: Icons.notifications_outlined,
        title: 'Cài đặt thông báo',
        subtitle: 'Chương, rung & đẩy',
        backgroundColor: AppColors.current.orangeColor.withValues(alpha: 0.1),
        iconColor: AppColors.current.orangeColor,
      ),
    );
  }

  Widget _buildCompanyPolicy() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: Dimens.d16.responsive()),
      child: _buildSettingItem(
        icon: Icons.business_outlined,
        title: 'Chính sách công ty',
        subtitle: 'Quy định & Chỉ đạo',
        backgroundColor: AppColors.current.tertiaryColor,
      ),
    );
  }

  Widget _buildHelpSection() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: Dimens.d16.responsive()),
      child: _buildSettingItem(
        icon: Icons.help_outline,
        title: 'Trợ giúp',
        subtitle: 'Hướng dẫn sử dụng & Hỗ trợ kỹ thuật',
        backgroundColor: AppColors.current.blue500Color.withValues(alpha: 0.1),
        iconColor: AppColors.current.blue500Color,
      ),
    );
  }

  Widget _buildSettingItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color backgroundColor,
    Color? iconColor,
  }) {
    return Container(
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
              color: iconColor ?? AppColors.current.blue500Color,
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
                    color: AppColors.current.primaryTextColor,
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
    );
  }

  Widget _buildLogoutButton() {
    return Padding(
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
