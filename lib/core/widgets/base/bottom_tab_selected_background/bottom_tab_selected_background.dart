import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';

class BottomTabSelectedBackground extends StatelessWidget {
  const BottomTabSelectedBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 87),
      child: Container(
        width: double.infinity,
        height: 54,
        decoration: BoxDecoration(
          color: AppColors.greenTab,
          borderRadius: BorderRadius.circular(50),
        ),
      ),
    );
  }
}
