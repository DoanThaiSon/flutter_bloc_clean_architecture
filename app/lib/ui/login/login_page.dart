import 'package:auto_route/auto_route.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:resources/resources.dart';
import 'package:shared/shared.dart';
import '../../app.dart';
import '../../common_view/common_text_field.dart';
import '../../common_view/ui_button.dart';
import 'bloc/login.dart';

@RoutePage()
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _LoginPageState();
  }
}

class _LoginPageState extends BasePageState<LoginPage, LoginBloc> {
  final TextEditingController _emailAddressEditingController =
      TextEditingController();
  final TextEditingController _passwordEditingController =
      TextEditingController();
  bool _obscurePassword = true;

  @override
  void initState() {
    _emailAddressEditingController.addListener(() {
      setState(() {});
    });
    super.initState();
  }

  @override
  void dispose() {
    _emailAddressEditingController.dispose();
    _passwordEditingController.dispose();
    super.dispose();
  }

  @override
  Widget buildPage(BuildContext context) {
    final double deviceWidth = context.deviceWidth;
    final double deviceHeight = context.deviceHeight;
    return CommonScaffold(
      hideKeyboardWhenTouchOutside: true,
      body: Container(
        padding: EdgeInsets.all(Dimens.d24.responsive()),
        width: deviceWidth,
        height: deviceHeight,
        decoration: BoxDecoration(color: AppColors.current.whiteColor),
        child: SingleChildScrollView(
          physics: const NeverScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: Dimens.d32.responsive()),
              Center(
                child: Image.asset(
                  Assets.images.pictures.loginImage.path,
                  width: Dimens.d220.responsive(),
                  height: Dimens.d220.responsive(),
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(height: Dimens.d40.responsive()),
              CommonTextField(
                controller: _emailAddressEditingController,
                height: Dimens.d56.responsive(),
                hintText: S.current.email,
                onChanged: (email) =>
                    bloc.add(EmailTextFieldChanged(email: email)),
                keyboardType: TextInputType.emailAddress,
                hintStyle: AppTextStyles.titleTextDefault(
                  fontSize: Dimens.d16.responsive(),
                  fontWeight: FontWeight.w400,
                  color: AppColors.defaultAppColor.secondaryTextColor,
                ),
                textStyle: AppTextStyles.titleTextDefault(
                  fontSize: Dimens.d16.responsive(),
                  fontWeight: FontWeight.w400,
                  color: AppColors.defaultAppColor.primaryColor,
                ),
                borderColor: AppColors.current.textLinkColor,
                prefixIcon: Icon(
                  Icons.email_outlined,
                  size: Dimens.d24.responsive(),
                  color: AppColors.defaultAppColor.secondaryTextColor,
                ),
                suffixIcon: _emailAddressEditingController.text.isNotEmpty
                    ? GestureDetector(
                        onTap: () {
                          setState(() {
                            _emailAddressEditingController.clear();
                            bloc.add(EmailTextFieldChanged(
                                email: _emailAddressEditingController.text));
                          });
                        },
                        child: Container(
                          width: Dimens.d16,
                          height: Dimens.d16,
                          color: AppColors.transparent,
                          child: Center(
                            child: Icon(
                              Icons.clear,
                              color: AppColors.defaultAppColor.blackColor,
                            ),
                          ),
                        ),
                      )
                    : null,
              ),
              SizedBox(height: Dimens.d20.responsive()),
              CommonTextField(
                controller: _passwordEditingController,
                obscureText: _obscurePassword,
                height: Dimens.d56.responsive(),
                hintText: S.current.password,
                onChanged: (pass) =>
                    bloc.add(PasswordTextFieldChanged(password: pass)),
                keyboardType: TextInputType.visiblePassword,
                hintStyle: AppTextStyles.titleTextDefault(
                  fontSize: Dimens.d16.responsive(),
                  fontWeight: FontWeight.w400,
                  color: AppColors.defaultAppColor.secondaryTextColor,
                ),
                textStyle: AppTextStyles.titleTextDefault(
                  fontSize: Dimens.d16.responsive(),
                  fontWeight: FontWeight.w400,
                  color: AppColors.defaultAppColor.primaryColor,
                ),
                borderColor: AppColors.current.textLinkColor,
                prefixIcon: Icon(
                  Icons.lock,
                  size: Dimens.d24.responsive(),
                  color: AppColors.defaultAppColor.secondaryTextColor,
                ),
                suffixIcon: GestureDetector(
                  onTap: () {
                    setState(() {
                      _obscurePassword = !_obscurePassword;
                    });
                  },
                  child: Icon(
                    _obscurePassword ? Icons.visibility_off : Icons.visibility,
                    size: Dimens.d24.responsive(),
                    color: AppColors.defaultAppColor.secondaryTextColor,
                  ),
                ),
              ),
              SizedBox(height: Dimens.d12.responsive()),
              BlocBuilder<LoginBloc, LoginState>(
                buildWhen: (previous, current) =>
                    previous.onPageError != current.onPageError,
                builder: (_, state) => state.onPageError.isNotEmpty
                    ? Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: Dimens.d12.responsive(),
                          vertical: Dimens.d8.responsive(),
                        ),
                        decoration: BoxDecoration(
                          color:
                              AppColors.current.redColor.withValues(alpha: 10),
                          borderRadius:
                              BorderRadius.circular(Dimens.d8.responsive()),
                          border: Border.all(
                            color: AppColors.current.redColor,
                            width: 1,
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.error_outline,
                              color: AppColors.current.redColor,
                              size: Dimens.d16.responsive(),
                            ),
                            SizedBox(width: Dimens.d8.responsive()),
                            Expanded(
                              child: Text(state.onPageError,
                                  style: AppTextStyles.titleTextDefault(
                                      color: AppColors.current.redColor)),
                            ),
                          ],
                        ),
                      )
                    : const SizedBox.shrink(),
              ),
              SizedBox(height: Dimens.d32.responsive()),
              BlocBuilder<LoginBloc, LoginState>(
                buildWhen: (previous, current) =>
                    previous.isLoginButtonEnabled !=
                    current.isLoginButtonEnabled,
                builder: (context, state) {
                  return UIButton(
                      enable: state.isLoginButtonEnabled,
                      height: Dimens.d52.responsive(),
                      width: Dimens.d335.responsive(),
                      text: S.current.login,
                      textSize: Dimens.d16.responsive(),
                      fontWeight: FontWeight.w700,
                      radius: Dimens.d8.responsive(),
                      enableShadow: false,
                      color: AppColors.defaultAppColor.textLinkColor,
                      textColor: AppColors.current.whiteColor,
                      onTap: () => bloc.add(const LoginButtonPressed()));
                },
              ),
              SizedBox(height: Dimens.d16.responsive()),
              Row(
                children: [
                  Expanded(
                    child: Divider(
                      color: AppColors.current.secondaryColor,
                      thickness: 1,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: Dimens.d16.responsive()),
                    child: Text(
                      'hoặc',
                      style: AppTextStyles.s14w400Secondary(),
                    ),
                  ),
                  Expanded(
                    child: Divider(
                      color: AppColors.current.secondaryColor,
                      thickness: 1,
                    ),
                  ),
                ],
              ),
              SizedBox(height: Dimens.d16.responsive()),
              UIButton(
                height: Dimens.d52.responsive(),
                width: Dimens.d335.responsive(),
                text: S.current.fakeLogin,
                textSize: Dimens.d16.responsive(),
                fontWeight: FontWeight.w700,
                radius: Dimens.d8.responsive(),
                enableShadow: false,
                color: AppColors.defaultAppColor.textLinkColor,
                textColor: AppColors.current.whiteColor,
                onTap: () => bloc.add(const FakeLoginButtonPressed()),
              ),
              SizedBox(height: Dimens.d24.responsive()),
            ],
          ),
        ),
      ),
    );
  }
}
