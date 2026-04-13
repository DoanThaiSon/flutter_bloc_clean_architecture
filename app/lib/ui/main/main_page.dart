import 'package:auto_route/auto_route.dart';

import '../../app.dart';
import 'bloc/main.dart';
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
  Widget buildPage(BuildContext context) {
    return AutoTabsScaffold(
      routes: (navigator as AppNavigatorImpl).tabRoutes,
      bottomNavigationBuilder: (_, tabsRouter) {
        (navigator as AppNavigatorImpl).tabsRouter = tabsRouter;

        return CustomBottomNavigationBar(
          tabsRouter: tabsRouter,
          onTap: (index) {
            if (index == tabsRouter.activeIndex) {
              (navigator as AppNavigatorImpl).popUntilRootOfCurrentBottomTab();
            }
            tabsRouter.setActiveIndex(index);
          },
        );
      },
    );
  }
}
