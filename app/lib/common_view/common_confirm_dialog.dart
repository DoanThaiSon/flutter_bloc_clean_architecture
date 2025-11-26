import 'package:dartx/dartx.dart';
import 'package:resources/resources.dart';

import '../../app.dart';
import 'ui_button.dart';

class CustomConfirmDialog extends StatelessWidget {
  const CustomConfirmDialog({
    super.key,
    this.onCancel,
    this.onConfirm,
    this.icon,
    this.title,
    this.description,
    this.cancelText,
    this.confirmText,
    this.textStyle,
  });

  final Widget? icon;
  final String? title;
  final String? description;
  final String? cancelText;
  final String? confirmText;
  final void Function()? onCancel;
  final void Function()? onConfirm;
  final TextStyle? textStyle;

  @override
  Widget build(BuildContext context) {
    final children = <Widget>[];
    final button = <Widget>[];

    if (icon != null) {
      children.add(icon!);
      children.add(_sizedBoxDivider);
    }

    if (title.isNotNullOrEmpty) {
      children.add(
        Text(
          title ?? '',
          style: AppTextStyles.titleTextDefault(fontSize: Dimens.d18.responsive(), fontWeight: FontWeight.w500),
          textAlign: TextAlign.start,
        ),
      );
      children.add(_sizedBoxDivider);
    }

    if (description.isNotNullOrEmpty) {
      children.add(
        Text(
          description ?? '',
          style: textStyle??AppTextStyles.titleTextDefault(fontWeight: FontWeight.w500,fontSize: Dimens.d16.responsive()),
          textAlign: TextAlign.center,
        ),
      );
      children.add(_sizedBoxDivider);
    }

    if (onCancel != null) {
      button.add(
        Expanded(
          child: UIButton(
            radius: Dimens.d8.responsive(),
            enableShadow: false,
            height: Dimens.d44.responsive(),
            border: Border.all(color: AppColors.current.orangeColor, width: Dimens.d1.responsive()),
            onTap: onCancel,
            text: cancelText ?? S.current.cancel,
            textColor: AppColors.current.orangeColor,
          ),
        ),
      );
    }

    if (onCancel != null && onConfirm != null) {
      button.add(_sizedBoxDivider);
    }

    if (onConfirm != null) {
      button.add(
        Expanded(
          child: UIButton(
            height: Dimens.d44.responsive(),
            radius: Dimens.d8.responsive(),
            color: AppColors.current.textLinkColor,
            enableShadow: false,
            onTap: onConfirm,
            text: confirmText ?? S.current.confirm,
            textColor: AppColors.current.whiteColor,
          ),
        ),
      );
    }

    return Container(
      height: Dimens.d214.responsive(),
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(horizontal: Dimens.d18),
      child: Material(
        color: AppColors.current.whiteColor,
        surfaceTintColor: AppColors.current.whiteColor,
        borderRadius: BorderRadius.circular(Dimens.d24.responsive()),
        child: Padding(
          padding: const EdgeInsets.all(Dimens.d20),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                ...children,
                Row(
                  children: button,
                ),
              ]),
        ),
      ),
    );
  }

  SizedBox get _sizedBoxDivider => const SizedBox(
        height: Dimens.d16,
        width: Dimens.d16,
      );
}
