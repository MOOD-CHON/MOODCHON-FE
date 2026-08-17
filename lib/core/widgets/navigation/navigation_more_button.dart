import 'package:flutter/material.dart';

import 'navigation_icon_button.dart';

class NavigationMoreButton extends StatelessWidget {
  const NavigationMoreButton({super.key, required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return NavigationIconButton(
      iconPath: 'assets/icons/navigation/more.svg',
      onTap: onTap,
    );
  }
}
