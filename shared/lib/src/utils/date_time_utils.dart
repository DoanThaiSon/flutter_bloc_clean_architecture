import 'package:dartx/dartx.dart';
import 'package:intl/intl.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import '../../shared.dart';

class DateTimeUtils {
  DateTimeUtils._();

  static int daysBetween(DateTime from, DateTime to) {
    from = DateTime(from.year, from.month, from.day);
    to = DateTime(to.year, to.month, to.day);

    return (to.difference(from).inHours / 24).round();
  }

  static int timezoneOffset() {
    return DateTime.now().timeZoneOffset.inHours;
  }

  static DateTime toLocalFromTimestamp({required int utcTimestampMillis}) {
    return DateTime.fromMillisecondsSinceEpoch(utcTimestampMillis, isUtc: true)
        .toLocal();
  }

  static DateTime toUtcFromTimestamp(int localTimestampMillis) {
    return DateTime.fromMillisecondsSinceEpoch(localTimestampMillis,
        isUtc: false)
        .toUtc();
  }

  static DateTime startTimeOfDate() {
    final now = DateTime.now();

    return DateTime(
      now.year,
      now.month,
      now.day,
    );
  }

  static DateTime? toDateTime(String dateTimeString, {bool isUtc = false}) {
    final dateTime = DateTime.tryParse(dateTimeString);
    if (dateTime != null) {
      if (isUtc) {
        return DateTime.utc(
          dateTime.year,
          dateTime.month,
          dateTime.day,
          dateTime.hour,
          dateTime.minute,
          dateTime.second,
          dateTime.millisecond,
          dateTime.microsecond,
        );
      }

      return dateTime;
    }

    return null;
  }

  static DateTime? toNormalizeDateTime(String dateTimeString,
      {bool isUtc = false}) {
    final dateTime = DateTime.tryParse('-123450101 $dateTimeString');
    if (dateTime != null) {
      if (isUtc) {
        return DateTime.utc(
          dateTime.year,
          dateTime.month,
          dateTime.day,
          dateTime.hour,
          dateTime.minute,
          dateTime.second,
          dateTime.millisecond,
          dateTime.microsecond,
        );
      }

      return dateTime;
    }

    return null;
  }

  static DateTime? tryParse({
    String? date,
    String? format,
    String locale = LocaleConstants.defaultLocale,
  }) {
    if (date == null) {
      return null;
    }

    if (format == null) {
      return DateTime.tryParse(date);
    }

    final DateFormat dateFormat = DateFormat(format, locale);
    try {
      return dateFormat.parse(date);
    } catch (e) {
      return null;
    }
  }
  static String formatNotificationTime(String? dateIso) {
    if (dateIso == null || dateIso.isEmpty) {
      return '';
    }

    try {
      final dateTime = DateTime.parse(dateIso).toLocal();
      final now = DateTime.now();

      final isToday = dateTime.year == now.year &&
          dateTime.month == now.month &&
          dateTime.day == now.day;

      if (isToday) {
        return DateFormat('HH:mm').format(dateTime);
      } else {
        return DateFormat('dd/MM/yyyy').format(dateTime);
      }
    } catch (_) {
      return '';
    }
  }

  static String formatIsoString(
      String? dateIso, {
        String format = 'dd/MM/yyyy',
      }) {
    if (dateIso == null || dateIso.isEmpty) {
      return '';
    }
    try {
      final dt = DateTime.parse(dateIso).toLocal();
      return DateFormat(format).format(dt);
    } catch (_) {
      return '';
    }
  }
}

extension DateTimeExtensions on DateTime {
  String toStringWithFormat(String format) {
    return DateFormat(format).format(this);
  }

  DateTime get lastDateOfMonth {
    return DateTime(year, month + 1, 0);
  }

  /// Format ngày tháng theo tiếng Việt
  /// Ví dụ: "Thứ Tư, 24 Tháng 5"
  String toVietnameseDateString() {
    const weekDays = [
      'Thứ Hai',
      'Thứ Ba',
      'Thứ Tư',
      'Thứ Năm',
      'Thứ Sáu',
      'Thứ Bảy',
      'Chủ Nhật',
    ];

    final weekDay = weekDays[weekday - 1];
    return '$weekDay, $day Tháng $month';
  }

  /// Format ngày tháng đầy đủ theo tiếng Việt
  /// Ví dụ: "Thứ Tư, 24 Tháng 5 Năm 2024"
  String toVietnameseFullDateString() {
    const weekDays = [
      'Thứ Hai',
      'Thứ Ba',
      'Thứ Tư',
      'Thứ Năm',
      'Thứ Sáu',
      'Thứ Bảy',
      'Chủ Nhật',
    ];

    final weekDay = weekDays[weekday - 1];
    return '$weekDay, $day Tháng $month Năm $year';
  }
}


extension DateTimeTimezoneExtension on DateTime {
  Map<String, tz.Location> get getTimeZoneDatabase {
    tz.initializeTimeZones();

    return tz.timeZoneDatabase.locations;
  }

  int _getESTtoUTCDifference(String locationName) {
    tz.initializeTimeZones();
    final locationNY = tz.getLocation(locationName);
    final tz.TZDateTime nowNY = tz.TZDateTime.now(locationNY);

    return nowNY.timeZoneOffset.inHours;
  }

  DateTime toESTzone(String locationName) {
    DateTime result = toUtc(); // local time to UTC
    result = result.add(Duration(
        hours: _getESTtoUTCDifference(locationName))); // convert UTC to EST

    return result;
  }

  DateTime fromESTzone(String locationName) {
    DateTime result = subtract(Duration(
        hours: _getESTtoUTCDifference(locationName))); // convert EST to UTC

    String dateTimeAsIso8601String = result.toIso8601String();
    dateTimeAsIso8601String +=
    dateTimeAsIso8601String.characters.last.equalsIgnoreCase('Z')
        ? ''
        : 'Z';
    result = DateTime.parse(dateTimeAsIso8601String); // make isUtc to be true

    result = result.toLocal(); // convert UTC to local time

    return result;
  }
}
