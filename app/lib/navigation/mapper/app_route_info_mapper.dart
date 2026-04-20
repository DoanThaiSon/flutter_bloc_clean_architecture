import 'package:auto_route/auto_route.dart';
import 'package:domain/domain.dart';
import 'package:injectable/injectable.dart';

import '../../app.dart';

@LazySingleton(as: BaseRouteInfoMapper)
class AppRouteInfoMapper extends BaseRouteInfoMapper {
  @override
  PageRouteInfo map(AppRouteInfo appRouteInfo) {
    return appRouteInfo.when(
      main: () => const MainRoute(),
      language: () => const LanguageRoute(),
      welcome: () => const WelcomePageRoute(),
      loginAttendance: () => const AttendanceLoginRoute(),
      homeAttendance: () => const AttendanceHomeRoute(),
      historyAttendance: () => const AttendanceHistoryRoute(),
      profileAttendance: () => const AttendanceProfileRoute(),
      leaveRequest: () => const LeaveRequestRoute(),
      createLeaveRequest: (leaveRequest) =>
          CreateLeaveRequestRoute(leaveRequest: leaveRequest),
      createDepartment: () => const CreateDepartmentRoute(),
      webView: (String url, String title) =>
          WebViewRoute(url: url, title: title),
      departmentDetail: (Department department)=> DepartmentDetailRoute(department: department),
      departmentList: ()=> const DepartmentListRoute()
    );
  }
}
