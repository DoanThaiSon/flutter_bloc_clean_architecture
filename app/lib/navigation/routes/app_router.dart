import 'package:auto_route/auto_route.dart';
import 'package:injectable/injectable.dart';

import '../../app.dart';

// ignore_for_file:prefer-single-widget-per-file
@AutoRouterConfig(
  replaceInRouteName: 'Page,Route',
)
@LazySingleton()
class AppRouter extends RootStackRouter {
  @override
  RouteType get defaultRouteType => const RouteType.adaptive();

  @override
  List<AutoRoute> get routes => [
        AutoRoute(page: WelcomePageRoute.page),
        AutoRoute(page: MainRoute.page, children: [
          AutoRoute(
            page: HomeAttendanceTab.page,
            maintainState: true,
            children: [
              AutoRoute(page: AttendanceHomeRoute.page, initial: true),
            ],
          ),
          AutoRoute(
            page: HistoryAttendanceTab.page,
            maintainState: false,
            children: [
              AutoRoute(page: AttendanceHistoryRoute.page, initial: true),
            ],
          ),
          AutoRoute(
            page: ProfileAttendanceTab.page,
            maintainState: true,
            children: [
              AutoRoute(page: AttendanceProfileRoute.page, initial: true),
            ],
          ),
        ]),
        AutoRoute(page: LanguageRoute.page),
        AutoRoute(page: AttendanceLoginRoute.page),
        AutoRoute(page: AttendanceHomeRoute.page),
        AutoRoute(page: AttendanceHistoryRoute.page),
        AutoRoute(page: AttendanceProfileRoute.page),
        AutoRoute(page: LeaveRequestRoute.page),
        AutoRoute(page: CreateLeaveRequestRoute.page),
        AutoRoute(page: CreateDepartmentRoute.page),
        AutoRoute(page: DepartmentListRoute.page),
        AutoRoute(page: WebViewRoute.page),
      ];
}

@RoutePage(name: 'HomeAttendanceTab')
class HomeAttendanceTabPage extends AutoRouter {
  const HomeAttendanceTabPage({super.key});
}

@RoutePage(name: 'HistoryAttendanceTab')
class HistoryAttendanceTabPage extends AutoRouter {
  const HistoryAttendanceTabPage({super.key});
}

@RoutePage(name: 'ProfileAttendanceTab')
class ProfileAttendanceTabPage extends AutoRouter {
  const ProfileAttendanceTabPage({super.key});
}
