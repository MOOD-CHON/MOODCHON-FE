import 'package:flutter/material.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_typography.dart';

class BottomTabLabel extends StatelessWidget {
  const BottomTabLabel({
    super.key,
    required this.text,
    required this.isSelected,
  });

  final String text;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      maxLines: 1,
      textAlign: TextAlign.center,
      style: AppTypography.tabSmall.copyWith(
        color: isSelected ? AppColors.main : AppColors.black,
      ),
    );
  }
}
