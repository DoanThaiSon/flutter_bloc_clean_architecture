// ignore_for_file: avoid_hard_coded_text_style


import '../../app.dart';

/// AppTextStyle format as follows:
/// s[fontSize][fontWeight][Color]
/// Example: s18w400Primary

class AppTextStyles {
  AppTextStyles._();

  static const _defaultLetterSpacing = 0.03;

  static const _baseTextStyle = TextStyle(
    letterSpacing: _defaultLetterSpacing,
    // height: 1.0,
  );

  static TextStyle s14w400Primary({
    double? tablet,
    double? ultraTablet,
  }) =>
      _baseTextStyle.merge(TextStyle(
        fontSize:
            Dimens.d14.responsive(tablet: tablet, ultraTablet: ultraTablet),
        fontWeight: FontWeight.w400,
        color: AppColors.current.primaryTextColor,
      ));

  static TextStyle s14w400Secondary({
    double? tablet,
    double? ultraTablet,
  }) =>
      _baseTextStyle.merge(TextStyle(
        fontSize:
            Dimens.d14.responsive(tablet: tablet, ultraTablet: ultraTablet),
        fontWeight: FontWeight.w400,
        color: AppColors.current.secondaryTextColor,
      ));

  static TextStyle titleTextDefault(
          {Color? color,
          double? fontSize,
          FontWeight? fontWeight,
          TextDecoration? decoration}) =>
      _baseTextStyle.merge(TextStyle(
        decoration: decoration,
        fontSize: fontSize ?? Dimens.d14,
        fontWeight: fontWeight ?? FontWeight.w400,
        fontFamily: 'Inter Tight',
        color: color ?? AppColors.defaultAppColor.primaryColor,
      ));

  static TextStyle s24w500Primary({
    double? tablet,
    double? ultraTablet,
    Color? color,
  }) =>
      _baseTextStyle.merge(TextStyle(
        fontSize:
            Dimens.d24.responsive(tablet: tablet, ultraTablet: ultraTablet),
        fontWeight: FontWeight.w600,
        color: color,
        height: Dimens.d24 / Dimens.d18,
      ));

  static TextStyle body2SemiBold({
    Color? color,
  }) =>
      _baseTextStyle.merge(TextStyle(
        fontSize: Dimens.d14,
        fontWeight: FontWeight.w600,
        color: color,
      ));

  static TextStyle title1SemiBold({
    Color? color,
  }) =>
      _baseTextStyle.merge(TextStyle(
        fontSize: Dimens.d24,
        fontWeight: FontWeight.w600,
        color: color,
      ));

  static TextStyle body2Medium({
    Color? color,
  }) =>
      _baseTextStyle.merge(TextStyle(
          fontSize: Dimens.d14, fontWeight: FontWeight.w500, color: color));

  static TextStyle body2Regular({
    Color? color,
  }) =>
      _baseTextStyle.merge(TextStyle(
        fontSize: Dimens.d14,
        fontWeight: FontWeight.w400,
        color: color,
      ));

  static TextStyle s12w400Primary({
    double? tablet,
    double? ultraTablet,
  }) =>
      _baseTextStyle.merge(TextStyle(
        fontSize:
            Dimens.d12.responsive(tablet: tablet, ultraTablet: ultraTablet),
        fontWeight: FontWeight.w400,
        color: AppColors.current.primaryTextColor,
      ));

  static TextStyle s12w500Primary({
    double? tablet,
    double? ultraTablet,
  }) =>
      _baseTextStyle.merge(TextStyle(
        fontSize:
            Dimens.d12.responsive(tablet: tablet, ultraTablet: ultraTablet),
        fontWeight: FontWeight.w500,
        color: AppColors.current.primaryTextColor,
      ));

  static TextStyle s13w400Primary({
    double? tablet,
    double? ultraTablet,
  }) =>
      _baseTextStyle.merge(TextStyle(
        fontSize:
            Dimens.d13.responsive(tablet: tablet, ultraTablet: ultraTablet),
        fontWeight: FontWeight.w400,
        color: AppColors.current.primaryTextColor,
      ));

  static TextStyle s14w500Primary({
    double? tablet,
    double? ultraTablet,
  }) =>
      _baseTextStyle.merge(TextStyle(
        fontSize:
            Dimens.d14.responsive(tablet: tablet, ultraTablet: ultraTablet),
        fontWeight: FontWeight.w500,
        color: AppColors.current.primaryTextColor,
      ));

  static TextStyle s14w600Primary({
    double? tablet,
    double? ultraTablet,
  }) =>
      _baseTextStyle.merge(TextStyle(
        fontSize:
            Dimens.d14.responsive(tablet: tablet, ultraTablet: ultraTablet),
        fontWeight: FontWeight.w600,
        color: AppColors.current.primaryTextColor,
      ));

  static TextStyle s16w600Primary({
    double? tablet,
    double? ultraTablet,
  }) =>
      _baseTextStyle.merge(TextStyle(
        fontSize:
            Dimens.d16.responsive(tablet: tablet, ultraTablet: ultraTablet),
        fontWeight: FontWeight.w600,
        color: AppColors.current.primaryTextColor,
      ));

  static TextStyle s11w600Primary({
    double? tablet,
    double? ultraTablet,
  }) =>
      _baseTextStyle.merge(TextStyle(
        fontSize:
            Dimens.d11.responsive(tablet: tablet, ultraTablet: ultraTablet),
        fontWeight: FontWeight.w600,
        color: AppColors.current.primaryTextColor,
      ));

  static TextStyle s32w700Primary({
    double? tablet,
    double? ultraTablet,
  }) =>
      _baseTextStyle.merge(TextStyle(
        fontSize:
            Dimens.d32.responsive(tablet: tablet, ultraTablet: ultraTablet),
        fontWeight: FontWeight.w700,
        color: AppColors.current.primaryTextColor,
      ));
}
