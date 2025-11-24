import 'package:auto_route/auto_route.dart';
import 'package:domain/domain.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:resources/resources.dart';

import '../../app.dart';
import '../../common_view/common_confirm_dialog.dart';
import '../../shared_view/app_scaffold.dart';
import 'bloc/my_page.dart';

@RoutePage(name: 'MyPageRoute')
class MyPagePage extends StatefulWidget {
  const MyPagePage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _MyPagePageState();
  }
}

class _MyPagePageState extends BasePageState<MyPagePage, MyPageBloc> {
  @override
  Widget buildPage(BuildContext context) {
    return AppScaffold(
      backgroundColor: AppColors.current.whiteColor,
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return SafeArea(
      child: BlocBuilder<AppBloc, AppState>(builder: (context, state) {
        return SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _buildLogOutAndChangePassword(),
              Divider(
                thickness: Dimens.d10,
                color: AppColors.current.backgroundSetting,
              ),
              _buildLanguageAndPolicies(),
              Divider(
                thickness: Dimens.d10,
                color: AppColors.current.backgroundSetting,
              ),
              _buildLogoutItem()
            ],
          ),
        );
      }),
    );
  }

  Widget _buildLanguageAndPolicies() {
    return Container(
        padding: const EdgeInsets.fromLTRB(
            Dimens.d16, Dimens.d0, Dimens.d0, Dimens.d0),
        color: AppColors.current.whiteColor,
        child: Column(
          children: [
            _buildListItem(
                Assets.images.icons.globe.path, S.current.language, () {
              navigator.push(const AppRouteInfo.language());
            }),
          ],
        ));
  }

  Widget _buildLogOutAndChangePassword() {
    return Container(
        padding: const EdgeInsets.fromLTRB(
            Dimens.d16, Dimens.d0, Dimens.d0, Dimens.d0),
        color: AppColors.current.whiteColor,
        child: Column(
          children: [
            _buildListItem(Assets.images.icons.delete.path, S.current.deleteAccountTitle,
                () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return CustomConfirmDialog(
                    icon: Image.asset(
                      Assets.images.icons.languageVi.path,
                      width: Dimens.d46,
                      height: Dimens.d46,
                    ),
                    description: S.current.deleteAccountDescription,
                    confirmText: S.current.confirm,
                    onConfirm: () async {
                      await navigator.pop();
                      commonBloc.add(const ForceLogoutButtonPressed());
                    },
                    onCancel: () {
                      navigator.pop();
                    },
                  );
                },
              );
            }),
          ],
        ));
  }
  Widget _buildLogoutItem() {
    return InkWell(
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
              onConfirm: () async {
                commonBloc.add(const ForceLogoutButtonPressed());
                await navigator.pop(useRootNavigator: true);
              },
              onCancel: () {
                navigator.pop();
              },
            );
          },
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(
            vertical: Dimens.d12, horizontal: Dimens.d16),
        child: Row(
          children: [
            Image.asset(
              Assets.images.icons.signOut.path,
              width: Dimens.d24,
              height: Dimens.d24,
            ),
            const SizedBox(width: Dimens.d16),
            Expanded(
              child: Text(
                S.current.logout,
                style: AppTextStyles.titleTextDefault(
                  fontSize: Dimens.d16,
                  fontWeight: FontWeight.w500,
                  color: AppColors.current.redColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildListItem(String icon, String title, Function()? onTap) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: Dimens.d16),
        child: Row(
          children: [
            Image.asset(
              icon,
              color: AppColors.current.secondaryColor,
              width: Dimens.d20,
              height: Dimens.d20,
            ),
            const SizedBox(width: Dimens.d16),
            Expanded(
              child: Text(
                title,
                style: AppTextStyles.titleTextDefault(
                  fontSize: Dimens.d16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: Dimens.d16),
              child: Icon(
                Icons.arrow_forward_ios,
                size: Dimens.d16,
                color: AppColors.current.primaryColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
