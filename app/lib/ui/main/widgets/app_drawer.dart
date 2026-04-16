import 'package:domain/domain.dart';
import 'package:get_it/get_it.dart';

import '../../../app.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final navigator = GetIt.instance.get<AppNavigator>();

    return Drawer(
      backgroundColor: AppColors.current.whiteColor,
      child: SafeArea(
        child: Column(
          children: [
            _buildHeader(context),
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  _buildMenuItem(
                    context,
                    icon: Icons.person_add,
                    title: 'Tạo tài khoản',
                    onTap: () {
                      Navigator.pop(context);
                      // TODO: Navigate to create account page
                      // navigator.push(const AppRouteInfo.createAccount());
                    },
                  ),
                  _buildMenuItem(
                    context,
                    icon: Icons.meeting_room,
                    title: 'Phòng ban',
                    onTap: () async{
                      Navigator.pop(context);
                     await navigator.push(const AppRouteInfo.createDepartment());
                    },
                  ),
                  _buildMenuItem(
                    context,
                    icon: Icons.code,
                    title: 'Tạo mã nghỉ phép',
                    onTap: () {
                      Navigator.pop(context);
                      // TODO: Navigate to create leave code page
                      // navigator.push(const AppRouteInfo.createLeaveCode());
                    },
                  ),
                  Divider(
                    height: Dimens.d1.responsive(),
                    color: AppColors.current.secondaryTextColor
                        .withValues(alpha: 0.2),
                  ),
                  _buildMenuItem(
                    context,
                    icon: Icons.settings,
                    title: 'Cài đặt',
                    onTap: () {
                      Navigator.pop(context);
                      // TODO: Navigate to settings page
                    },
                  ),
                ],
              ),
            ),
            _buildFooter(context),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(Dimens.d24.responsive()),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xFF667eea),
            Color(0xFF764ba2),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: Dimens.d60.responsive(),
            height: Dimens.d60.responsive(),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.current.whiteColor,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.2),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Icon(
              Icons.admin_panel_settings,
              size: Dimens.d32.responsive(),
              color: const Color(0xFF667eea),
            ),
          ),
          SizedBox(height: Dimens.d16.responsive()),
          Text(
            'Quản trị viên',
            style: AppTextStyles.titleTextDefault(
              fontSize: Dimens.d20.responsive(),
              fontWeight: FontWeight.bold,
              color: AppColors.current.whiteColor,
            ),
          ),
          SizedBox(height: Dimens.d4.responsive()),
          Text(
            'Quản lý hệ thống',
            style: AppTextStyles.titleTextDefault(
              fontSize: Dimens.d14.responsive(),
              color: AppColors.current.whiteColor.withValues(alpha: 0.9),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Container(
        width: Dimens.d40.responsive(),
        height: Dimens.d40.responsive(),
        decoration: BoxDecoration(
          color: const Color(0xFF667eea).withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(Dimens.d12.responsive()),
        ),
        child: Icon(
          icon,
          color: const Color(0xFF667eea),
          size: Dimens.d20.responsive(),
        ),
      ),
      title: Text(
        title,
        style: AppTextStyles.titleTextDefault(
          fontSize: Dimens.d15.responsive(),
          fontWeight: FontWeight.w600,
          color: AppColors.current.blackColor,
        ),
      ),
      trailing: Icon(
        Icons.chevron_right,
        color: AppColors.current.secondaryTextColor,
        size: Dimens.d20.responsive(),
      ),
      onTap: onTap,
      contentPadding: EdgeInsets.symmetric(
        horizontal: Dimens.d20.responsive(),
        vertical: Dimens.d4.responsive(),
      ),
    );
  }

  Widget _buildFooter(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(Dimens.d16.responsive()),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: AppColors.current.secondaryTextColor.withValues(alpha: 0.2),
            width: 1,
          ),
        ),
      ),
      child: Column(
        children: [
          Text(
            'CÔNG CÁN v1.0.0',
            style: AppTextStyles.titleTextDefault(
              fontSize: Dimens.d12.responsive(),
              color: AppColors.current.secondaryTextColor,
            ),
          ),
          SizedBox(height: Dimens.d4.responsive()),
          Text(
            '© 2024 SONDT DEV',
            style: AppTextStyles.titleTextDefault(
              fontSize: Dimens.d11.responsive(),
              color: AppColors.current.secondaryTextColor,
            ),
          ),
        ],
      ),
    );
  }
}
