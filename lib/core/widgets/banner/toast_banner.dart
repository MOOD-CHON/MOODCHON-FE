import 'package:flutter/material.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_shadows.dart';
import '../../../app/theme/app_typography.dart';

class ToastBanner extends StatelessWidget {
  const ToastBanner({super.key, required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 44,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: AppColors.backgroundWhite,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.main, width: 0.3),
        boxShadow: AppShadows.base,
      ),
      child: Text(
        message,
        textAlign: TextAlign.center,
        style: AppTypography.tabMedium.copyWith(
          color: AppColors.main.withValues(alpha: 0.8),
        ),
      ),
    );
  }
}
