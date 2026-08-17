import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_shadows.dart';

class CircleButtonBackgroundLarge extends StatelessWidget {
  const CircleButtonBackgroundLarge({super.key, this.child});

  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 45,
      height: 45,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: AppColors.backgroundWhite,
        shape: BoxShape.circle,
        boxShadow: AppShadows.base,
      ),
      child: child,
    );
  }
}
