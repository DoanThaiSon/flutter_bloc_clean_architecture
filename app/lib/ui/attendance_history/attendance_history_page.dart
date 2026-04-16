import 'package:auto_route/auto_route.dart';
import 'package:domain/domain.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
  void initState() {
    super.initState();
    bloc.add(const AttendanceHistoryPageInitiated());
  }

  @override
  Widget buildPage(BuildContext context) {
    return CommonScaffold(
      backgroundColor: AppColors.current.backgroundLayer1,
      body: SafeArea(
        child: Column(
          children: [
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

  Widget _buildMonthSelector() {
    return BlocBuilder<AttendanceHistoryBloc, AttendanceHistoryState>(
      buildWhen: (previous, current) =>
          previous.selectedMonth != current.selectedMonth ||
          previous.selectedYear != current.selectedYear,
      builder: (context, state) {
        final monthNames = [
          'Tháng 1',
          'Tháng 2',
          'Tháng 3',
          'Tháng 4',
          'Tháng 5',
          'Tháng 6',
          'Tháng 7',
          'Tháng 8',
          'Tháng 9',
          'Tháng 10',
          'Tháng 11',
          'Tháng 12'
        ];

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
              GestureDetector(
                onTap: () {
                  int newMonth = state.selectedMonth - 1;
                  int newYear = state.selectedYear;
                  if (newMonth < 1) {
                    newMonth = 12;
                    newYear--;
                  }
                  bloc.add(AttendanceHistoryMonthChanged(
                    month: newMonth,
                    year: newYear,
                  ));
                },
                child: Icon(
                  Icons.chevron_left,
                  color: AppColors.current.blue500Color,
                  size: Dimens.d24.responsive(),
                ),
              ),
              Column(
                children: [
                  Text(
                    '${monthNames[state.selectedMonth - 1]}, ${state.selectedYear}',
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
              GestureDetector(
                onTap: () {
                  int newMonth = state.selectedMonth + 1;
                  int newYear = state.selectedYear;
                  if (newMonth > 12) {
                    newMonth = 1;
                    newYear++;
                  }
                  bloc.add(AttendanceHistoryMonthChanged(
                    month: newMonth,
                    year: newYear,
                  ));
                },
                child: Icon(
                  Icons.chevron_right,
                  color: AppColors.current.blue500Color,
                  size: Dimens.d24.responsive(),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSummaryCards() {
    return BlocBuilder<AttendanceHistoryBloc, AttendanceHistoryState>(
      buildWhen: (previous, current) =>
          previous.attendanceHistory?.summary != current.attendanceHistory?.summary,
      builder: (context, state) {
        final summary = state.attendanceHistory?.summary;
        return Row(
          children: [
            Expanded(
              child: _buildSummaryCard(
                label: 'TỔNG NGÀY',
                value: '${summary?.totalDays ?? 0}',
                subtitle: 'Tháng này',
                backgroundColor: AppColors.current.tertiaryColor,
              ),
            ),
            SizedBox(width: Dimens.d12.responsive()),
            Expanded(
              child: _buildSummaryCard(
                label: 'ĐI MUỘN',
                value: '${summary?.late ?? 0}',
                subtitle: 'Lần',
                backgroundColor: AppColors.current.redColor.withValues(alpha: 0.1),
                valueColor: AppColors.current.redColor,
              ),
            ),
            SizedBox(width: Dimens.d12.responsive()),
            Expanded(
              child: _buildSummaryCard(
                label: 'NGHỈ PHÉP',
                value: '${summary?.leave ?? 0.0}',
                subtitle: 'Ngày',
                backgroundColor: AppColors.current.completeTextColor.withValues(alpha: 0.1),
                valueColor: AppColors.current.blackColor,
              ),
            ),
          ],
        );
      },
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
              color: AppColors.current.blackColor,
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
              color: AppColors.current.blackColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCalendar() {
    return BlocBuilder<AttendanceHistoryBloc, AttendanceHistoryState>(
      buildWhen: (previous, current) =>
          previous.selectedMonth != current.selectedMonth ||
          previous.selectedYear != current.selectedYear ||
          previous.selectedDate != current.selectedDate ||
          previous.attendanceHistory != current.attendanceHistory,
      builder: (context, state) {
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
              _buildCalendarGrid(state),
              SizedBox(height: Dimens.d16.responsive()),
              _buildLegend(),
            ],
          ),
        );
      },
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

  Widget _buildCalendarGrid(AttendanceHistoryState state) {
    final firstDayOfMonth = DateTime(state.selectedYear, state.selectedMonth, 1);
    final lastDayOfMonth =
        DateTime(state.selectedYear, state.selectedMonth + 1, 0);
    final daysInMonth = lastDayOfMonth.day;

    // Get the weekday of the first day (1 = Monday, 7 = Sunday)
    final firstWeekday = firstDayOfMonth.weekday;

    // Calculate days from previous month to show
    final previousMonth = state.selectedMonth == 1 ? 12 : state.selectedMonth - 1;
    final previousYear =
        state.selectedMonth == 1 ? state.selectedYear - 1 : state.selectedYear;
    final lastDayOfPreviousMonth =
        DateTime(previousYear, previousMonth + 1, 0).day;

    final List<Widget> weeks = [];
    List<Widget> currentWeek = [];
    int dayCounter = 1;
    int nextMonthCounter = 1;

    // Fill first week with previous month days if needed
    for (int i = 1; i < firstWeekday; i++) {
      final day = lastDayOfPreviousMonth - (firstWeekday - i - 1);
      currentWeek.add(_buildDayCell(
        day,
        date: DateTime(previousYear, previousMonth, day),
        selectedDate: state.selectedDate,
        isCurrentMonth: false,
      ));
    }

    // Fill current month days
    while (dayCounter <= daysInMonth) {
      final currentDate = DateTime(state.selectedYear, state.selectedMonth, dayCounter);
      final attendance = _getAttendanceForDate(state, currentDate);
      final leaveRecord = _getLeaveRecordForDate(state, currentDate);
      
      // Ưu tiên hiển thị leave record nếu có, nếu không thì hiển thị attendance
      String? status;
      if (leaveRecord != null) {
        status = 'leave';
      } else if (attendance != null && attendance.date != null) {
        status = attendance.status.name;
      }
      
      currentWeek.add(_buildDayCell(
        dayCounter,
        date: currentDate,
        selectedDate: state.selectedDate,
        isCurrentMonth: true,
        status: status,
      ));

      if (currentWeek.length == 7) {
        weeks.add(Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: currentWeek,
        ));
        weeks.add(SizedBox(height: Dimens.d8.responsive()));
        currentWeek = [];
      }

      dayCounter++;
    }

    // Fill remaining days with next month
    while (currentWeek.length < 7) {
      final nextMonth = state.selectedMonth == 12 ? 1 : state.selectedMonth + 1;
      final nextYear =
          state.selectedMonth == 12 ? state.selectedYear + 1 : state.selectedYear;
      currentWeek.add(_buildDayCell(
        nextMonthCounter,
        date: DateTime(nextYear, nextMonth, nextMonthCounter),
        selectedDate: state.selectedDate,
        isCurrentMonth: false,
      ));
      nextMonthCounter++;
    }

    if (currentWeek.isNotEmpty) {
      weeks.add(Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: currentWeek,
      ));
    }

    return Column(children: weeks);
  }

  // Helper method to get attendance for a specific date
  Attendance? _getAttendanceForDate(AttendanceHistoryState state, DateTime date) {
    return state.attendanceHistory?.attendances.firstWhere(
      (attendance) {
        if (attendance.date == null) return false;
        return attendance.date!.year == date.year &&
            attendance.date!.month == date.month &&
            attendance.date!.day == date.day;
      },
      orElse: () => const Attendance(),
    );
  }

  // Helper method to get leave record for a specific date
  LeaveRecord? _getLeaveRecordForDate(AttendanceHistoryState state, DateTime date) {
    final leaveRecords = state.attendanceHistory?.leaveRecords ?? [];
    for (final record in leaveRecords) {
      if (record.date == null) continue;
      if (record.date!.year == date.year &&
          record.date!.month == date.month &&
          record.date!.day == date.day) {
        return record;
      }
    }
    return null;
  }

  // Helper method to get status for a day (mock data for now)
  String? _getStatusForDay(int day) {
    // This method is no longer needed as we get status from API
    return null;
  }

  Widget _buildDayCell(
    int day, {
    required DateTime date,
    DateTime? selectedDate,
    bool isCurrentMonth = true,
    String? status,
  }) {
    Color? dotColor;
    if (status == 'present') {
      dotColor = AppColors.current.greenColor;
    } else if (status == 'late') {
      dotColor = AppColors.current.redColor;
    } else if (status == 'leave') {
      dotColor = AppColors.current.secondaryTextColor;
    }

    final isToday = DateTime.now().year == date.year &&
        DateTime.now().month == date.month &&
        DateTime.now().day == date.day;

    final isSelected = selectedDate != null &&
        selectedDate.year == date.year &&
        selectedDate.month == date.month &&
        selectedDate.day == date.day;

    // Kiểm tra nếu là thứ 7 (6) hoặc chủ nhật (7)
    final isWeekend = date.weekday == DateTime.saturday || date.weekday == DateTime.sunday;

    return GestureDetector(
      onTap: isWeekend ? null : () {
        bloc.add(AttendanceHistoryDaySelected(date: date));
      },
      child: Container(
        width: Dimens.d36.responsive(),
        height: Dimens.d36.responsive(),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isSelected && !isWeekend
              ? AppColors.current.blue500Color.withValues(alpha: 0.1)
              : null,
          border: isToday && !isWeekend
              ? Border.all(
                  color: AppColors.current.blue500Color,
                  width: 2,
                )
              : isSelected && !isWeekend
                  ? Border.all(
                      color: AppColors.current.blue500Color,
                      width: 1.5,
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
                color: isWeekend
                    ? AppColors.current.secondaryTextColor
                    : (isCurrentMonth
                        ? (isSelected
                            ? AppColors.current.blue500Color
                            : AppColors.current.primaryTextColor)
                        : AppColors.current.secondaryTextColor
                            .withValues(alpha: 0.3)),
              ),
            ),
            if (dotColor != null && !isWeekend) ...[
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
    return BlocBuilder<AttendanceHistoryBloc, AttendanceHistoryState>(
      buildWhen: (previous, current) =>
          previous.attendanceHistory?.attendances != current.attendanceHistory?.attendances,
      builder: (context, state) {
        final attendances = state.attendanceHistory?.attendances ?? [];
        
        if (attendances.isEmpty) {
          return Center(
            child: Padding(
              padding: EdgeInsets.all(Dimens.d24.responsive()),
              child: Text(
                'Không có dữ liệu chấm công',
                style: AppTextStyles.titleTextDefault(
                  fontSize: Dimens.d14.responsive(),
                  color: AppColors.current.secondaryTextColor,
                ),
              ),
            ),
          );
        }

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
            ...attendances.map((attendance) {
              return Padding(
                padding: EdgeInsets.only(bottom: Dimens.d12.responsive()),
                child: _buildDetailItemFromAttendance(attendance),
              );
            }).toList(),
          ],
        );
      },
    );
  }

  Widget _buildDetailItemFromAttendance(Attendance attendance) {
    final date = attendance.date;
    if (date == null) return const SizedBox.shrink();

    final dayNames = ['', 'T2', 'T3', 'T4', 'T5', 'T6', 'T7', 'CN'];
    final dayLabel = dayNames[date.weekday];
    final day = date.day.toString();
    
    final checkIn = attendance.checkInTime != null
        ? '${attendance.checkInTime!.hour.toString().padLeft(2, '0')}:${attendance.checkInTime!.minute.toString().padLeft(2, '0')}'
        : '--:--';
    
    final checkOut = attendance.checkOutTime != null
        ? '${attendance.checkOutTime!.hour.toString().padLeft(2, '0')}:${attendance.checkOutTime!.minute.toString().padLeft(2, '0')}'
        : '--:--';
    
    final total = '${attendance.workingHours.toStringAsFixed(1)}h';
    final isLate = attendance.status == AttendanceStatus.late;

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
