import 'package:flutter/material.dart';

import 'navigation_icon_button.dart';

class NavigationBackButton extends StatelessWidget {
  const NavigationBackButton({super.key, required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return NavigationIconButton(
      iconPath: 'assets/icons/navigation/arrow_back.svg',
      onTap: onTap,
    );
  }
}
