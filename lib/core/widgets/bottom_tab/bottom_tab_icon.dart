import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'bottom_tab_type.dart';

class BottomTabIcon extends StatelessWidget {
  const BottomTabIcon({
    super.key,
    required this.type,
    required this.isSelected,
  });

  final BottomTabType type;
  final bool isSelected;

  String get _iconPath {
    switch (type) {
      case BottomTabType.home:
        return isSelected
            ? 'assets/icons/bottom_tab/home_selected.svg'
            : 'assets/icons/bottom_tab/home_default.svg';

      case BottomTabType.explore:
        return isSelected
            ? 'assets/icons/bottom_tab/explore_selected.svg'
            : 'assets/icons/bottom_tab/explore_default.svg';

      case BottomTabType.saved:
        return isSelected
            ? 'assets/icons/bottom_tab/saved_selected.svg'
            : 'assets/icons/bottom_tab/saved_default.svg';

      case BottomTabType.my:
        return isSelected
            ? 'assets/icons/bottom_tab/my_selected.svg'
            : 'assets/icons/bottom_tab/my_default.svg';
    }
  }

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(_iconPath, width: 23, height: 23);
  }
}
