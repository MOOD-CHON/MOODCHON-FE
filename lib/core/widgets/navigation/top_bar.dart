import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_typography.dart';
import '../menu/more/more_menu.dart';
import '../search/search_bar.dart';
import 'navigation_back_button.dart';
import 'navigation_more_button.dart';
import 'navigation_notification_button.dart';
import 'navigation_trash_button.dart';

enum TopBarType { logo, search, title, more, back, date, backSearch, delete }

class TopBar extends StatefulWidget {
  const TopBar({
    super.key,
    required this.type,
    this.title,
    this.date,
    this.roomName,
    this.searchPlaceholder,
    this.onBack,
    this.onNotification,
    this.onSearchChanged,
    this.onSearchSubmitted,
    this.onDelete,
    this.onEditInfo,
    this.onMemberInfo,
    this.onInvite,
    this.onLeave,
  });

  final TopBarType type;

  final String? title;
  final String? date;
  final String? roomName;
  final String? searchPlaceholder;

  final VoidCallback? onBack;
  final VoidCallback? onNotification;
  final ValueChanged<String>? onSearchChanged;
  final ValueChanged<String>? onSearchSubmitted;
  final VoidCallback? onDelete;

  final VoidCallback? onEditInfo;
  final VoidCallback? onMemberInfo;
  final VoidCallback? onInvite;
  final VoidCallback? onLeave;

  @override
  State<TopBar> createState() => _TopBarState();
}

class _TopBarState extends State<TopBar> {
  final GlobalKey _moreButtonKey = GlobalKey();

  OverlayEntry? _moreMenuOverlay;

  void _showMoreMenu() {
    _hideMoreMenu();

    final RenderBox? buttonRenderBox =
        _moreButtonKey.currentContext?.findRenderObject() as RenderBox?;

    if (buttonRenderBox == null) {
      return;
    }

    final Offset buttonPosition = buttonRenderBox.localToGlobal(Offset.zero);

    final Size buttonSize = buttonRenderBox.size;

    const double menuWidth = 152;

    final double menuLeft = buttonPosition.dx + buttonSize.width - menuWidth;

    final double menuTop = buttonPosition.dy;

    _moreMenuOverlay = OverlayEntry(
      builder: (context) {
        return Stack(
          children: [
            Positioned.fill(
              child: GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: _hideMoreMenu,
              ),
            ),
            Positioned(
              left: menuLeft,
              top: menuTop,
              child: Material(
                color: Colors.transparent,
                child: MoreMenu(
                  roomName: widget.roomName ?? '',
                  onEditInfo: () {
                    _hideMoreMenu();
                    widget.onEditInfo?.call();
                  },
                  onMemberInfo: () {
                    _hideMoreMenu();
                    widget.onMemberInfo?.call();
                  },
                  onInvite: () {
                    _hideMoreMenu();
                    widget.onInvite?.call();
                  },
                  onLeave: () {
                    _hideMoreMenu();
                    widget.onLeave?.call();
                  },
                ),
              ),
            ),
          ],
        );
      },
    );

    Overlay.of(context).insert(_moreMenuOverlay!);
  }

  void _hideMoreMenu() {
    _moreMenuOverlay?.remove();
    _moreMenuOverlay = null;
  }

  @override
  void dispose() {
    _hideMoreMenu();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.type == TopBarType.search) {
      return _buildSearchTopBar();
    }

    if (widget.type == TopBarType.backSearch) {
      return _buildBackSearchTopBar();
    }

    return SizedBox(
      width: double.infinity,
      height: 56,
      child: Stack(children: [_buildLeft(), _buildCenter(), _buildRight()]),
    );
  }

  Widget _buildSearchTopBar() {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 6, 16, 5),
        child: Row(
          children: [
            Expanded(
              child: MoodChonSearchBar(
                placeholder: widget.searchPlaceholder ?? '',
                onChanged: widget.onSearchChanged,
                onSubmitted: widget.onSearchSubmitted,
              ),
            ),
            const SizedBox(width: 16),
            NavigationNotificationButton(onTap: widget.onNotification ?? () {}),
          ],
        ),
      ),
    );
  }

  Widget _buildBackSearchTopBar() {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 6, 16, 5),
        child: Row(
          children: [
            NavigationBackButton(onTap: widget.onBack ?? () {}),
            const SizedBox(width: 16),
            Expanded(
              child: MoodChonSearchBar(
                placeholder: widget.searchPlaceholder ?? '',
                onChanged: widget.onSearchChanged,
                onSubmitted: widget.onSearchSubmitted,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLeft() {
    switch (widget.type) {
      case TopBarType.logo:
        return Positioned(
          left: 16,
          top: 9,
          child: SvgPicture.asset(
            'assets/icons/logo/moodchon_wordmark_small.svg',
            width: 55,
            height: 39,
          ),
        );

      case TopBarType.title:
      case TopBarType.more:
      case TopBarType.back:
      case TopBarType.date:
      case TopBarType.delete:
        return Positioned(
          left: 16,
          top: 6,
          child: NavigationBackButton(onTap: widget.onBack ?? () {}),
        );

      case TopBarType.search:
      case TopBarType.backSearch:
        return const SizedBox.shrink();
    }
  }

  Widget _buildCenter() {
    switch (widget.type) {
      case TopBarType.title:
      case TopBarType.more:
      case TopBarType.delete:
        return Positioned.fill(
          child: IgnorePointer(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 77),
                child: Text(
                  widget.title ?? '',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: AppTypography.titleNav.copyWith(
                    color: AppColors.black,
                  ),
                ),
              ),
            ),
          ),
        );

      case TopBarType.date:
        return Positioned.fill(
          child: IgnorePointer(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 77),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      widget.title ?? '',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                      style: AppTypography.titleNav.copyWith(
                        color: AppColors.black,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      widget.date ?? '',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                      style: AppTypography.tabSmall.copyWith(
                        color: AppColors.grayPrimary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );

      case TopBarType.logo:
      case TopBarType.search:
      case TopBarType.back:
      case TopBarType.backSearch:
        return const SizedBox.shrink();
    }
  }

  Widget _buildRight() {
    switch (widget.type) {
      case TopBarType.logo:
        return Positioned(
          right: 16,
          top: 6,
          child: NavigationNotificationButton(
            onTap: widget.onNotification ?? () {},
          ),
        );

      case TopBarType.more:
      case TopBarType.date:
        return Positioned(
          right: 16,
          top: 6,
          child: KeyedSubtree(
            key: _moreButtonKey,
            child: NavigationMoreButton(onTap: _showMoreMenu),
          ),
        );

      case TopBarType.delete:
        return Positioned(
          right: 16,
          top: 6,
          child: NavigationTrashButton(onTap: widget.onDelete ?? () {}),
        );

      case TopBarType.title:
      case TopBarType.back:
      case TopBarType.search:
      case TopBarType.backSearch:
        return const SizedBox.shrink();
    }
  }
}
