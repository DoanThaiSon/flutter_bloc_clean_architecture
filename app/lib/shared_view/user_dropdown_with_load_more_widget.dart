import 'package:domain/domain.dart';
import 'package:resources/resources.dart';
import '../app.dart';

class UserDropdownWithLoadMore extends StatefulWidget {
  final List<User> users;
  final bool isLoadingMore;
  final bool hasMore;
  final VoidCallback onLoadMore;
  final ValueChanged<String?> onChanged;
  final VoidCallback? onClear;
  final String? allText;
  final String? hintText;
  final String? selectedUserId;

  const UserDropdownWithLoadMore({
    required this.users,
    required this.isLoadingMore,
    required this.hasMore,
    required this.onLoadMore,
    required this.onChanged,
    this.allText,
    this.hintText,
    this.selectedUserId,
    this.onClear,
    super.key,
  });

  @override
  State<UserDropdownWithLoadMore> createState() =>
      _UserDropdownWithLoadMoreState();
}

class _UserDropdownWithLoadMoreState
    extends State<UserDropdownWithLoadMore> {
  final ScrollController _scrollController = ScrollController();
  OverlayEntry? _overlayEntry;
  final LayerLink _layerLink = LayerLink();
  bool _isOpen = false;
  double _savedScrollPosition = 0.0;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void didUpdateWidget(UserDropdownWithLoadMore oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (_isOpen) {
      if (_scrollController.hasClients) {
        _savedScrollPosition = _scrollController.position.pixels;
      }

      if (oldWidget.users.length != widget.users.length ||
          oldWidget.isLoadingMore != widget.isLoadingMore) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (_isOpen && _overlayEntry != null) {
            _overlayEntry!.markNeedsBuild();

            if (_scrollController.hasClients) {
              _scrollController.jumpTo(_savedScrollPosition);
            }
          }
        });
      }
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _removeOverlay();
    super.dispose();
  }

  void _onScroll() {
    if (!_isOpen) {
      return;
    }

    if (!_scrollController.hasClients) {
      return;
    }

    if (!widget.hasMore) {
      return;
    }

    if (widget.isLoadingMore) {
      return;
    }

    final position = _scrollController.position;
    if (position.pixels >= position.maxScrollExtent - 50) {
      widget.onLoadMore();
    }
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
    _isOpen = false;
  }

  void _toggleDropdown() {
    if (_isOpen) {
      _removeOverlay();
    } else {
      _showOverlay();
    }
  }

  void _showOverlay() {
    final overlay = Overlay.of(context);
    final renderBox = context.findRenderObject() as RenderBox;
    final size = renderBox.size;

    _overlayEntry = OverlayEntry(
      builder: (context) => GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: _removeOverlay,
        child: Stack(
          children: [
            Positioned(
              width: size.width,
              child: CompositedTransformFollower(
                link: _layerLink,
                showWhenUnlinked: false,
                offset: Offset(0, size.height + 5),
                child: Material(
                  elevation: 8,
                  borderRadius: BorderRadius.circular(Dimens.d8.responsive()),
                  child: Container(
                    constraints: const BoxConstraints(
                      maxHeight: 300,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.current.whiteColor,
                      borderRadius:
                          BorderRadius.circular(Dimens.d8.responsive()),
                      border: Border.all(color: AppColors.neutral400),
                    ),
                    child: _buildDropdownList(),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );

    overlay.insert(_overlayEntry!);
    _isOpen = true;
  }

  Widget _buildDropdownList() {
    if (widget.users.isEmpty) {
      return SizedBox(
        height: Dimens.d50.responsive(),
        child: Center(
          child: Text(
            S.current.kNoDataTitle,
            style: AppTextStyles.titleTextDefault(
              fontSize: Dimens.d14.responsive(),
              color: AppColors.neutral400,
            ),
          ),
        ),
      );
    }

    final hasAllOption = widget.allText != null;
    final allOptionCount = hasAllOption ? 1 : 0;

    return ListView.builder(
      controller: _scrollController,
      padding: EdgeInsets.zero,
      physics: const AlwaysScrollableScrollPhysics(),
      itemCount: widget.users.length +
          allOptionCount +
          (widget.isLoadingMore ? 1 : 0),
      itemBuilder: (context, index) {
        if (hasAllOption && index == 0) {
          return _buildItem(
            value: null,
            label: widget.allText!,
            isSelected: widget.selectedUserId == null,
          );
        }

        if (index == widget.users.length + allOptionCount) {
          return Padding(
            padding: EdgeInsets.all(Dimens.d16.responsive()),
            child: Center(
              child: SizedBox(
                width: Dimens.d20.responsive(),
                height: Dimens.d20.responsive(),
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    AppColors.current.primaryColor,
                  ),
                ),
              ),
            ),
          );
        }

        final vehicleIndex = hasAllOption ? index - 1 : index;
        final vehicle = widget.users[vehicleIndex];
        return _buildItem(
          value: vehicle.id,
          label: vehicle.name,
          isSelected: widget.selectedUserId == vehicle.id,
        );
      },
    );
  }

  Widget _buildItem({
    required String? value,
    required String label,
    required bool isSelected,
  }) {
    return InkWell(
      onTap: () {
        widget.onChanged(value);
        _removeOverlay();
      },
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: Dimens.d16.responsive(),
          vertical: Dimens.d12.responsive(),
        ),
        decoration: const BoxDecoration(
          color: AppColors.transparent,
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                label,
                style: AppTextStyles.titleTextDefault(
                    fontSize: Dimens.d15.responsive(),
                    color: AppColors.current.blackColor),
              ),
            ),
            if (isSelected)
              Icon(
                Icons.check,
                size: Dimens.d20.responsive(),
                color: AppColors.current.blackColor,
              ),
          ],
        ),
      ),
    );
  }

  String _getDisplayText() {
    if (widget.selectedUserId == null) {
      return widget.allText ?? widget.hintText ?? '';
    }
    final vehicle = widget.users.firstWhere(
      (v) => v.id == widget.selectedUserId,
      orElse: () => const User(),
    );
    return vehicle.name;
  }

  bool _isShowingHint() {
    return widget.selectedUserId == null &&
        widget.allText == null &&
        widget.hintText != null;
  }

  @override
  Widget build(BuildContext context) {
    final hasValue = widget.selectedUserId != null &&
                     widget.selectedUserId!.isNotEmpty;
    
    return CompositedTransformTarget(
      link: _layerLink,
      child: InkWell(
        onTap: _toggleDropdown,
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: Dimens.d12.responsive(),
            vertical: Dimens.d14.responsive(),
          ),
          decoration: BoxDecoration(
            color: AppColors.current.whiteColor,
            borderRadius: BorderRadius.circular(Dimens.d8.responsive()),
            border: Border.all(
              color: AppColors.neutral400,
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  _getDisplayText(),
                  style: AppTextStyles.titleTextDefault(
                    fontSize: Dimens.d15.responsive(),
                    color: _isShowingHint()
                        ? AppColors.neutral400
                        : AppColors.current.blackColor,
                  ),
                ),
              ),
              if (hasValue && widget.onClear != null)
                GestureDetector(
                  onTap: () {
                    widget.onClear?.call();
                    _removeOverlay();
                  },
                  child: Padding(
                    padding: EdgeInsets.only(right: Dimens.d8.responsive()),
                    child: Image.asset(
                      Assets.images.icons.delete.path,
                      width: Dimens.d20.responsive(),
                      height: Dimens.d20.responsive(),
                    ),
                  ),
                ),
              Icon(
                _isOpen ? Icons.arrow_drop_up : Icons.arrow_drop_down,
                color: AppColors.neutral600,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
