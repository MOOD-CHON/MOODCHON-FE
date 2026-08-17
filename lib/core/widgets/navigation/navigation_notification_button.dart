import 'package:flutter/material.dart';

import 'navigation_icon_button.dart';

class NavigationNotificationButton extends StatelessWidget {
  const NavigationNotificationButton({super.key, required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return NavigationIconButton(
      iconPath: 'assets/icons/navigation/notification.svg',
      semanticLabel: '알림',
      onTap: onTap,
    );
  }
}
