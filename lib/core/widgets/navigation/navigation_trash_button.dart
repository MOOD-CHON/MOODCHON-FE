import 'package:flutter/material.dart';

import 'navigation_icon_button.dart';

class NavigationTrashButton extends StatelessWidget {
  const NavigationTrashButton({super.key, required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return NavigationIconButton(
      iconPath: 'assets/icons/navigation/trash_medium.svg',
      semanticLabel: '삭제',
      onTap: onTap,
    );
  }
}
