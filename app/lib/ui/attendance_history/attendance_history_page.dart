import 'package:auto_route/auto_route.dart';
import '../../app.dart';
import 'bloc/attendance_history.dart';

@RoutePage()
class AttendanceHistoryPage extends StatefulWidget {
  const AttendanceHistoryPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _AttendanceHistoryPageState();
  }
}

class _AttendanceHistoryPageState
    extends BasePageState<AttendanceHistoryPage, AttendanceHistoryBloc> {
  @override
  Widget buildPage(BuildContext context) {
    return CommonScaffold(
      backgroundColor: AppColors.current.backgroundLayer1,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.all(Dimens.d16.responsive()),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildMonthSelector(),
                      SizedBox(height: Dimens.d24.responsive()),
                      _buildSummaryCards(),
                      SizedBox(height: Dimens.d24.responsive()),
                      _buildCalendar(),
                      SizedBox(height: Dimens.d24.responsive()),
                      _buildDetailsList(),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.all(Dimens.d16.responsive()),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                width: Dimens.d40.responsive(),
                height: Dimens.d40.responsive(),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.current.blue500Color,
                ),
                child: Icon(
                  Icons.person,
                  color: AppColors.current.whiteColor,
                  size: Dimens.d24.responsive(),
                ),
              ),
              SizedBox(width: Dimens.d12.responsive()),
              Text(
                'Chấm công',
                style: AppTextStyles.titleTextDefault(
                  fontSize: Dimens.d18.responsive(),
                  fontWeight: FontWeight.w700,
                  color: AppColors.current.blue500Color,
                ),
              ),
            ],
          ),
          Icon(
            Icons.notifications,
            color: AppColors.current.blue500Color,
            size: Dimens.d24.responsive(),
          ),
        ],
      ),
    );
  }

  Widget _buildMonthSelector() {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: Dimens.d16.responsive(),
        vertical: Dimens.d12.responsive(),
      ),
      decoration: BoxDecoration(
        color: AppColors.current.whiteColor,
        borderRadius: BorderRadius.circular(Dimens.d12.responsive()),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Icon(
            Icons.chevron_left,
            color: AppColors.current.blue500Color,
            size: Dimens.d24.responsive(),
          ),
          Column(
            children: [
              Text(
                'Tháng 10, 2023',
                style: AppTextStyles.titleTextDefault(
                  fontSize: Dimens.d16.responsive(),
                  fontWeight: FontWeight.w700,
                  color: AppColors.current.primaryTextColor,
                ),
              ),
              Text(
                'Chọn tháng khác',
                style: AppTextStyles.titleTextDefault(
                  fontSize: Dimens.d12.responsive(),
                  fontWeight: FontWeight.w400,
                  color: AppColors.current.secondaryTextColor,
                ),
              ),
            ],
          ),
          Icon(
            Icons.chevron_right,
            color: AppColors.current.blue500Color,
            size: Dimens.d24.responsive(),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCards() {
    return Row(
      children: [
        Expanded(
          child: _buildSummaryCard(
            label: 'TỔNG NGÀY',
            value: '22',
            subtitle: 'Tháng này',
            backgroundColor: AppColors.current.tertiaryColor,
          ),
        ),
        SizedBox(width: Dimens.d12.responsive()),
        Expanded(
          child: _buildSummaryCard(
            label: 'ĐI MUỘN',
            value: '02',
            subtitle: 'Lần',
            backgroundColor: AppColors.current.redColor.withValues(alpha: 0.1),
            valueColor: AppColors.current.redColor,
          ),
        ),
        SizedBox(width: Dimens.d12.responsive()),
        Expanded(
          child: _buildSummaryCard(
            label: 'NGHỈ PHÉP',
            value: '01',
            subtitle: 'Ngày',
            backgroundColor: AppColors.current.backgroundLayer1,
          ),
        ),
      ],
    );
  }

  Widget _buildSummaryCard({
    required String label,
    required String value,
    required String subtitle,
    required Color backgroundColor,
    Color? valueColor,
  }) {
    return Container(
      padding: EdgeInsets.all(Dimens.d12.responsive()),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(Dimens.d12.responsive()),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: AppTextStyles.titleTextDefault(
              fontSize: Dimens.d10.responsive(),
              fontWeight: FontWeight.w600,
              color: AppColors.current.secondaryTextColor,
            ),
          ),
          SizedBox(height: Dimens.d4.responsive()),
          Text(
            value,
            style: AppTextStyles.titleTextDefault(
              fontSize: Dimens.d24.responsive(),
              fontWeight: FontWeight.w700,
              color: valueColor ?? AppColors.current.primaryTextColor,
            ),
          ),
          Text(
            subtitle,
            style: AppTextStyles.titleTextDefault(
              fontSize: Dimens.d10.responsive(),
              fontWeight: FontWeight.w400,
              color: AppColors.current.secondaryTextColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCalendar() {
    return Container(
      padding: EdgeInsets.all(Dimens.d16.responsive()),
      decoration: BoxDecoration(
        color: AppColors.current.whiteColor,
        borderRadius: BorderRadius.circular(Dimens.d16.responsive()),
      ),
      child: Column(
        children: [
          _buildWeekDays(),
          SizedBox(height: Dimens.d12.responsive()),
          _buildCalendarGrid(),
          SizedBox(height: Dimens.d16.responsive()),
          _buildLegend(),
        ],
      ),
    );
  }

  Widget _buildWeekDays() {
    final days = ['T2', 'T3', 'T4', 'T5', 'T6', 'T7', 'CN'];
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: days
          .map((day) => SizedBox(
                width: Dimens.d36.responsive(),
                child: Center(
                  child: Text(
                    day,
                    style: AppTextStyles.titleTextDefault(
                      fontSize: Dimens.d12.responsive(),
                      fontWeight: FontWeight.w600,
                      color: AppColors.current.secondaryTextColor,
                    ),
                  ),
                ),
              ))
          .toList(),
    );
  }

  Widget _buildCalendarGrid() {
    return Column(
      children: [
        _buildWeekRow([25, 26, 27, 28, 29, 30, 1],
            isCurrentMonth: [false, false, false, false, false, false, true]),
        SizedBox(height: Dimens.d8.responsive()),
        _buildWeekRow([
          2,
          3,
          4,
          5,
          6,
          7,
          8
        ], statuses: [
          'present',
          'present',
          'late',
          'present',
          'present',
          null,
          null
        ]),
        SizedBox(height: Dimens.d8.responsive()),
        _buildWeekRow([
          9,
          10,
          11,
          12,
          13,
          14,
          15
        ], statuses: [
          'present',
          'present',
          'present',
          'present',
          'present',
          null,
          null
        ]),
      ],
    );
  }

  Widget _buildWeekRow(List<int> days,
      {List<bool>? isCurrentMonth, List<String?>? statuses}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: List.generate(
        days.length,
        (index) => _buildDayCell(
          days[index],
          isCurrentMonth: isCurrentMonth?[index] ?? true,
          status: statuses?[index],
        ),
      ),
    );
  }

  Widget _buildDayCell(int day, {bool isCurrentMonth = true, String? status}) {
    Color? dotColor;
    if (status == 'present') {
      dotColor = AppColors.current.greenColor;
    } else if (status == 'late') {
      dotColor = AppColors.current.redColor;
    } else if (status == 'leave') {
      dotColor = AppColors.current.secondaryTextColor;
    }

    return Container(
      width: Dimens.d36.responsive(),
      height: Dimens.d36.responsive(),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: day == 1
            ? Border.all(
                color: AppColors.current.blue500Color,
                width: 2,
              )
            : null,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            day.toString(),
            style: AppTextStyles.titleTextDefault(
              fontSize: Dimens.d14.responsive(),
              fontWeight: FontWeight.w600,
              color: isCurrentMonth
                  ? AppColors.current.primaryTextColor
                  : AppColors.current.secondaryTextColor.withValues(alpha: 0.3),
            ),
          ),
          if (dotColor != null) ...[
            SizedBox(height: Dimens.d2.responsive()),
            Container(
              width: Dimens.d4.responsive(),
              height: Dimens.d4.responsive(),
              decoration: BoxDecoration(
                color: dotColor,
                shape: BoxShape.circle,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildLegend() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildLegendItem('Đúng giờ', AppColors.current.greenColor),
        SizedBox(width: Dimens.d16.responsive()),
        _buildLegendItem('Đi muộn', AppColors.current.redColor),
        SizedBox(width: Dimens.d16.responsive()),
        _buildLegendItem('Nghỉ phép', AppColors.current.secondaryTextColor),
      ],
    );
  }

  Widget _buildLegendItem(String label, Color color) {
    return Row(
      children: [
        Container(
          width: Dimens.d8.responsive(),
          height: Dimens.d8.responsive(),
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        SizedBox(width: Dimens.d4.responsive()),
        Text(
          label,
          style: AppTextStyles.titleTextDefault(
            fontSize: Dimens.d11.responsive(),
            fontWeight: FontWeight.w400,
            color: AppColors.current.secondaryTextColor,
          ),
        ),
      ],
    );
  }

  Widget _buildDetailsList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Nhật ký chi tiết',
          style: AppTextStyles.titleTextDefault(
            fontSize: Dimens.d18.responsive(),
            fontWeight: FontWeight.w700,
            color: AppColors.current.primaryTextColor,
          ),
        ),
        SizedBox(height: Dimens.d16.responsive()),
        _buildDetailItem('TH 6', '13', '08:24', '17:35', '8.5h'),
        SizedBox(height: Dimens.d12.responsive()),
        _buildDetailItem('TH 5', '12', '08:28', '17:32', '8.0h'),
        SizedBox(height: Dimens.d12.responsive()),
        _buildDetailItem('TH 4', '11', '09:15', '18:05', '7.8h', isLate: true),
      ],
    );
  }

  Widget _buildDetailItem(
    String dayLabel,
    String day,
    String checkIn,
    String checkOut,
    String total, {
    bool isLate = false,
  }) {
    return Container(
      padding: EdgeInsets.all(Dimens.d16.responsive()),
      decoration: BoxDecoration(
        color: AppColors.current.whiteColor,
        borderRadius: BorderRadius.circular(Dimens.d12.responsive()),
      ),
      child: Row(
        children: [
          Column(
            children: [
              Text(
                dayLabel,
                style: AppTextStyles.titleTextDefault(
                  fontSize: Dimens.d12.responsive(),
                  fontWeight: FontWeight.w400,
                  color: isLate
                      ? AppColors.current.redColor
                      : AppColors.current.secondaryTextColor,
                ),
              ),
              Text(
                day,
                style: AppTextStyles.titleTextDefault(
                  fontSize: Dimens.d24.responsive(),
                  fontWeight: FontWeight.w700,
                  color: isLate
                      ? AppColors.current.redColor
                      : AppColors.current.primaryTextColor,
                ),
              ),
            ],
          ),
          SizedBox(width: Dimens.d24.responsive()),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildTimeColumn('VÀO', checkIn, isLate),
                _buildTimeColumn('RA', checkOut, false),
                _buildTimeColumn('TỔNG', total, false),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimeColumn(String label, String time, bool isHighlight) {
    return Column(
      children: [
        Text(
          label,
          style: AppTextStyles.titleTextDefault(
            fontSize: Dimens.d10.responsive(),
            fontWeight: FontWeight.w600,
            color: AppColors.current.secondaryTextColor,
          ),
        ),
        SizedBox(height: Dimens.d4.responsive()),
        Text(
          time,
          style: AppTextStyles.titleTextDefault(
            fontSize: Dimens.d16.responsive(),
            fontWeight: FontWeight.w700,
            color: isHighlight
                ? AppColors.current.redColor
                : AppColors.current.primaryTextColor,
          ),
        ),
      ],
    );
  }
}
