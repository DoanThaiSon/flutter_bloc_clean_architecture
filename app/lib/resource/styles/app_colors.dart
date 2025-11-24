// ignore_for_file: avoid_hard_coded_colors

import '../../app.dart';

class AppColors {
  const AppColors({
    required this.primaryColor,
    required this.secondaryColor,
    required this.primaryTextColor,
    required this.secondaryTextColor,
    required this.primaryGradient,
  });

  static late AppColors current;

  final Color primaryColor;
  final Color secondaryColor;
  final Color primaryTextColor;
  final Color secondaryTextColor;

  final Color baseWhite = const Color(0xFFFFFFFF);

  final Color orange500Color = const Color(0xFFEC6935);
  final Color blue500Color = const Color(0xFF16348F);
  final Color majorColor = const Color(0xFF213970);
  final Color orangeColor = const Color(0xFFEC6935);
  final Color borderDefaultColor = const Color(0xFFCAD1E4);
  final Color redColor = const Color(0xFFFB2C36);
  final Color grayColor = const Color(0xFFCAD1E4);
  final Color tertiaryColor = const Color(0xFFDAE4FF);
  final Color greenColor = const Color(0xFF25EBAC);
  final Color whiteColor = const Color(0xFFFFFFFF);
  final Color textLinkColor = const Color(0xFF16348F);
  final Color blackColor = const Color(0xFF000000);
  final Color backgroundSetting = const Color(0xFFF0F4FF);
  final Color mapRoute = const Color(0xFF3161FF);
  final Color completeColor = const Color(0xFFE6FEE8);
  final Color completeTextColor = const Color(0xFF32A661);
  final Color location = const Color(0xFF51bdd9);
  final Color firstLocation = const Color(0xffe27139);

  final Color borderFocusColor = const Color(0xFF16348F);
  final Color errorTextColor = const Color(0xFFFB2C36);
  final Color iconDisableColor = const Color(0xFFCAD1E4);
  final Color backgroundLayer1 = const Color(0xFFF0F4FF);
  final Color backgroundNoInternet = const Color(0xfffff5f6);

  Color get backgroundLayer2 => baseWhite;
  static const Color transparent = Color(0x00000000);

  final Color textFocusColor = const Color(0xFFEC6935);
  Color get textInverse => baseWhite;

  final Color buttonTertiary = const Color(0xFFDAE4FF);

  /// gradient
  final LinearGradient primaryGradient;

  static const defaultAppColor = AppColors(
    primaryColor: Color(0xFF0C215C),
    secondaryColor: Color(0xFF909AB1),
    primaryTextColor: Color(0xFF0C215C),
    secondaryTextColor: Color(0xFF909AB1),
    primaryGradient: LinearGradient(colors: [Color(0xFFFFFFFF), Color(0xFFFE6C30)]),
  );

  static const darkThemeColor = AppColors(
    primaryColor: Color.fromARGB(255, 62, 62, 70),
    secondaryColor: Color.fromARGB(255, 166, 168, 254),
    primaryTextColor: Color.fromARGB(255, 166, 168, 254),
    secondaryTextColor: Color.fromARGB(255, 62, 62, 70),
    primaryGradient: LinearGradient(colors: [Color(0xFFFFFFFF), Color(0xFFFE6C30)]),
  );

  static AppColors of(BuildContext context) {
    final appColor = Theme.of(context).appColor;

    current = appColor;

    return current;
  }

  AppColors copyWith({
    Color? primaryColor,
    Color? secondaryColor,
    Color? primaryTextColor,
    Color? secondaryTextColor,
    LinearGradient? primaryGradient,
  }) {
    return AppColors(
      primaryColor: primaryColor ?? this.primaryColor,
      secondaryColor: secondaryColor ?? this.secondaryColor,
      primaryTextColor: primaryTextColor ?? this.primaryTextColor,
      secondaryTextColor: secondaryTextColor ?? this.secondaryTextColor,
      primaryGradient: primaryGradient ?? this.primaryGradient,
    );
  }

  static const Color neutral50 = Color(0xffF7F7F8);
  static const Color neutral100 = Color(0xffEEEEF0);
  static const Color neutral200 = Color(0xffDADADD);
  static const Color neutral300 = Color(0xffB9BAC0);
  static const Color neutral400 = Color(0xff92939E);
  static const Color neutral500 = Color(0xff757682);
  static const Color neutral600 = Color(0xff5F5F6A);
  static const Color neutral700 = Color(0xff4D4D57);
  static const Color neutral800 = Color(0xff42424A);
  static const Color neutral900 = Color(0xff3A3A40);
  static const Color neutral950 = Color(0xff141416);

  ///Primary Button
  Color get buttonPrimaryInitialColor => orangeColor;
  Color get buttonPrimaryInitialTextColor => whiteColor;
  Color get buttonPrimaryFocusColor => orangeColor;
  Color get buttonPrimaryFocusTextColor => whiteColor;
  Color get buttonPrimaryDisabledColor => neutral200;
  Color get buttonPrimaryDisableTextColor => neutral500;
  Color get buttonPrimaryCircleProgressColor => whiteColor;
}
