import 'package:flutter/material.dart';

import 'navigation_icon_button.dart';

class NavigationShareButton extends StatelessWidget {
  const NavigationShareButton({super.key, required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return NavigationIconButton(
      iconPath: 'assets/icons/navigation/share.svg',
      onTap: onTap,
    );
  }
}
