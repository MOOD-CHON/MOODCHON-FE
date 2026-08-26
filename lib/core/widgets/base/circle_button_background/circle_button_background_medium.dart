import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_shadows.dart';
import 'circle_button_background_type.dart';

class CircleButtonBackgroundMedium extends StatelessWidget {
  const CircleButtonBackgroundMedium({
    super.key,
    required this.type,
    required this.child,
  });

  final CircleButtonBackgroundType type;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final backgroundColor = switch (type) {
      CircleButtonBackgroundType.ivory => AppColors.backgroundPrimary,
      CircleButtonBackgroundType.white => AppColors.backgroundWhite,
    };

    return Container(
      width: 29,
      height: 29,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: backgroundColor,
        boxShadow: AppShadows.base,
      ),
      child: child,
    );
  }
}
