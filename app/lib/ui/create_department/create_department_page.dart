import 'package:auto_route/auto_route.dart';
import 'package:domain/domain.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:resources/resources.dart';
import '../../app.dart';
import '../../common_view/common_confirm_dialog.dart';
import '../../common_view/common_text_field.dart';
import '../../common_view/popup/common_show_snack_bar.dart';
import '../../common_view/ui_button.dart';
import '../../shared_view/user_dropdown_with_load_more_widget.dart';
import 'bloc/create_department.dart';

@RoutePage()
class CreateDepartmentPage extends StatefulWidget {
  final Department? department;

  const CreateDepartmentPage({this.department, super.key});

  @override
  State<StatefulWidget> createState() {
    return _CreateDepartmentPageState();
  }
}

class _CreateDepartmentPageState
    extends BasePageState<CreateDepartmentPage, CreateDepartmentBloc> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _codeController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.department != null) {
      bloc.add(InitEditMode(department: widget.department!));
      _nameController.text = widget.department!.name;
      _codeController.text = widget.department!.code;
      _descriptionController.text = widget.department!.description ?? '';
    }
    bloc.add(const GetManagersEvent());
  }

  @override
  void dispose() {
    _nameController.dispose();
    _codeController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget buildPage(BuildContext context) {
    return CommonScaffold(
      hideKeyboardWhenTouchOutside: true,
      backgroundColor: AppColors.current.backgroundLayer1,
      appBar: CommonAppBar(
        text: widget.department != null ? 'Sửa phòng ban' : 'Tạo phòng ban',
        leadingIcon: LeadingIcon.newBack,
        onLeadingPressed: () => navigator.pop(useRootNavigator: true),
      ),
      body: BlocListener<CreateDepartmentBloc, CreateDepartmentState>(
        listenWhen: (previous, current) =>
            previous.createDepartmentStatus != current.createDepartmentStatus ||
            previous.updateDepartmentStatus != current.updateDepartmentStatus ||
            (previous.errorCreateDepartmentMessage !=
                    current.errorCreateDepartmentMessage &&
                current.errorCreateDepartmentMessage != null),
        listener: (context, state) {
          if (state.createDepartmentStatus == LoadDataStatus.success) {
            showAppSnackBar(
              context,
              message: 'Tạo phòng ban thành công',
              backgroundColor: AppColors.current.blackColor,
            );
          }
          if (state.updateDepartmentStatus == LoadDataStatus.success) {
            showAppSnackBar(
              context,
              message: 'Cập nhật phòng ban thành công',
              backgroundColor: AppColors.current.blackColor,
            );
          }
          if (state.errorCreateDepartmentMessage != null &&
              state.errorCreateDepartmentMessage!.isNotEmpty) {
            showDialog(
              barrierDismissible: false,
              useSafeArea: true,
              context: context,
              builder: (BuildContext dialogContext) {
                return CustomConfirmDialog(
                  icon: Image.asset(
                    Assets.images.icons.error.path,
                    width: Dimens.d50.responsive(),
                    height: Dimens.d50.responsive(),
                  ),
                  description: state.errorCreateDepartmentMessage,
                  confirmText: S.current.confirm,
                  colorConfirmButton: AppColors.current.errorTextColor,
                  onConfirm: () {
                    navigator.pop(useRootNavigator: true);
                    bloc.add(const ClearCreateDepartmentErrorMessage());
                  },
                );
              },
            );
          }
        },
        child: BlocBuilder<CreateDepartmentBloc, CreateDepartmentState>(
          builder: (context, state) {
            return SingleChildScrollView(
              child: Column(
                children: [
                  _buildHeaderCard(),
                  SizedBox(height: Dimens.d16.responsive()),
                  _buildFormCard(state),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildHeaderCard() {
    return Container(
      margin: EdgeInsets.all(Dimens.d16.responsive()),
      padding: EdgeInsets.all(Dimens.d20.responsive()),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF2563EB), Color(0xFF1E40AF)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(Dimens.d16.responsive()),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Cơ cấu tổ chức',
                  style: AppTextStyles.titleTextDefault(
                    fontSize: Dimens.d20.responsive(),
                    fontWeight: FontWeight.bold,
                    color: AppColors.current.whiteColor,
                  ),
                ),
                SizedBox(height: Dimens.d8.responsive()),
                Text(
                  'Thiết lập không gian làm việc chuyên nghiệp cho đội ngũ của bạn.',
                  style: AppTextStyles.titleTextDefault(
                    fontSize: Dimens.d14.responsive(),
                    color: AppColors.current.whiteColor.withValues(alpha: 0.9),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: Dimens.d16.responsive()),
          Container(
            width: Dimens.d80.responsive(),
            height: Dimens.d80.responsive(),
            decoration: BoxDecoration(
              color: AppColors.current.whiteColor.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(Dimens.d12.responsive()),
            ),
            child: Icon(
              Icons.business,
              size: Dimens.d40.responsive(),
              color: AppColors.current.whiteColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFormCard(CreateDepartmentState state) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: Dimens.d16.responsive()),
      padding: EdgeInsets.all(Dimens.d20.responsive()),
      decoration: BoxDecoration(
        color: AppColors.current.whiteColor,
        borderRadius: BorderRadius.circular(Dimens.d16.responsive()),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSection(
            title: 'Tên phòng ban',
            required: true,
            child: CommonTextField(
              controller: _nameController,
              hintText: 'Nhập tên phòng ban',
              height: Dimens.d48.responsive(),
              onChanged: (value) =>
                  bloc.add(DepartmentNameChanged(name: value)),
              hintStyle: AppTextStyles.titleTextDefault(
                fontSize: Dimens.d14.responsive(),
                color: AppColors.current.secondaryTextColor,
              ),
              textStyle: AppTextStyles.titleTextDefault(
                fontSize: Dimens.d14.responsive(),
                color: AppColors.current.blackColor,
              ),
              borderColor: AppColors.current.borderDefaultColor,
            ),
          ),
          SizedBox(height: Dimens.d16.responsive()),
          _buildSection(
            title: 'Mã phòng',
            required: true,
            child: CommonTextField(
              controller: _codeController,
              hintText: 'NHẬP MÃ PHÒNG (VÍ DỤ: KT, NS)',
              height: Dimens.d48.responsive(),
              onChanged: (value) =>
                  bloc.add(DepartmentCodeChanged(code: value.toUpperCase())),
              hintStyle: AppTextStyles.titleTextDefault(
                fontSize: Dimens.d14.responsive(),
                color: AppColors.current.secondaryTextColor,
              ),
              textStyle: AppTextStyles.titleTextDefault(
                fontSize: Dimens.d14.responsive(),
                color: AppColors.current.blackColor,
                fontWeight: FontWeight.w600,
              ),
              borderColor: AppColors.current.borderDefaultColor,
            ),
          ),
          SizedBox(height: Dimens.d16.responsive()),
          _buildSection(
            title: 'Chọn trưởng phòng',
            required: false,
            child: UserDropdownWithLoadMore(
              allText: 'Tất cả',
              selectedUserId: state.selectedManagerId,
              users: state.managers,
              isLoadingMore: state.isLoadingMoreManagers,
              hasMore: state.hasMoreManagers,
              onLoadMore: () {},
              onChanged: (value) {
                bloc.add(ManagerSelected(managerId: value ?? ''));
              },
            ),
          ),
          SizedBox(height: Dimens.d16.responsive()),
          _buildSection(
            title: 'Mô tả phòng',
            required: false,
            child: CommonTextField(
              controller: _descriptionController,
              hintText: 'Mô tả ngắn gọn về chức năng của phòng',
              minLines: 4,
              maxLines: 6,
              height: Dimens.d100.responsive(),
              keyboardType: TextInputType.multiline,
              onChanged: (value) =>
                  bloc.add(DepartmentDescriptionChanged(description: value)),
              hintStyle: AppTextStyles.titleTextDefault(
                fontSize: Dimens.d14.responsive(),
                color: AppColors.current.secondaryTextColor,
              ),
              textStyle: AppTextStyles.titleTextDefault(
                fontSize: Dimens.d14.responsive(),
                color: AppColors.current.blackColor,
              ),
              borderColor: AppColors.current.borderDefaultColor,
              contentPadding: EdgeInsets.all(Dimens.d12.responsive()),
            ),
          ),
          SizedBox(height: Dimens.d24.responsive()),
          _buildSubmitButton(state),
        ],
      ),
    );
  }

  Widget _buildSubmitButton(CreateDepartmentState state) {
    final isEditMode = widget.department != null;
    final isLoading = state.createDepartmentStatus == LoadDataStatus.loading ||
        state.updateDepartmentStatus == LoadDataStatus.loading;

    return UIButton(
      height: Dimens.d56.responsive(),
      width: double.infinity,
      text: isEditMode ? 'Cập nhật' : 'Tạo mới',
      textSize: Dimens.d16.responsive(),
      fontWeight: FontWeight.w700,
      radius: Dimens.d12.responsive(),
      enableShadow: false,
      color: state.isFormValid ? const Color(0xFF2563EB) : AppColors.neutral400,
      textColor: AppColors.current.whiteColor,
      onTap: (state.isFormValid && !isLoading)
          ? () {
              if (isEditMode) {
                bloc.add(const UpdateDepartmentButtonPressed());
              } else {
                bloc.add(const CreateDepartmentButtonPressed());
              }
            }
          : null,
    );
  }

  Widget _buildSection({
    required String title,
    required bool required,
    required Widget child,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Icons.business_center,
              size: Dimens.d16.responsive(),
              color: AppColors.current.blackColor,
            ),
            SizedBox(width: Dimens.d8.responsive()),
            Text(
              title,
              style: AppTextStyles.titleTextDefault(
                fontSize: Dimens.d14.responsive(),
                fontWeight: FontWeight.w600,
                color: AppColors.current.blackColor,
              ),
            ),
            if (required) ...[
              SizedBox(width: Dimens.d4.responsive()),
              Text(
                '*',
                style: AppTextStyles.titleTextDefault(
                  fontSize: Dimens.d14.responsive(),
                  fontWeight: FontWeight.w600,
                  color: AppColors.current.redColor,
                ),
              ),
            ],
          ],
        ),
        SizedBox(height: Dimens.d8.responsive()),
        child,
      ],
    );
  }
}
