
import '../app.dart';

class UIButton extends StatelessWidget {
  final double width;
  final double height;
  final double radius;
  final Function? onTap;
  final Gradient? gradient;
  final Color? color;
  final String? text;
  final Color textColor;
  final double textSize;
  final bool enable;
  final Border? border;
  final FontWeight fontWeight;
  final bool enableShadow;
  final BoxShadow? boxShadow;
  final IconData? iconData;
  final String? icon;

  const UIButton({
    super.key,
    this.width = double.maxFinite,
    this.height = Dimens.d55,
    this.radius = Dimens.d5,
    this.onTap,
    this.gradient,
    this.color,
    this.text,
    this.textColor = Colors.white,
    this.textSize = 16,
    this.enable = true,
    this.border,
    this.fontWeight = FontWeight.w500,
    this.enableShadow = true,
    this.boxShadow,
    this.iconData,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    Gradient? gr;
    Color? cl;
    if (enable) {
      cl = color;
      gr = gradient;
    } else {
      gr = null;
      cl = AppColors.neutral200;
    }

    return Container(
      width: width,
      height: height,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: cl,
        gradient: gr,
        borderRadius: BorderRadius.circular(radius),
        border: border,
        boxShadow: (enableShadow
            ? [
                boxShadow ??
                    const BoxShadow(
                      offset: Offset(2.0, 2.0),
                      blurRadius: 3.0,
                      color: Color.fromRGBO(0, 0, 0, 0.1),
                    )
              ]
            : null),
      ),
      child: TextButton(
        onPressed: () {
          if (enable && onTap != null) {
            onTap!();
          }
        },
        style: ButtonStyle(
            padding: WidgetStateProperty.all(const EdgeInsets.all(0.0)),
            overlayColor: WidgetStateProperty.all(enable
                ? const Color.fromRGBO(0, 0, 0, 0.1)
                : const Color.fromRGBO(0, 0, 0, 0.0)),
            textStyle: WidgetStateProperty.all(AppTextStyles.titleTextDefault(
              fontWeight: FontWeight.w700,
                fontSize: Dimens.d16.responsive(),
                color: AppColors.current.whiteColor)),
            shape: WidgetStateProperty.all(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(radius),
              ),
            ),
            backgroundColor: WidgetStateProperty.all(Colors.transparent)),
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              iconData != null
                  ? Icon(
                      iconData,
                      size: Dimens.d16.responsive(),
                      color: AppColors.current.orangeColor,
                    )
                  : const SizedBox(),
              iconData != null
                  ? const SizedBox(
                      width: Dimens.d4,
                    )
                  : const SizedBox(),
              Text(
                text ?? '',
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: AppTextStyles.titleTextDefault(
                  fontSize: textSize,
                  color: enable == true ? textColor : AppColors.neutral500,
                  fontWeight: enable == true ? fontWeight : FontWeight.w400,
                ),
              ),
              const SizedBox(
                width: Dimens.d4,
              ),
              icon != null
                  ? Image.asset(
                      icon ?? '',
                      width: Dimens.d16,
                      height: Dimens.d16,
                      color: AppColors.current.orangeColor,
                    )
                  : const SizedBox(),
            ],
          ),
        ),
      ),
    );
  }
}

class UIImageButton extends StatelessWidget {
  final Image? image;
  final double? width;
  final double? height;
  final GestureTapCallback? onTap;

  const UIImageButton({
    super.key,
    this.image,
    this.width,
    this.height,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: width,
        height: height,
        child: image,
      ),
    );
  }
}
