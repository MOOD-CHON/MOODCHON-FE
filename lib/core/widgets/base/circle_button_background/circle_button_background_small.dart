import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_shadows.dart';

class CircleButtonBackgroundSmall extends StatelessWidget {
  const CircleButtonBackgroundSmall({super.key, this.child});

  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 19,
      height: 19,
      alignment: Alignment.center,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.backgroundWhite,
        boxShadow: AppShadows.base,
      ),
      child: child,
    );
  }
}
