import 'package:flutter/material.dart';

import 'bottom_tab_icon.dart';
import 'bottom_tab_label.dart';
import 'bottom_tab_type.dart';

class BottomTabIconItem extends StatelessWidget {
  const BottomTabIconItem({
    super.key,
    required this.type,
    required this.label,
    required this.isSelected,
  });

  final BottomTabType type;
  final String label;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          BottomTabIcon(type: type, isSelected: isSelected),
          const SizedBox(height: 5),
          BottomTabLabel(text: label, isSelected: isSelected),
        ],
      ),
    );
  }
}
