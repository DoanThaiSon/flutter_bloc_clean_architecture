import 'package:shared/shared.dart';

import '../app.dart';

class Button extends StatelessWidget {
  final String? title;
  final VoidCallback? onPressed;
  final Color? bgColor;
  final Color? textColor;
  final EdgeInsets? margin;
  final bool? loading;
  final bool noPadding;
  final bool isShowBorder;
  final Widget? prefixIcon;
  final double radius;
  final Color loadingColor;
  final bool disabled;
  final double? textSize;

  const Button({
    required this.title,
    required this.onPressed,
    super.key,
    this.bgColor,
    this.textColor,
    this.loading,
    this.margin,
    this.noPadding = false,
    this.isShowBorder = false,
    this.prefixIcon,
    this.textSize,
    this.disabled = false,
    this.radius = RadiusConstants.medium,
    this.loadingColor = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: loading != null && loading == true
          ? null
          : disabled
              ? null
              : onPressed,
      style: ButtonStyle(
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        foregroundColor: WidgetStateProperty.all(Colors.transparent),
        overlayColor: WidgetStateProperty.all(Colors.transparent),
        elevation: WidgetStateProperty.all(0),
        backgroundColor: WidgetStateProperty.all(
          isShowBorder
              ? Colors.transparent
              : disabled == true
                  ? AppColors.current.borderDefaultColor
                  : bgColor ?? AppColors.current.primaryColor,
        ),
        padding: WidgetStateProperty.all(
          noPadding ? null : const EdgeInsets.all(14),
        ),
        shape: WidgetStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radius),
            side: isShowBorder
                ? const BorderSide(color: Colors.black, width: 1.0)
                : BorderSide.none,
          ),
        ),
      ),
      child: Center(
        child: loading != null && loading == true
            ? SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2.0,
                  color: loadingColor,
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  prefixIcon != null
                      ? Container(
                          margin: const EdgeInsets.only(right: 6),
                          child: prefixIcon,
                        )
                      : Container(),
                  Text(
                    title ?? 'Button',
                    style: TextStyle(
                      fontSize: textSize ?? 14.0,
                      color: disabled == true
                          ? AppColors.current.secondaryTextColor
                          : textColor ?? AppColors.current.whiteColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
