import 'package:auto_route/auto_route.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:resources/resources.dart';
import 'package:shared/shared.dart';
import '../../app.dart';
import '../../common_view/common_text_field.dart';
import '../../common_view/ui_button.dart';
import 'bloc/attendance_login.dart';

@RoutePage()
class AttendanceLoginPage extends StatefulWidget {
  const AttendanceLoginPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _AttendanceLoginPageState();
  }
}

class _AttendanceLoginPageState
    extends BasePageState<AttendanceLoginPage, AttendanceLoginBloc> {
  final TextEditingController _employeeIdController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _employeeIdController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget buildPage(BuildContext context) {
    return CommonScaffold(
      hideKeyboardWhenTouchOutside: true,
      backgroundColor: AppColors.current.backgroundLayer1,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(Dimens.d24.responsive()),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildLogo(),
                SizedBox(height: Dimens.d32.responsive()),
                _buildTitle(),
                SizedBox(height: Dimens.d8.responsive()),
                _buildSubtitle(),
                SizedBox(height: Dimens.d48.responsive()),
                _buildLoginForm(),
                SizedBox(height: Dimens.d24.responsive()),
                _buildForgotPassword(),
                SizedBox(height: Dimens.d32.responsive()),
                _buildLoginButton(),
                SizedBox(height: Dimens.d16.responsive()),
                _buildFooter(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLogo() {
    return Image.asset(
      Assets.images.icons.overtime.path,
      width: Dimens.d100.responsive(),
      height: Dimens.d100.responsive(),
    );
  }

  Widget _buildTitle() {
    return Text(
      'Chấm công',
      style: AppTextStyles.titleTextDefault(
        fontSize: Dimens.d28.responsive(),
        fontWeight: FontWeight.w700,
        color: AppColors.current.blackColor,
      ),
    );
  }

  Widget _buildSubtitle() {
    return Text(
      'Hệ thống quản lý thời gian hiện đại',
      style: AppTextStyles.titleTextDefault(
        fontSize: Dimens.d14.responsive(),
        fontWeight: FontWeight.w400,
        color: AppColors.current.secondaryTextColor,
      ),
    );
  }

  Widget _buildLoginForm() {
    return Container(
      padding: EdgeInsets.all(Dimens.d24.responsive()),
      decoration: BoxDecoration(
        color: AppColors.current.whiteColor,
        borderRadius: BorderRadius.circular(Dimens.d16.responsive()),
        boxShadow: [
          BoxShadow(
            color: AppColors.current.blackColor.withValues(alpha: 0.05),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Mã nhân viên',
            style: AppTextStyles.titleTextDefault(
              fontSize: Dimens.d14.responsive(),
              fontWeight: FontWeight.w600,
              color: AppColors.current.blackColor,
            ),
          ),
          SizedBox(height: Dimens.d8.responsive()),
          CommonTextField(
            controller: _employeeIdController,
            height: Dimens.d56.responsive(),
            hintText: 'VD: NV12345',
            keyboardType: TextInputType.text,
            onChanged: (value) =>
                bloc.add(EmployeeIdChanged(employeeId: value)),
            hintStyle: AppTextStyles.titleTextDefault(
              fontSize: Dimens.d14.responsive(),
              fontWeight: FontWeight.w400,
              color: AppColors.current.secondaryTextColor,
            ),
            textStyle: AppTextStyles.titleTextDefault(
              fontSize: Dimens.d14.responsive(),
              fontWeight: FontWeight.w400,
              color: AppColors.current.blackColor,
            ),
            borderColor: AppColors.current.borderDefaultColor,
            prefixIcon: Icon(
              Icons.badge_outlined,
              size: Dimens.d20.responsive(),
              color: AppColors.current.secondaryTextColor,
            ),
          ),
          SizedBox(height: Dimens.d20.responsive()),
          Text(
            'Mật khẩu',
            style: AppTextStyles.titleTextDefault(
              fontSize: Dimens.d14.responsive(),
              fontWeight: FontWeight.w600,
              color: AppColors.current.blackColor,
            ),
          ),
          SizedBox(height: Dimens.d8.responsive()),
          CommonTextField(
            controller: _passwordController,
            obscureText: _obscurePassword,
            height: Dimens.d56.responsive(),
            hintText: '••••••••',
            keyboardType: TextInputType.visiblePassword,
            onChanged: (value) => bloc.add(PasswordChanged(password: value)),
            hintStyle: AppTextStyles.titleTextDefault(
              fontSize: Dimens.d14.responsive(),
              fontWeight: FontWeight.w400,
              color: AppColors.current.secondaryTextColor,
            ),
            textStyle: AppTextStyles.titleTextDefault(
              fontSize: Dimens.d14.responsive(),
              fontWeight: FontWeight.w400,
              color: AppColors.current.blackColor,
            ),
            borderColor: AppColors.current.borderDefaultColor,
            prefixIcon: Icon(
              Icons.lock_outline,
              size: Dimens.d20.responsive(),
              color: AppColors.current.secondaryTextColor,
            ),
            suffixIcon: GestureDetector(
              onTap: () {
                setState(() {
                  _obscurePassword = !_obscurePassword;
                });
              },
              child: Icon(
                _obscurePassword ? Icons.visibility_off : Icons.visibility,
                size: Dimens.d20.responsive(),
                color: AppColors.current.secondaryTextColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildForgotPassword() {
    return Align(
      alignment: Alignment.centerRight,
      child: Text(
        'Quên mật khẩu?',
        style: AppTextStyles.titleTextDefault(
          fontSize: Dimens.d14.responsive(),
          fontWeight: FontWeight.w600,
          color: AppColors.current.blackColor,
        ),
      ),
    );
  }

  Widget _buildLoginButton() {
    return BlocBuilder<AttendanceLoginBloc, AttendanceLoginState>(
      buildWhen: (previous, current) =>
          previous.isLoginButtonEnabled != current.isLoginButtonEnabled ||
          previous.isLoading != current.isLoading,
      builder: (context, state) {
        return UIButton(
          height: Dimens.d56.responsive(),
          width: double.infinity,
          text: state.isLoading ? 'Đang đăng nhập...' : 'Đăng nhập',
          textSize: Dimens.d16.responsive(),
          fontWeight: FontWeight.w700,
          radius: Dimens.d12.responsive(),
          enableShadow: false,
          color: state.isLoginButtonEnabled && !state.isLoading
              ? AppColors.current.blackColor
              : AppColors.neutral400,
          textColor: AppColors.current.whiteColor,
          onTap: state.isLoginButtonEnabled && !state.isLoading
              ? () => bloc.add(const LoginButtonPressed())
              : null,
        );
      },
    );
  }

  Widget _buildFooter() {
    return Column(
      children: [
        Text(
          '© 2024 Bản quyền thuộc về Chấm Công Team.',
          style: AppTextStyles.titleTextDefault(
            fontSize: Dimens.d12.responsive(),
            fontWeight: FontWeight.w400,
            color: AppColors.current.secondaryTextColor,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: Dimens.d4.responsive()),
        Text(
          'Ứng dụng quản lý nhân sự chuyên nghiệp.',
          style: AppTextStyles.titleTextDefault(
            fontSize: Dimens.d12.responsive(),
            fontWeight: FontWeight.w400,
            color: AppColors.current.secondaryTextColor,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
