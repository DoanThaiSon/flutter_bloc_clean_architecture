import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain.dart';

part 'app_route_info.freezed.dart';

/// page
@freezed
class AppRouteInfo with _$AppRouteInfo {
  const factory AppRouteInfo.main() = _Main;
  const factory AppRouteInfo.language() = _LanguagePage;
  const factory AppRouteInfo.welcome() = _Welcome;
  const factory AppRouteInfo.loginAttendance() = _LoginAttendance;
  const factory AppRouteInfo.homeAttendance() = _HomeAttendance;
  const factory AppRouteInfo.historyAttendance() = _HistoryAttendance;
  const factory AppRouteInfo.profileAttendance() = _ProfileAttendance;
  const factory AppRouteInfo.leaveRequest() = _LeaveRequest;
  const factory AppRouteInfo.createLeaveRequest() = CreateLeaveRequest;
}
