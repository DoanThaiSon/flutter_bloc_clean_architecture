import 'package:resources/resources.dart';

import '../app.dart';

class EmptyDataPage extends StatelessWidget {
  final String? title;
  final String? description;
  final String? icon;
  final Function? onTap;

  const EmptyDataPage({
    this.title,
    this.description,
    this.icon,
    this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final bool hasCustomIcon = icon != null && icon!.isNotEmpty;

    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: constraints.maxHeight,
            ),
            child: Center(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: Dimens.d8.responsive()),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    hasCustomIcon
                        ? Image.asset(
                      icon!,
                      fit: BoxFit.contain,
                    )
                        : Image.asset(
                      Assets.images.icons.box.path,
                      width: Dimens.d80.responsive(),
                      height: Dimens.d80.responsive(),
                      fit: BoxFit.contain,
                    ),
                    SizedBox(height: Dimens.d24.responsive()),
                    Text(
                      title ?? S.current.kNoDataTitle,
                      style: AppTextStyles.titleTextDefault(
                          fontSize: Dimens.d25.responsive(),
                          fontWeight: FontWeight.w700),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: Dimens.d12.responsive()),
                    Text(
                      description ?? S.current.kNoDataMessage,
                      style: AppTextStyles.titleTextDefault(
                        fontSize: Dimens.d16.responsive(),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
