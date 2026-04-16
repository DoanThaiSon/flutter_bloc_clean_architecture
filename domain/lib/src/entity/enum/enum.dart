import 'package:flutter/material.dart';
import 'package:resources/resources.dart';
import 'package:shared/shared.dart';

enum InitialAppRoute {
  welcome,
  login,
  main,
}

enum LoadDataStatus { init, fail, success, loading }

enum Gender {
  male(ServerRequestResponseConstants.male),
  female(ServerRequestResponseConstants.female),
  other(ServerRequestResponseConstants.other),
  unknown(ServerRequestResponseConstants.unknown);

  const Gender(this.serverValue);

  final String serverValue;

  static const defaultValue = unknown;
}

enum LanguageCode {
  en(
    localeCode: LocaleConstants.en,
    serverValue: ServerRequestResponseConstants.en,
  ),
  ja(
    localeCode: LocaleConstants.ja,
    serverValue: ServerRequestResponseConstants.ja,
  ),
  vi(
    localeCode: LocaleConstants.vi,
    serverValue: ServerRequestResponseConstants.vi,
  );

  const LanguageCode({
    required this.localeCode,
    required this.serverValue,
  });

  final String localeCode;
  final String serverValue;

  static LanguageCode get defaultValue => vi;

  String get getFullCountryNameByLanguage {
    switch (this) {
      case LanguageCode.vi:
        return S.current.vietnamese;
      case LanguageCode.en:
        return S.current.english;
      case LanguageCode.ja:
        return S.current.japanese;
    }
  }
}

enum NotificationType {
  unknown,
  newPost,
  liked;

  static const defaultValue = unknown;
}

enum BottomTab {
  homeAttendance(icon: Icon(Icons.home), activeIcon: Icon(Icons.home)),
  historyAttendance(icon: Icon(Icons.history), activeIcon: Icon(Icons.history)),
  profileAttendance(icon: Icon(Icons.person), activeIcon: Icon(Icons.person));

  const BottomTab({
    required this.icon,
    required this.activeIcon,
  });

  final Icon icon;
  final Icon activeIcon;

  String get title {
    switch (this) {
      case BottomTab.homeAttendance:
        return S.current.home;
      case BottomTab.historyAttendance:
        return 'Lịch sử';
      case BottomTab.profileAttendance:
        return S.current.account;
    }
  }
}
enum LeaveType {
  halfDay('Nghỉ nửa ngày', 'half_day'),
  oneDay('Nghỉ 1 ngày', 'full_day'),
  multipleDays('Nghỉ nhiều ngày', 'multiple_days');

  const LeaveType(this.displayName, this.apiValue);

  final String displayName;
  final String apiValue;

  static LeaveType? fromDisplayName(String? displayName) {
    if (displayName == null) {
      return null;
    }
    try {
      return LeaveType.values.firstWhere(
            (type) => type.displayName == displayName,
      );
    } catch (e) {
      return null;
    }
  }

  static LeaveType? fromApiValue(String? apiValue) {
    if (apiValue == null) {
      return null;
    }
    try {
      return LeaveType.values.firstWhere(
            (type) => type.apiValue == apiValue,
      );
    } catch (e) {
      return null;
    }
  }
}

enum Shift {
  fullDay('Cả ngày', 'full_day'),
  morning('Ca sáng', 'morning'),
  afternoon('Ca chiều', 'afternoon');

  const Shift(this.displayName, this.apiValue);

  final String displayName;
  final String apiValue;

  static Shift? fromDisplayName(String? displayName) {
    if (displayName == null) {
      return null;
    }
    try {
      return Shift.values.firstWhere(
            (shift) => shift.displayName == displayName,
      );
    } catch (e) {
      return null;
    }
  }

  static Shift? fromApiValue(String? apiValue) {
    if (apiValue == null) {
      return null;
    }
    try {
      return Shift.values.firstWhere(
            (shift) => shift.apiValue == apiValue,
      );
    } catch (e) {
      return null;
    }
  }
}
