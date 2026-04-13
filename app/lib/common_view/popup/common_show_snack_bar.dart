import 'package:resources/resources.dart';

import '../../app.dart';

void showAppSnackBar(
  BuildContext context, {
  String? message,
  Color? backgroundColor,
  IconData? icon,
}) {
  final messenger = ScaffoldMessenger.of(context);
  messenger.hideCurrentSnackBar();

  messenger.showSnackBar(
    SnackBar(
      content: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            icon ?? Icons.check_circle,
            color: AppColors.current.whiteColor,
            size: Dimens.d22.responsive(),
          ),
          SizedBox(width: Dimens.d12.responsive()),
          Expanded(
            child: Text(
              message ?? 'Chức năng đang được phát triển',
              style:
                  AppTextStyles.titleTextDefault(color: AppColors.current.whiteColor),
            ),
          ),
        ],
      ),
      backgroundColor: backgroundColor ?? AppColors.current.primaryColor,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Dimens.d8.responsive()),
      ),
      duration: const Duration(seconds: 2),
    ),
  );
}
