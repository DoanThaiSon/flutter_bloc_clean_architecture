import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:domain/domain.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:resources/resources.dart';
import 'package:shared/shared.dart';
import '../../app.dart';
import '../../common_view/common_confirm_dialog.dart';
import '../../common_view/popup/common_show_snack_bar.dart';
import '../../common_view/reject_reason_dialog.dart';
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
  Completer<void>? _refreshCompleter;

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
      body: BlocConsumer<LeaveRequestBloc, LeaveRequestState>(
        listener: (context, state) {
          if (state.getLeaveRequestResponseStatus == LoadDataStatus.success ||
              state.getLeaveRequestResponseStatus == LoadDataStatus.fail) {
            _refreshCompleter?.complete();
            _refreshCompleter = null;
          }
          if (state.deleteLeaveRequestStatus == LoadDataStatus.success) {
            showAppSnackBar(
              context,
              message: 'Xóa đơn nghỉ phép thành công',
              backgroundColor: AppColors.current.blackColor,
            );
          }
        },
        builder: (context, state) {
          final hasData = state.leaveRequests?.data.isNotEmpty ?? false;

          return Column(
            children: [
              _buildTabBar(state),
              Expanded(
                child: RefreshIndicator(
                  onRefresh: () async {
                    // Create a new completer for this refresh
                    _refreshCompleter = Completer<void>();

                    // Trigger refresh for current tab
                    bloc.add(LeaveRequestTabChanged(tabIndex: _selectedTab));

                    // Wait for the completer to complete with timeout
                    return _refreshCompleter!.future.timeout(
                      const Duration(seconds: 10),
                      onTimeout: () {
                        _refreshCompleter = null;
                      },
                    );
                  },
                  color: AppColors.current.blue500Color,
                  child: hasData
                      ? ListView.builder(
                          padding: EdgeInsets.all(Dimens.d16.responsive()),
                          itemCount: state.leaveRequests?.data.length,
                          itemBuilder: (context, index) {
                            return _buildLeaveRequestItem(
                                state.leaveRequests?.data[index]);
                          },
                        )
                      : const EmptyDataPage()
                ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result =
              await navigator.push(const AppRouteInfo.createLeaveRequest());
          if (result == true) {
            bloc.add(LeaveRequestTabChanged(tabIndex: _selectedTab));
          }
        },
        backgroundColor: AppColors.current.blue500Color,
        child: Icon(
          Icons.add,
          color: AppColors.current.whiteColor,
        ),
      ),
    );
  }

  Widget _buildTabBar(LeaveRequestState state) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: Dimens.d16.responsive()),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.neutral200,
          borderRadius: BorderRadius.circular(Dimens.d20.responsive()),
        ),
        padding: EdgeInsets.all(
          Dimens.d4.responsive(),
        ),
        child: Row(
          children: [
            Expanded(child: _buildTabItem('Tất cả', 0)),
            Expanded(child: _buildTabItem('Của tôi', 1)),
            Expanded(
              child: _buildTabItem('Cần duyệt', 2,
                  badgeCount:
                      state.pendingCount > 0 ? state.pendingCount : null),
            ),
          ],
        ),
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
          horizontal: Dimens.d8.responsive(),
          vertical: Dimens.d4.responsive(),
        ),
        decoration: BoxDecoration(
          color:
              isSelected ? AppColors.current.whiteColor : AppColors.neutral200,
          borderRadius: BorderRadius.circular(Dimens.d20.responsive()),
        ),
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Flexible(
                child: Text(
                  label,
                  style: AppTextStyles.s14w500Primary()
                      .copyWith(color: AppColors.current.blackColor),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (badgeCount != null) ...[
                SizedBox(width: Dimens.d6.responsive()),
                Container(
                  constraints: BoxConstraints(
                    minWidth: Dimens.d20.responsive(),
                    minHeight: Dimens.d20.responsive(),
                  ),
                  padding: EdgeInsets.symmetric(
                    horizontal: Dimens.d6.responsive(),
                    vertical: Dimens.d2.responsive(),
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.current.redColor,
                    borderRadius:
                        BorderRadius.circular(Dimens.d10.responsive()),
                  ),
                  child: Center(
                    child: Text(
                      badgeCount > 99 ? '99+' : '$badgeCount',
                      style: AppTextStyles.s11w600Primary().copyWith(
                        color: AppColors.current.whiteColor,
                        height: 1.2,
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
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
            color: Colors.black.withValues(alpha: 0.05),
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
                        color: AppColors.current.blue500Color.withValues(alpha: 0.1),
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
          SizedBox(height: Dimens.d12.responsive()),
          _buildActionButtons(request),
        ],
      ),
    );
  }

  Widget _buildActionButtons(LeaveRequest? request) {
    if (request == null) {
      return const SizedBox.shrink();
    }

    final isPending = request.status == 'pending';
    final isMyRequest = _selectedTab == 1; // Tab "Của tôi"
    final needsApproval = _selectedTab == 2; // Tab "Cần duyệt"

    return Row(
      children: [
        if (isMyRequest && isPending) ...[
          Expanded(
            child: OutlinedButton.icon(
              onPressed: () async {
                final result = await navigator.push(
                  AppRouteInfo.createLeaveRequest(
                    leaveRequest: request,
                  ),
                );
                if (result == true) {
                  bloc.add(LeaveRequestTabChanged(tabIndex: _selectedTab));
                }
              },
              icon: Icon(
                Icons.edit,
                size: Dimens.d16.responsive(),
                color: AppColors.current.blue500Color,
              ),
              label: Text(
                'Sửa',
                style: AppTextStyles.s14w500Primary().copyWith(
                  color: AppColors.current.blue500Color,
                ),
              ),
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: AppColors.current.blue500Color),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(Dimens.d8.responsive()),
                ),
              ),
            ),
          ),
          SizedBox(width: Dimens.d8.responsive()),
        ],

        // Nút Xóa - chỉ hiện khi là đơn của tôi và đang pending
        if (isMyRequest && isPending) ...[
          Expanded(
            child: OutlinedButton.icon(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext dialogContext) {
                    return CustomConfirmDialog(
                      icon: Icon(
                        Icons.warning_amber_rounded,
                        size: Dimens.d46.responsive(),
                        color: AppColors.current.redColor,
                      ),
                      description: 'Bạn có chắc chắn muốn xóa đơn này?',
                      confirmText: 'Xóa',
                      cancelText: 'Hủy',
                      onConfirm: () {
                        Navigator.of(dialogContext).pop();
                        bloc.add(DeleteLeaveRequestButtonPressed(
                          leaveRequestId: request.id,
                        ));
                      },
                      onCancel: () {
                        Navigator.of(dialogContext).pop();
                      },
                    );
                  },
                );
              },
              icon: Icon(
                Icons.delete_outline,
                size: Dimens.d16.responsive(),
                color: AppColors.current.redColor,
              ),
              label: Text(
                'Xóa',
                style: AppTextStyles.s14w500Primary().copyWith(
                  color: AppColors.current.redColor,
                ),
              ),
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: AppColors.current.redColor),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(Dimens.d8.responsive()),
                ),
              ),
            ),
          ),
        ],

        // Nút Duyệt và Từ chối - chỉ hiện ở tab "Cần duyệt" và đơn đang pending
        if (needsApproval && isPending) ...[
          Expanded(
            child: OutlinedButton.icon(
              onPressed: () {
                _showRejectDialog(context, request.id);
              },
              icon: Icon(
                Icons.close,
                size: Dimens.d16.responsive(),
                color: AppColors.current.redColor,
              ),
              label: Text(
                'Từ chối',
                style: AppTextStyles.s14w500Primary().copyWith(
                  color: AppColors.current.redColor,
                ),
              ),
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: AppColors.current.redColor),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(Dimens.d8.responsive()),
                ),
              ),
            ),
          ),
          SizedBox(width: Dimens.d8.responsive()),
          Expanded(
            child: ElevatedButton.icon(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return CustomConfirmDialog(
                      icon: Image.asset(
                        Assets.images.icons.question.path,
                        width: Dimens.d46,
                        height: Dimens.d46,
                      ),
                      description: 'Bạn có chắc chắn muốn duyệt đơn này?',
                      confirmText: S.current.confirm,
                      onConfirm: () async {
                        await navigator.pop(useRootNavigator: true);
                        bloc.add(ApproveLeaveRequestButtonPressed(
                          leaveRequestId: request.id,
                        ));
                      },
                      onCancel: () {
                        navigator.pop(useRootNavigator: true);
                      },
                    );
                  },
                );
              },
              icon: Icon(
                Icons.check,
                size: Dimens.d16.responsive(),
                color: AppColors.current.whiteColor,
              ),
              label: Text(
                'Duyệt',
                style: AppTextStyles.s14w500Primary().copyWith(
                  color: AppColors.current.whiteColor,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.current.completeTextColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(Dimens.d8.responsive()),
                ),
              ),
            ),
          ),
        ],
      ],
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
        backgroundColor = AppColors.current.orange500Color.withValues(alpha: 0.1);
        textColor = AppColors.current.orange500Color;
        statusText = 'ĐANG CHỜ';
        break;
      case 'rejected':
        backgroundColor = AppColors.current.redColor.withValues(alpha: 0.1);
        textColor = AppColors.current.redColor;
        statusText = 'TỪ CHỐI';
        break;
      default:
        backgroundColor = AppColors.current.grayColor.withValues(alpha: 0.1);
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

  void _showRejectDialog(BuildContext context, String leaveRequestId) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return RejectReasonDialog(
          title: 'Từ chối đơn nghỉ phép',
          hintText: 'Vui lòng nhập lý do từ chối đơn này...',
          confirmText: 'Xác nhận',
          cancelText: 'Hủy',
          onConfirm: (reason) {
            Navigator.of(dialogContext).pop();
            // Call reject API with reason
            bloc.add(RejectLeaveRequestButtonPressed(
              leaveRequestId: leaveRequestId,
              rejectionReason: reason,
            ));
          },
          onCancel: () {
            Navigator.of(dialogContext).pop();
          },
        );
      },
    );
  }
}
