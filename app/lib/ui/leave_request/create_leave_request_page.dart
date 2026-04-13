import 'package:auto_route/auto_route.dart';
import 'package:domain/domain.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../app.dart';
import '../../common_view/common_text_field.dart';
import '../../common_view/popup/common_show_snack_bar.dart';
import '../../common_view/ui_button.dart';
import 'bloc/leave_request_bloc.dart';
import 'bloc/leave_request_event.dart';
import 'bloc/leave_request_state.dart';

@RoutePage()
class CreateLeaveRequestPage extends StatefulWidget {
  const CreateLeaveRequestPage({
    super.key,
    this.leaveRequest,
  });

  final LeaveRequest? leaveRequest;

  @override
  State<StatefulWidget> createState() {
    return _CreateLeaveRequestPageState();
  }
}

class _CreateLeaveRequestPageState
    extends BasePageState<CreateLeaveRequestPage, LeaveRequestBloc> {
  final TextEditingController _reasonController = TextEditingController();
  bool _hasSetLeaveCode = false;

  bool get isEditMode => widget.leaveRequest != null;

  @override
  void initState() {
    super.initState();
    bloc.add(const GetLeaveCodes());
  }

  void _loadLeaveRequestData() {
    final request = widget.leaveRequest!;
    _reasonController.text = request.reason;
    String leaveType;
    if (request.dayType == 'full_day') {
      if (request.startDate == request.endDate) {
        leaveType = 'Nghỉ 1 ngày';
      } else {
        leaveType = 'Nghỉ nhiều ngày';
      }
    } else {
      leaveType = 'Nghỉ nửa ngày';
    }

    // Determine shift
    String? shift;
    if (request.dayType == 'full_day') {
      shift = 'Cả ngày';
    } else {
      shift = request.shift == 'morning' ? 'Ca sáng' : 'Ca chiều';
    }

    // Parse dates
    DateTime? selectedDate;
    DateTime? startDate;
    DateTime? endDate;

    if (leaveType == 'Nghỉ nhiều ngày') {
      startDate = DateTime.parse(request.startDate);
      endDate = DateTime.parse(request.endDate);
    } else {
      selectedDate = DateTime.parse(request.startDate);
    }

    final leaveCode = bloc.state.leaveCodes.firstWhere(
      (code) => code.id == request.leaveCodeId,
      orElse: () => bloc.state.leaveCodes.isNotEmpty
          ? bloc.state.leaveCodes.first
          : const LeaveCode(),
    );

    bloc.add(LoadLeaveRequestForEdit(
      leaveType: leaveType,
      shift: shift,
      leaveCodeId: request.leaveCodeId,
      leaveCodeName: leaveCode.name,
      selectedDate: selectedDate,
      startDate: startDate,
      endDate: endDate,
      reason: request.reason,
    ));
  }

  @override
  void dispose() {
    _reasonController.dispose();
    super.dispose();
  }

  @override
  Widget buildPage(BuildContext context) {
    return CommonScaffold(
      hideKeyboardWhenTouchOutside: true,
      backgroundColor: AppColors.current.backgroundLayer1,
      appBar: CommonAppBar(
        text: isEditMode ? 'Sửa đơn xin nghỉ' : 'Đăng ký xin nghỉ',
        leadingIcon: LeadingIcon.newBack,
        onLeadingPressed: () => navigator.pop(useRootNavigator: true),
      ),
      body: BlocListener<LeaveRequestBloc, LeaveRequestState>(
        listener: (context, state) {
          if (state.createLeaveRequestStatus == LoadDataStatus.success) {
            showAppSnackBar(
              context,
              message: 'Tạo đơn nghỉ phép thành công',
              backgroundColor: AppColors.current.blackColor,
            );
          }
          if (state.updateLeaveRequestStatus == LoadDataStatus.success) {
            showAppSnackBar(
              context,
              message: 'Cập nhật đơn nghỉ phép thành công',
              backgroundColor: AppColors.current.blackColor,
            );
          }
          if (isEditMode &&
              !_hasSetLeaveCode &&
              state.leaveCodes.isNotEmpty &&
              widget.leaveRequest!.leaveCodeId.isNotEmpty) {
            _loadLeaveRequestData();
            _hasSetLeaveCode = true;
          }
        },
        child: BlocBuilder<LeaveRequestBloc, LeaveRequestState>(
          builder: (context, state) {
            return SingleChildScrollView(
              padding: EdgeInsets.all(Dimens.d16.responsive()),
              child: Container(
                padding: EdgeInsets.all(Dimens.d16.responsive()),
                decoration: BoxDecoration(
                    color: AppColors.current.whiteColor,
                    borderRadius:
                        BorderRadius.circular(Dimens.d16.responsive())),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildLeaveTypeSection(state),
                    if (state.selectedLeaveType != null) ...[
                      SizedBox(height: Dimens.d16.responsive()),
                      _buildShiftSection(state),
                      SizedBox(height: Dimens.d16.responsive()),
                      _buildLeaveCodeSection(state),
                    ],
                    if (state.selectedLeaveCode != null) ...[
                      SizedBox(height: Dimens.d16.responsive()),
                      _buildDateSection(state),
                    ],
                    if (state.selectedDate != null ||
                        (state.startDate != null && state.endDate != null)) ...[
                      SizedBox(height: Dimens.d16.responsive()),
                      _buildTotalDaysSection(state),
                      SizedBox(height: Dimens.d16.responsive()),
                      _buildReasonSection(state),
                      SizedBox(height: Dimens.d24.responsive()),
                      _buildSubmitButton(state),
                    ],
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildLeaveTypeSection(LeaveRequestState state) {
    return _buildSection(
      title: 'Loại ngày nghỉ',
      required: true,
      child: _buildDropdown(
        hint: 'Chọn loại ngày nghỉ',
        value: state.selectedLeaveType,
        items: const ['Nghỉ 1 ngày', 'Nghỉ nhiều ngày', 'Nghỉ nửa ngày'],
        onChanged: (value) {
          bloc.add(LeaveTypeChanged(leaveType: value));
        },
      ),
    );
  }

  Widget _buildShiftSection(LeaveRequestState state) {
    final isFullDay = state.selectedLeaveType == 'Nghỉ 1 ngày' ||
        state.selectedLeaveType == 'Nghỉ nhiều ngày';

    return _buildSection(
      title: 'Ca nghỉ',
      required: true,
      child: isFullDay
          ? _buildDisabledField('Cả ngày')
          : _buildDropdown(
              hint: 'Chọn ca nghỉ',
              value: state.selectedShift,
              items: const ['Ca sáng', 'Ca chiều'],
              onChanged: (value) {
                bloc.add(ShiftChanged(shift: value));
              },
            ),
    );
  }

  Widget _buildLeaveCodeSection(LeaveRequestState state) {
    final leaveCodeNames = state.leaveCodes.map((code) => code.name).toList();

    return _buildSection(
      title: 'Mã xin nghỉ',
      required: true,
      child: leaveCodeNames.isEmpty
          ? Container(
              height: Dimens.d56.responsive(),
              padding:
                  EdgeInsets.symmetric(horizontal: Dimens.d16.responsive()),
              decoration: BoxDecoration(
                color: AppColors.current.grayColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(Dimens.d8.responsive()),
                border: Border.all(
                  color: AppColors.current.borderDefaultColor,
                ),
              ),
              alignment: Alignment.centerLeft,
              child: Text(
                'Đang tải...',
                style: AppTextStyles.titleTextDefault(
                  fontSize: Dimens.d14.responsive(),
                  fontWeight: FontWeight.w400,
                  color: AppColors.current.secondaryTextColor,
                ),
              ),
            )
          : _buildDropdown(
              hint: 'Chọn mã xin nghỉ',
              value: state.selectedLeaveCode,
              items: leaveCodeNames,
              onChanged: (value) {
                bloc.add(LeaveCodeChanged(leaveCode: value));
              },
            ),
    );
  }

  Widget _buildDateSection(LeaveRequestState state) {
    final isMultipleDays = state.selectedLeaveType == 'Nghỉ nhiều ngày';

    if (isMultipleDays) {
      return Column(
        children: [
          _buildSection(
            title: 'Ngày bắt đầu',
            required: true,
            child: GestureDetector(
              onTap: () => _selectStartDate(context, state),
              child: _buildDateField(
                date: state.startDate,
                hint: 'Chọn ngày bắt đầu',
              ),
            ),
          ),
          SizedBox(height: Dimens.d16.responsive()),
          _buildSection(
            title: 'Ngày kết thúc',
            required: true,
            child: GestureDetector(
              onTap: state.startDate != null
                  ? () => _selectEndDate(context, state)
                  : null,
              child: _buildDateField(
                date: state.endDate,
                hint: 'Chọn ngày kết thúc',
                enabled: state.startDate != null,
              ),
            ),
          ),
        ],
      );
    } else {
      return _buildSection(
        title: 'Ngày xin nghỉ',
        required: true,
        child: GestureDetector(
          onTap: () => _selectDate(context, state),
          child: _buildDateField(
            date: state.selectedDate,
            hint: 'Chọn ngày',
          ),
        ),
      );
    }
  }

  Widget _buildDateField({
    required DateTime? date,
    required String hint,
    bool enabled = true,
  }) {
    return Container(
      height: Dimens.d40.responsive(),
      padding: EdgeInsets.symmetric(horizontal: Dimens.d16.responsive()),
      decoration: BoxDecoration(
        color: enabled
            ? AppColors.current.whiteColor
            : AppColors.current.grayColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(Dimens.d16.responsive()),
        border: Border.all(
          color: AppColors.current.borderDefaultColor,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            date != null ? _formatDate(date) : hint,
            style: AppTextStyles.titleTextDefault(
              fontSize: Dimens.d14.responsive(),
              fontWeight: FontWeight.w400,
              color: date != null
                  ? AppColors.current.blackColor
                  : AppColors.current.secondaryTextColor,
            ),
          ),
          Icon(
            Icons.calendar_today,
            size: Dimens.d20.responsive(),
            color: AppColors.current.secondaryTextColor,
          ),
        ],
      ),
    );
  }

  Widget _buildTotalDaysSection(LeaveRequestState state) {
    return _buildSection(
      title: 'Tổng số ngày',
      required: false,
      child: _buildDisabledField('${state.totalDays} ngày'),
    );
  }

  Widget _buildReasonSection(LeaveRequestState state) {
    return _buildSection(
      title: 'Lý do đăng ký nghỉ',
      required: true,
      child: Container(
        constraints: BoxConstraints(
          minHeight: Dimens.d120.responsive(),
        ),
        child: CommonTextField(
          controller: _reasonController,
          hintText: 'Nhập lý do xin nghỉ của bạn...',
          minLines: 5,
          maxLines: 8,
          height: null,
          keyboardType: TextInputType.multiline,
          onChanged: (value) => bloc.add(ReasonChanged(reason: value)),
          hintStyle: AppTextStyles.titleTextDefault(
            fontSize: Dimens.d14.responsive(),
            fontWeight: FontWeight.w400,
            color: AppColors.current.secondaryTextColor,
          ),
          textStyle: AppTextStyles.titleTextDefault(
            fontSize: Dimens.d14.responsive(),
            fontWeight: FontWeight.w400,
            color: AppColors.current.blackColor,
          ),
          borderColor: AppColors.current.borderDefaultColor,
          contentPadding: EdgeInsets.all(Dimens.d12.responsive()),
        ),
      ),
    );
  }

  Widget _buildSubmitButton(LeaveRequestState state) {
    return UIButton(
      height: Dimens.d56.responsive(),
      width: double.infinity,
      text: isEditMode ? 'Cập nhật đơn' : 'Gửi đơn đăng ký',
      textSize: Dimens.d16.responsive(),
      fontWeight: FontWeight.w700,
      radius: Dimens.d12.responsive(),
      enableShadow: false,
      color: state.isFormValid
          ? AppColors.current.blue500Color
          : AppColors.current.secondaryTextColor,
      textColor: AppColors.current.whiteColor,
      onTap: state.isFormValid
          ? () {
              if (isEditMode) {
                bloc.add(UpdateLeaveRequestButtonPressed(
                  leaveRequestId: widget.leaveRequest!.id,
                ));
              } else {
                bloc.add(const SubmitButtonPressed());
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

  Widget _buildDropdown({
    required String hint,
    required String? value,
    required List<String> items,
    required Function(String) onChanged,
  }) {
    return Container(
      height: Dimens.d40.responsive(),
      padding: EdgeInsets.symmetric(horizontal: Dimens.d16.responsive()),
      decoration: BoxDecoration(
        color: AppColors.current.whiteColor,
        borderRadius: BorderRadius.circular(Dimens.d16.responsive()),
        border: Border.all(
          color: AppColors.current.borderDefaultColor,
        ),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          isExpanded: true,
          hint: Text(
            hint,
            style: AppTextStyles.titleTextDefault(
              fontSize: Dimens.d14.responsive(),
              fontWeight: FontWeight.w400,
              color: AppColors.current.secondaryTextColor,
            ),
          ),
          value: value,
          icon: Icon(
            Icons.keyboard_arrow_down,
            size: Dimens.d24.responsive(),
            color: AppColors.current.secondaryTextColor,
          ),
          style: AppTextStyles.titleTextDefault(
            fontSize: Dimens.d14.responsive(),
            fontWeight: FontWeight.w400,
            color: AppColors.current.blackColor,
          ),
          items: items.map((String item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Text(item),
            );
          }).toList(),
          onChanged: (String? newValue) {
            if (newValue != null) {
              onChanged(newValue);
            }
          },
        ),
      ),
    );
  }

  Widget _buildDisabledField(String text) {
    return Container(
      height: Dimens.d40.responsive(),
      padding: EdgeInsets.symmetric(horizontal: Dimens.d16.responsive()),
      decoration: BoxDecoration(
        color: AppColors.current.grayColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(Dimens.d16.responsive()),
        border: Border.all(
          color: AppColors.current.borderDefaultColor,
        ),
      ),
      alignment: Alignment.centerLeft,
      child: Text(
        text,
        style: AppTextStyles.titleTextDefault(
          fontSize: Dimens.d14.responsive(),
          fontWeight: FontWeight.w400,
          color: AppColors.current.secondaryTextColor,
        ),
      ),
    );
  }

  Future<void> _selectDate(
      BuildContext context, LeaveRequestState state) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: state.selectedDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: AppColors.current.blue500Color,
              onPrimary: AppColors.current.whiteColor,
              onSurface: AppColors.current.primaryTextColor,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      bloc.add(DateChanged(date: picked));
    }
  }

  Future<void> _selectStartDate(
      BuildContext context, LeaveRequestState state) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: state.startDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: AppColors.current.blue500Color,
              onPrimary: AppColors.current.whiteColor,
              onSurface: AppColors.current.primaryTextColor,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      bloc.add(StartDateChanged(date: picked));
    }
  }

  Future<void> _selectEndDate(
      BuildContext context, LeaveRequestState state) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate:
          state.endDate ?? state.startDate!.add(const Duration(days: 1)),
      firstDate: state.startDate!,
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: AppColors.current.blue500Color,
              onPrimary: AppColors.current.whiteColor,
              onSurface: AppColors.current.primaryTextColor,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      bloc.add(EndDateChanged(date: picked));
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }
}
