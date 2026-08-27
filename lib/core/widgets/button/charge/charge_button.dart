import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_typography.dart';

class ChargeButton extends StatelessWidget {
  const ChargeButton({super.key, required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 325,
      height: 38,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: AppColors.buttonSecondary,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        text,
        style: AppTypography.tabLarge.copyWith(color: AppColors.buttonTertiary),
      ),
    );
  }
}
