import 'package:auto_route/auto_route.dart';
import 'package:domain/domain.dart';
import 'package:flutter/cupertino.dart';

import '../../../app.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  const CustomBottomNavigationBar({
    required this.tabsRouter,
    required this.onTap,
    super.key,
  });

  final TabsRouter tabsRouter;
  final Function(int) onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.current.backgroundLayer1,
      ),
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: Dimens.d16.responsive()),
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.current.whiteColor,
              borderRadius: BorderRadius.circular(Dimens.d40.responsive()),
            ),
            padding: EdgeInsets.all(Dimens.d6.responsive()),
            child: IntrinsicHeight(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: BottomTab.values.asMap().entries.map((entry) {
                  final index = entry.key;
                  final tab = entry.value;
                  final isActive = tabsRouter.activeIndex == index;

                  return Expanded(
                    child: _BottomNavItem(
                      tab: tab,
                      isActive: isActive,
                      onTap: () => onTap(index),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _BottomNavItem extends StatefulWidget {
  const _BottomNavItem({
    required this.tab,
    required this.isActive,
    required this.onTap,
  });

  final BottomTab tab;
  final bool isActive;
  final VoidCallback onTap;

  @override
  State<_BottomNavItem> createState() => _BottomNavItemState();
}

class _BottomNavItemState extends State<_BottomNavItem>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _iconScaleAnimation;
  late Animation<double> _rotationAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );

    _scaleAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.0, end: 0.92)
            .chain(CurveTween(curve: Curves.easeInOut)),
        weight: 50,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 0.92, end: 1.0)
            .chain(CurveTween(curve: Curves.elasticOut)),
        weight: 50,
      ),
    ]).animate(_controller);

    _iconScaleAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.0, end: 1.3)
            .chain(CurveTween(curve: Curves.easeOut)),
        weight: 40,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.3, end: 1.0)
            .chain(CurveTween(curve: Curves.elasticOut)),
        weight: 60,
      ),
    ]).animate(_controller);

    _rotationAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: 0.0, end: 0.1)
            .chain(CurveTween(curve: Curves.easeInOut)),
        weight: 50,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 0.1, end: 0.0)
            .chain(CurveTween(curve: Curves.easeInOut)),
        weight: 50,
      ),
    ]).animate(_controller);

    _opacityAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.0, end: 0.7)
            .chain(CurveTween(curve: Curves.easeIn)),
        weight: 30,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 0.7, end: 1.0)
            .chain(CurveTween(curve: Curves.easeOut)),
        weight: 70,
      ),
    ]).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTap() {
    _controller.forward(from: 0.0);
    widget.onTap();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _handleTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: Opacity(
              opacity: _opacityAnimation.value,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                margin: const EdgeInsets.symmetric(horizontal: 2),
                padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
                decoration: BoxDecoration(
                  gradient: widget.isActive
                      ? LinearGradient(
                          colors: [
                            const Color(0xFFFF9A9E).withValues(alpha: 0.6),
                            const Color(0xFFFAD0C4).withValues(alpha: 0.6),
                            const Color(0xFFCBBAF6).withValues(alpha: 0.6),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        )
                      : null,
                  color: widget.isActive ? null : Colors.transparent,
                  borderRadius: BorderRadius.circular(Dimens.d40.responsive()),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Transform.scale(
                      scale: _iconScaleAnimation.value,
                      child: Transform.rotate(
                        angle: _rotationAnimation.value,
                        child: Icon(
                          widget.isActive ? _getActiveIconData() : _getIconData(),
                          color: widget.isActive
                              ? Colors.black.withValues(alpha: 0.8)
                              : Colors.black,
                          size: Dimens.d16.responsive(),
                        ),
                      ),
                    ),
                    Text(
                      widget.tab.title,
                      style: AppTextStyles.body2SemiBold(
                        color: AppColors.current.blackColor,
                      ).copyWith(
                        fontSize: Dimens.d12.responsive(),
                        fontWeight:
                            widget.isActive ? FontWeight.bold : FontWeight.w500,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  IconData _getIconData() {
    switch (widget.tab) {
      case BottomTab.homeAttendance:
        return CupertinoIcons.home;
      case BottomTab.historyAttendance:
        return CupertinoIcons.clock;
      case BottomTab.profileAttendance:
        return CupertinoIcons.person;
    }
  }

  IconData _getActiveIconData() {
    switch (widget.tab) {
      case BottomTab.homeAttendance:
        return CupertinoIcons.house_fill;
      case BottomTab.historyAttendance:
        return CupertinoIcons.clock;
      case BottomTab.profileAttendance:
        return CupertinoIcons.person_fill;
    }
  }
}
