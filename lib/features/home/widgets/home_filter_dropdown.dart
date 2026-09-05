import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_shadows.dart';
import '../../../app/theme/app_typography.dart';

enum HomeTripFilter { all, inProgress, completed }

extension HomeTripFilterLabel on HomeTripFilter {
  String get label {
    switch (this) {
      case HomeTripFilter.all:
        return '전체';
      case HomeTripFilter.inProgress:
        return '진행중';
      case HomeTripFilter.completed:
        return '완료';
    }
  }
}

class HomeFilterDropdown extends StatefulWidget {
  const HomeFilterDropdown({
    super.key,
    required this.selectedFilter,
    required this.onChanged,
  });

  final HomeTripFilter selectedFilter;
  final ValueChanged<HomeTripFilter> onChanged;

  @override
  State<HomeFilterDropdown> createState() => _HomeFilterDropdownState();
}

class _HomeFilterDropdownState extends State<HomeFilterDropdown> {
  static const double _buttonWidth = 67;
  static const double _buttonHeight = 26;
  static const double _menuWidth = 82;
  static const double _menuTopGap = 6;

  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;

  bool get _isOpen => _overlayEntry != null;

  @override
  void dispose() {
    _removeOverlay();
    super.dispose();
  }

  void _toggleOverlay() {
    if (_isOpen) {
      _removeOverlay();
    } else {
      _showOverlay();
    }
  }

  void _showOverlay() {
    final overlay = Overlay.of(context);

    _overlayEntry = OverlayEntry(
      builder: (context) {
        return Stack(
          children: [
            Positioned.fill(
              child: GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: _removeOverlay,
                child: const SizedBox.expand(),
              ),
            ),
            CompositedTransformFollower(
              link: _layerLink,
              showWhenUnlinked: false,
              offset: const Offset(
                -(_menuWidth - _buttonWidth),
                _buttonHeight + _menuTopGap,
              ),
              child: _FilterMenu(
                selectedFilter: widget.selectedFilter,
                onSelected: _selectFilter,
              ),
            ),
          ],
        );
      },
    );

    overlay.insert(_overlayEntry!);
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  void _selectFilter(HomeTripFilter filter) {
    _removeOverlay();
    widget.onChanged(filter);
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _layerLink,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: _toggleOverlay,
        child: Container(
          width: _buttonWidth,
          height: _buttonHeight,
          padding: const EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
            color: AppColors.backgroundWhite,
            borderRadius: BorderRadius.circular(20),
            boxShadow: AppShadows.card,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                widget.selectedFilter.label,
                style: AppTypography.bodyMedium.copyWith(
                  color: AppColors.textPrimary,
                  height: 1,
                ),
              ),
              const SizedBox(width: 3),
              SvgPicture.asset(
                'assets/icons/filter/dropdown_down_black.svg',
                width: 12,
                height: 12,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FilterMenu extends StatelessWidget {
  const _FilterMenu({required this.selectedFilter, required this.onSelected});

  final HomeTripFilter selectedFilter;
  final ValueChanged<HomeTripFilter> onSelected;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Container(
        width: _HomeFilterDropdownState._menuWidth,
        padding: const EdgeInsets.symmetric(vertical: 6),
        decoration: BoxDecoration(
          color: AppColors.backgroundWhite,
          borderRadius: BorderRadius.circular(14),
          boxShadow: AppShadows.card,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (final filter in HomeTripFilter.values)
              _FilterMenuItem(
                filter: filter,
                isSelected: filter == selectedFilter,
                onTap: () => onSelected(filter),
              ),
          ],
        ),
      ),
    );
  }
}

class _FilterMenuItem extends StatelessWidget {
  const _FilterMenuItem({
    required this.filter,
    required this.isSelected,
    required this.onTap,
  });

  final HomeTripFilter filter;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Container(
        height: 30,
        alignment: Alignment.center,
        color: isSelected ? AppColors.greenTab : AppColors.backgroundWhite,
        child: Text(
          filter.label,
          style: AppTypography.bodyMedium.copyWith(
            color: isSelected ? AppColors.main : AppColors.textPrimary,
          ),
        ),
      ),
    );
  }
}
