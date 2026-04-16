import 'package:auto_route/auto_route.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../app.dart';
import 'bloc/main.dart';
import 'widgets/app_drawer.dart';
import 'widgets/custom_bottom_navigation_bar.dart';

@RoutePage()
class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _MainPageState();
  }
}

class _MainPageState extends BasePageState<MainPage, MainBloc> {
  @override
  void initState() {
    super.initState();
    bloc.add(const MainPageInitiated());
    }

  @override
  Widget buildPage(BuildContext context) {
    return BlocBuilder<MainBloc, MainState>(
        builder: (context, state) {
          final isAdmin = state.currentUser?.role == 'admin';

          return AutoTabsScaffold(
            routes: (navigator as AppNavigatorImpl).tabRoutes,
            drawer: isAdmin ? const AppDrawer() : null,
            appBarBuilder: (_, tabsRouter) {
              return AppBar(
                elevation: 0,
                scrolledUnderElevation: 0,
                surfaceTintColor: Colors.transparent,
                backgroundColor: AppColors.current.backgroundLayer1,
                leading: isAdmin
                    ? Builder(
                  builder: (context) =>
                      IconButton(
                        icon: Icon(
                          Icons.menu,
                          color: AppColors.current.blackColor,
                        ),
                        onPressed: () => Scaffold.of(context).openDrawer(),
                      ),
                )
                    : null,
                automaticallyImplyLeading: isAdmin,
                title: Text(
                  _getPageTitle(tabsRouter.activeIndex),
                  style: AppTextStyles.titleTextDefault(
                    fontSize: Dimens.d18.responsive(),
                    fontWeight: FontWeight.bold,
                    color: AppColors.current.blackColor,
                  ),
                ),
              );
            },
            bottomNavigationBuilder: (_, tabsRouter) {
              (navigator as AppNavigatorImpl).tabsRouter = tabsRouter;

              return CustomBottomNavigationBar(
                tabsRouter: tabsRouter,
                onTap: (index) {
                  if (index == tabsRouter.activeIndex) {
                    (navigator as AppNavigatorImpl)
                        .popUntilRootOfCurrentBottomTab();
                  }
                  tabsRouter.setActiveIndex(index);
                },
              );
            },
          );
        }
    );
  }

  String _getPageTitle(int index) {
    switch (index) {
      case 0:
        return 'Chấm công';
      case 1:
        return 'Lịch sử';
      case 2:
        return 'Tài khoản';
      default:
        return 'CÔNG CÁN';
    }
  }
}
