import 'package:auto_route/auto_route.dart';
import 'package:domain/domain.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:resources/resources.dart';
import '../../app.dart';
import '../../common_view/popup/common_show_snack_bar.dart';
import '../../common_view/ui_button.dart';
import 'bloc/create_department.dart';

@RoutePage()
class DepartmentDetailPage extends StatefulWidget {
  final Department department;

  const DepartmentDetailPage({
    required this.department,
    super.key,
  });

  @override
  State<StatefulWidget> createState() {
    return _DepartmentDetailPageState();
  }
}

class _DepartmentDetailPageState
    extends BasePageState<DepartmentDetailPage, CreateDepartmentBloc> {
  @override
  void initState() {
    super.initState();
    bloc.add(GetDepartmentDetail(departmentId: widget.department.id));
  }

  void _showDeleteConfirmDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Xác nhận xóa',
          style: AppTextStyles.titleTextDefault(
            fontSize: Dimens.d18.responsive(),
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Text(
          'Bạn có chắc chắn muốn xóa phòng ban "${widget.department.name}"?',
          style: AppTextStyles.titleTextDefault(
            fontSize: Dimens.d14.responsive(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              'Hủy',
              style: AppTextStyles.titleTextDefault(
                fontSize: Dimens.d14.responsive(),
                color: AppColors.neutral600,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              bloc.add(DeleteDepartment(departmentId: widget.department.id));
            },
            child: Text(
              'Xóa',
              style: AppTextStyles.titleTextDefault(
                fontSize: Dimens.d14.responsive(),
                color: AppColors.current.errorTextColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget buildPage(BuildContext context) {
    return CommonScaffold(
      backgroundColor: AppColors.current.backgroundLayer1,
      appBar: CommonAppBar(
        text: 'Chi tiết phòng ban',
        leadingIcon: LeadingIcon.newBack,
        onLeadingPressed: () {
          // Chỉ trả về department nếu đã được update
          final result = bloc.state.isDepartmentUpdated 
              ? bloc.state.departmentDetail 
              : null;
          navigator.pop(
            useRootNavigator: true,
            result: result,
          );
        },
      ),
      body: BlocConsumer<CreateDepartmentBloc, CreateDepartmentState>(
        listenWhen: (previous, current) =>
            previous.deleteDepartmentStatus != current.deleteDepartmentStatus,
        listener: (context, state) {
          if (state.deleteDepartmentStatus == LoadDataStatus.success) {
            showAppSnackBar(
              context,
              message: 'Xóa phòng ban thành công',
              backgroundColor: AppColors.current.blackColor,
            );
          }
        },
        builder: (context, state) {
          return SingleChildScrollView(
            padding: EdgeInsets.all(Dimens.d16.responsive()),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildInfoCard(state),
                SizedBox(height: Dimens.d16.responsive()),
                _buildActionButtons(),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildInfoCard(CreateDepartmentState state) {
    return Container(
      padding: EdgeInsets.all(Dimens.d20.responsive()),
      decoration: BoxDecoration(
        color: AppColors.current.whiteColor,
        borderRadius: BorderRadius.circular(Dimens.d16.responsive()),
        boxShadow: [
          BoxShadow(
            color: AppColors.current.blackColor.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildInfoRow(
            label: 'Tên phòng ban',
            value: state.departmentDetail?.name ?? '',
            icon: Icons.business,
          ),
          SizedBox(height: Dimens.d16.responsive()),
          _buildInfoRow(
            label: 'Mã phòng ban',
            value: state.departmentDetail?.code ?? '',
            icon: Icons.tag,
          ),
          SizedBox(height: Dimens.d16.responsive()),
          _buildInfoRow(
            label: 'CBQL',
            value: state.departmentDetail?.manager?.name??'',
            icon: Icons.personal_injury_outlined,
          ),
          if (state.departmentDetail?.description.isNotEmpty ??
              true) ...[
            SizedBox(height: Dimens.d16.responsive()),
            _buildInfoRow(
              label: 'Mô tả',
              value: state.departmentDetail?.description ?? '',
              icon: Icons.description,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildInfoRow({
    required String label,
    required String value,
    required IconData icon,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              icon,
              size: Dimens.d16.responsive(),
              color: AppColors.neutral600,
            ),
            SizedBox(width: Dimens.d8.responsive()),
            Text(
              label,
              style: AppTextStyles.titleTextDefault(
                fontSize: Dimens.d12.responsive(),
                color: AppColors.neutral600,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        SizedBox(height: Dimens.d8.responsive()),
        Text(
          value,
          style: AppTextStyles.titleTextDefault(
            fontSize: Dimens.d16.responsive(),
            color: AppColors.current.blackColor,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons() {
    return BlocBuilder<CreateDepartmentBloc, CreateDepartmentState>(
      buildWhen: (previous, current) =>
          previous.deleteDepartmentStatus != current.deleteDepartmentStatus,
      builder: (context, state) {
        final isDeleting =
            state.deleteDepartmentStatus == LoadDataStatus.loading;

        return Column(
          children: [
            UIButton(
              width: double.infinity,
              height: Dimens.d48.responsive(),
              onTap: () async {
                final result = await navigator.push(
                  AppRouteInfo.createDepartment(
                    department: widget.department,
                  ),
                );
                // Nếu update thành công, cập nhật dữ liệu từ response
                if (result != null && result is Department) {
                  bloc.add(UpdateDepartmentDetailFromResponse(department: result));
                }
              },
              text: 'Sửa phòng ban',
              color: AppColors.current.blackColor,
              textColor: AppColors.current.whiteColor,
              radius: Dimens.d12.responsive(),
            ),
            SizedBox(height: Dimens.d12.responsive()),
            UIButton(
              width: double.infinity,
              height: Dimens.d48.responsive(),
              onTap: isDeleting ? null : _showDeleteConfirmDialog,
              text: isDeleting ? 'Đang xóa...' : 'Xóa phòng ban',
              color: AppColors.current.redColor,
              radius: Dimens.d12.responsive(),
              // iconData: ,
            ),
          ],
        );
      },
    );
  }
}
