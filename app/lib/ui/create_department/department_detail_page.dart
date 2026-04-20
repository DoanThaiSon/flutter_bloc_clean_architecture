import 'package:auto_route/auto_route.dart';
import 'package:domain/domain.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:resources/resources.dart';
import '../../app.dart';
import 'bloc/create_department.dart';

@RoutePage()
class DepartmentDetailPage extends StatefulWidget {
  final Department department;

  const DepartmentDetailPage({
    required this.department, super.key,
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
    bloc.add( GetDepartmentDetail(departmentId: widget.department.id));
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
        onLeadingPressed: () => navigator.pop(useRootNavigator: true),
      ),
      body: BlocListener<CreateDepartmentBloc, CreateDepartmentState>(
        listenWhen: (previous, current) =>
            previous.deleteDepartmentStatus != current.deleteDepartmentStatus,
        listener: (context, state) {
          // if (state.deleteDepartmentStatus == LoadDataStatus.success) {
          //   showSuccessNotification('Xóa phòng ban thành công');
          //   navigator.pop(true);
          // } else if (state.deleteDepartmentStatus == LoadDataStatus.fail) {
          //   showErrorNotification(
          //     state.errorMessage ?? 'Xóa phòng ban thất bại',
          //   );
          // }
        },
        child: SingleChildScrollView(
          padding: EdgeInsets.all(Dimens.d16.responsive()),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildInfoCard(),
              SizedBox(height: Dimens.d16.responsive()),
              _buildActionButtons(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoCard() {
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
          Center(
            child: Container(
              width: Dimens.d80.responsive(),
              height: Dimens.d80.responsive(),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF2563EB), Color(0xFF1E40AF)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(Dimens.d16.responsive()),
              ),
              child: Center(
                child: Text(
                  widget.department.code.isNotEmpty
                      ? widget.department.code.substring(0, 1).toUpperCase()
                      : 'D',
                  style: AppTextStyles.titleTextDefault(
                    fontSize: Dimens.d36.responsive(),
                    fontWeight: FontWeight.bold,
                    color: AppColors.current.whiteColor,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: Dimens.d24.responsive()),
          _buildInfoRow(
            label: 'Tên phòng ban',
            value: widget.department.name,
            icon: Icons.business,
          ),
          SizedBox(height: Dimens.d16.responsive()),
          _buildInfoRow(
            label: 'Mã phòng ban',
            value: widget.department.code,
            icon: Icons.tag,
          ),
          if (widget.department.description.isNotEmpty) ...[
            SizedBox(height: Dimens.d16.responsive()),
            _buildInfoRow(
              label: 'Mô tả',
              value: widget.department.description,
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
            SizedBox(
              width: double.infinity,
              height: Dimens.d48.responsive(),
              child: ElevatedButton.icon(
                onPressed: isDeleting
                    ? null
                    : () async {
                        // final result = await navigator.push(
                        //   AppRouteInfo.createDepartment(
                        //     department: widget.department,
                        //   ),
                        // );
                        // if (result == true) {
                        //   navigator.pop(useRootNavigator: true);
                        // }
                      },
                icon: Icon(
                  Icons.edit,
                  size: Dimens.d20.responsive(),
                ),
                label: Text(
                  'Sửa phòng ban',
                  style: AppTextStyles.titleTextDefault(
                    fontSize: Dimens.d16.responsive(),
                    fontWeight: FontWeight.w600,
                    color: AppColors.current.whiteColor,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.current.blackColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(Dimens.d12.responsive()),
                  ),
                ),
              ),
            ),
            SizedBox(height: Dimens.d12.responsive()),
            SizedBox(
              width: double.infinity,
              height: Dimens.d48.responsive(),
              child: OutlinedButton.icon(
                onPressed: isDeleting ? null : _showDeleteConfirmDialog,
                icon: isDeleting
                    ? SizedBox(
                        width: Dimens.d16.responsive(),
                        height: Dimens.d16.responsive(),
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: AppColors.current.errorTextColor,
                        ),
                      )
                    : Icon(
                        Icons.delete_outline,
                        size: Dimens.d20.responsive(),
                        color: AppColors.current.errorTextColor,
                      ),
                label: Text(
                  isDeleting ? 'Đang xóa...' : 'Xóa phòng ban',
                  style: AppTextStyles.titleTextDefault(
                    fontSize: Dimens.d16.responsive(),
                    fontWeight: FontWeight.w600,
                    color: AppColors.current.errorTextColor,
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  side: BorderSide(
                    color: AppColors.current.errorTextColor,
                    width: 1.5,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(Dimens.d12.responsive()),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
