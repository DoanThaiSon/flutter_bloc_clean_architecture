import 'package:domain/domain.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../app.dart';


class CommonAppBar extends StatelessWidget implements PreferredSizeWidget {
  CommonAppBar({
    super.key,
    this.text,
    this.onLeadingPressed,
    this.onTitlePressed,
    this.leadingIcon = LeadingIcon.newBack,
    this.titleType = AppBarTitle.text,
    this.centerTitle = true,
    this.elevation,
    this.actions,
    this.height,
    this.automaticallyImplyLeading = true,
    this.flexibleSpace,
    this.bottom,
    this.shadowColor,
    this.shape,
    this.backgroundColor,
    this.foregroundColor,
    this.iconTheme,
    this.actionsIconTheme,
    this.primary = true,
    this.excludeHeaderSemantics = false,
    this.titleSpacing = 0.0,
    this.toolbarOpacity = 1.0,
    this.bottomOpacity = 1.0,
    this.leadingWidth,
    this.titleTextStyle,
    this.systemOverlayStyle,
    this.leadingIconColor,
    this.padding,
    this.icon,
  })  : preferredSize = Size.fromHeight(
    height ?? Dimens.d56.responsive(),
  );

  final String? text;
  final VoidCallback? onLeadingPressed;
  final VoidCallback? onTitlePressed;
  final LeadingIcon leadingIcon;
  final AppBarTitle titleType;
  final bool centerTitle;
  final double? elevation;
  final List<Widget>? actions;
  final double? height;
  final bool automaticallyImplyLeading;
  final Widget? flexibleSpace;
  final PreferredSizeWidget? bottom;
  final Color? shadowColor;
  final ShapeBorder? shape;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final IconThemeData? iconTheme;
  final IconThemeData? actionsIconTheme;
  final bool primary;
  final bool excludeHeaderSemantics;
  final double titleSpacing;
  final double toolbarOpacity;
  final double bottomOpacity;
  final double? leadingWidth;
  final TextStyle? titleTextStyle;
  final Color? leadingIconColor;
  final SystemUiOverlayStyle? systemOverlayStyle;
  final EdgeInsetsGeometry? padding;
  final String? icon;

  @override
  final Size preferredSize;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      forceMaterialTransparency: true,
      scrolledUnderElevation: Dimens.d0,
      toolbarHeight: preferredSize.height,
      automaticallyImplyLeading: automaticallyImplyLeading,
      flexibleSpace: flexibleSpace,
      bottom: bottom,
      shadowColor: shadowColor,
      shape: shape,
      backgroundColor: backgroundColor ?? AppColors.current.whiteColor,
      foregroundColor: foregroundColor,
      iconTheme: iconTheme,
      actionsIconTheme: actionsIconTheme,
      primary: primary,
      excludeHeaderSemantics: excludeHeaderSemantics,
      titleSpacing: titleSpacing,
      toolbarOpacity: toolbarOpacity,
      bottomOpacity: bottomOpacity,
      leadingWidth: leadingWidth,
      systemOverlayStyle: systemOverlayStyle,
      leading: leadingIcon == LeadingIcon.hambuger || leadingIcon == LeadingIcon.none
          ? null
          : GestureDetector(
          onTap: onLeadingPressed ?? () => onPop(context),
          child: Container(
            width: Dimens.d32,
            height: Dimens.d32,
            color: Colors.transparent,
            child: (leadingIcon == LeadingIcon.newBack)
                ? _buildNewBackIcon()
                : _buildIcon(
              leadingIcon == LeadingIcon.close ? Assets.images.svgs.iconClose : Assets.images.svgs.icArrowLeft,
            ),
          )),
      centerTitle: centerTitle,
      title:  Text(
        text ?? '',
        style: titleTextStyle ?? AppTextStyles.s24w500Primary(),
        overflow: TextOverflow.ellipsis,
        softWrap: true,
        maxLines: null,
      ),
      actions: actions,
      elevation: elevation ?? 0,
    );
  }

  Widget _buildIcon(SvgGenImage svg) {
    return svg.svg(
      colorFilter: ColorFilter.mode(leadingIconColor ?? AppColors.current.primaryColor, BlendMode.src),
      width: Dimens.d10.responsive(),
      height: Dimens.d18.responsive(),
      fit: BoxFit.contain,
    );
  }

  Widget _buildNewBackIcon() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
            width: Dimens.d20, height: Dimens.d20, color: Colors.transparent, child: Assets.images.svgs.iconArrowBack.svg())
      ],
    );
  }
}

void onPop(BuildContext context) {
  if (context.read<AppNavigator>().canPopSelfOrChildren) {
    context.read<AppNavigator>().pop();
  } else {
    context.read<AppNavigator>().push(const AppRouteInfo.main());
  }
}

enum LeadingIcon { back, close, hambuger, none, newBack }

enum AppBarTitle {
  logo,
  text,
  none,
}
