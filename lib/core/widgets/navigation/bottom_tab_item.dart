import 'package:flutter/material.dart';

import '../bottom_tab/bottom_tab_icon_item.dart';
import '../bottom_tab/bottom_tab_type.dart';

class NavigationBottomTabItem extends StatelessWidget {
  const NavigationBottomTabItem({
    super.key,
    required this.type,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final BottomTabType type;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      selected: isSelected,
      label: label,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: SizedBox(
          width: double.infinity,
          height: 54,
          child: Center(
            child: ExcludeSemantics(
              child: BottomTabIconItem(
                type: type,
                label: label,
                isSelected: isSelected,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
