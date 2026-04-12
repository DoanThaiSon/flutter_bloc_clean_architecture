import 'package:auto_route/auto_route.dart';
import 'package:domain/domain.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared/shared.dart';
import '../../app.dart';
import '../../common_view/ui_button.dart';
import '../../shared_view/empty_data_widget.dart';
import 'bloc/leave_request.dart';

@RoutePage()
class LeaveRequestPage extends StatefulWidget {
  const LeaveRequestPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _LeaveRequestPageState();
  }
}

class _LeaveRequestPageState
    extends BasePageState<LeaveRequestPage, LeaveRequestBloc> {
  int _selectedTab = 0;

  @override
  void initState() {
    super.initState();
    bloc.add(const LeaveRequestPageInitiated());
  }

  @override
  Widget buildPage(BuildContext context) {
    return CommonScaffold(
      backgroundColor: AppColors.current.backgroundLayer1,
      appBar: CommonAppBar(
        text: 'Xin nghỉ phép',
        leadingIcon: LeadingIcon.newBack,
        onLeadingPressed: () => navigator.pop(useRootNavigator: true),
      ),
      body: BlocBuilder<LeaveRequestBloc, LeaveRequestState>(
        builder: (context, state) {
          final hasData = state.leaveRequests?.data.isNotEmpty ?? false;

          return Column(
            children: [
              _buildTabBar(),
              if (hasData)
                Text(
                  'Danh sách đơn gần đây',
                  style: AppTextStyles.s16w600Primary(),
                ),
              Expanded(
                child: hasData
                    ? ListView.builder(
                        padding: EdgeInsets.all(Dimens.d16.responsive()),
                        itemCount: state.leaveRequests?.data.length,
                        itemBuilder: (context, index) {
                          return _buildLeaveRequestItem(
                              state.leaveRequests?.data[index]);
                        },
                      )
                    : const EmptyDataPage(),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
         navigator.push(AppRouteInfo.createLeaveRequest());
        },
        backgroundColor: AppColors.current.blue500Color,
        child: Icon(
          Icons.add,
          color: AppColors.current.whiteColor,
        ),
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      color: AppColors.current.whiteColor,
      padding: EdgeInsets.symmetric(
        horizontal: Dimens.d16.responsive(),
        vertical: Dimens.d12.responsive(),
      ),
      child: Row(
        children: [
          _buildTabItem('Tất cả', 0),
          SizedBox(width: Dimens.d12.responsive()),
          _buildTabItem('Của tôi', 1),
          SizedBox(width: Dimens.d12.responsive()),
          _buildTabItem('Cần duyệt', 2, badgeCount: 3),
        ],
      ),
    );
  }

  Widget _buildTabItem(String label, int index, {int? badgeCount}) {
    final isSelected = _selectedTab == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedTab = index;
        });
        bloc.add(LeaveRequestTabChanged(tabIndex: index));
      },
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: Dimens.d16.responsive(),
          vertical: Dimens.d8.responsive(),
        ),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.current.blue500Color
              : AppColors.current.whiteColor,
          borderRadius: BorderRadius.circular(Dimens.d20.responsive()),
          border: Border.all(
            color: isSelected
                ? AppColors.current.blue500Color
                : AppColors.current.grayColor,
          ),
        ),
        child: Row(
          children: [
            Text(
              label,
              style: AppTextStyles.s14w500Primary().copyWith(
                color: isSelected
                    ? AppColors.current.whiteColor
                    : AppColors.current.primaryTextColor,
              ),
            ),
            if (badgeCount != null) ...[
              SizedBox(width: Dimens.d8.responsive()),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: Dimens.d6.responsive(),
                  vertical: Dimens.d2.responsive(),
                ),
                decoration: BoxDecoration(
                  color: AppColors.current.redColor,
                  shape: BoxShape.circle,
                ),
                child: Text(
                  '$badgeCount',
                  style: AppTextStyles.s12w500Primary().copyWith(
                    color: AppColors.current.whiteColor,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildLeaveRequestItem(LeaveRequest? request) {
    return Container(
      margin: EdgeInsets.only(bottom: Dimens.d12.responsive()),
      padding: EdgeInsets.all(Dimens.d16.responsive()),
      decoration: BoxDecoration(
        color: AppColors.current.whiteColor,
        borderRadius: BorderRadius.circular(Dimens.d12.responsive()),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  children: [
                    Container(
                      width: Dimens.d40.responsive(),
                      height: Dimens.d40.responsive(),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.current.blue500Color.withOpacity(0.1),
                      ),
                      child: Center(
                        child: Text(
                          '',
                          style: AppTextStyles.s16w600Primary().copyWith(
                            color: AppColors.current.blue500Color,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: Dimens.d12.responsive()),
                    Expanded(
                      child: Text(
                        request?.creatorName ?? '',
                        style: AppTextStyles.s14w600Primary(),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: Dimens.d5.responsive(),
              ),
              _buildStatusBadge(request?.status ?? ''),
            ],
          ),
          SizedBox(height: Dimens.d12.responsive()),
          Row(
            children: [
              Icon(
                Icons.calendar_today,
                size: Dimens.d16.responsive(),
                color: AppColors.current.blue500Color,
              ),
              SizedBox(width: Dimens.d8.responsive()),
              Expanded(
                child: Text(
                  '${DateTimeUtils.formatIsoString(request?.startDate)} - ${DateTimeUtils.formatIsoString(request?.endDate)} (${request?.totalDays} ngày)',
                  style: AppTextStyles.s13w400Primary(),
                ),
              ),
            ],
          ),
          SizedBox(height: Dimens.d8.responsive()),
          Row(
            children: [
              Icon(
                Icons.description,
                size: Dimens.d16.responsive(),
                color: AppColors.current.blue500Color,
              ),
              SizedBox(width: Dimens.d8.responsive()),
              Expanded(
                child: Text(
                  request?.reason ?? '',
                  style: AppTextStyles.s13w400Primary(),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          if (request?.approver != null) ...[
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Divider(
                  thickness: 0.5,
                  color: AppColors.neutral100,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Người duyệt: ',
                      style: AppTextStyles.s12w400Primary().copyWith(
                        color: AppColors.current.secondaryTextColor,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        request?.approver?.name ?? '',
                        style: AppTextStyles.s12w500Primary(),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: Dimens.d8.responsive(),
                ),
                if (request?.approvedAt != null) ...[
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Duyệt: ',
                        style: AppTextStyles.s12w400Primary().copyWith(
                          color: AppColors.current.secondaryTextColor,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          ' ${DateTimeUtils.formatIsoString(request?.approvedAt)}',
                          style: AppTextStyles.s12w500Primary(),
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildStatusBadge(String status) {
    Color backgroundColor;
    Color textColor;
    String statusText;

    switch (status) {
      case 'approved':
        backgroundColor = AppColors.current.completeColor;
        textColor = AppColors.current.completeTextColor;
        statusText = 'ĐÃ DUYỆT';
        break;
      case 'pending':
        backgroundColor = AppColors.current.orange500Color.withOpacity(0.1);
        textColor = AppColors.current.orange500Color;
        statusText = 'ĐANG CHỜ';
        break;
      case 'rejected':
        backgroundColor = AppColors.current.redColor.withOpacity(0.1);
        textColor = AppColors.current.redColor;
        statusText = 'TỪ CHỐI';
        break;
      default:
        backgroundColor = AppColors.current.grayColor.withOpacity(0.1);
        textColor = AppColors.current.secondaryTextColor;
        statusText = 'KHÔNG XÁC ĐỊNH';
    }

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: Dimens.d12.responsive(),
        vertical: Dimens.d6.responsive(),
      ),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(Dimens.d12.responsive()),
      ),
      child: Text(
        statusText,
        style: AppTextStyles.s11w600Primary().copyWith(
          color: textColor,
        ),
      ),
    );
  }

// String _formatDateRange(String? startDate, String? endDate, int? totalDays) {
//   if (startDate == null || endDate == null || startDate.isEmpty || endDate.isEmpty) {
//     return '';
//   }
//
//   try {
//     final start = DateTime.parse(startDate);
//     final end = DateTime.parse(endDate);
//
//     final startFormatted = '${start.day.toString().padLeft(2, '0')}/${start.month.toString().padLeft(2, '0')}/${start.year}';
//     final endFormatted = '${end.day.toString().padLeft(2, '0')}/${end.month.toString().padLeft(2, '0')}/${end.year}';
//
//     final days = totalDays ?? (end.difference(start).inDays + 1);
//
//     return '$startFormatted - $endFormatted ($days ngày)';
//   } catch (e) {
//     return '$startDate - $endDate';
//   }
// }
}
