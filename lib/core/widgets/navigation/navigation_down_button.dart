import 'package:flutter/material.dart';

import 'navigation_icon_button.dart';

class NavigationDownButton extends StatelessWidget {
  const NavigationDownButton({super.key, required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return NavigationIconButton(
      iconPath: 'assets/icons/navigation/down.svg',
      onTap: onTap,
    );
  }
}
