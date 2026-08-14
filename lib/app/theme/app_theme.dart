import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'app_typography.dart';

abstract final class AppTheme {
  static ThemeData get light {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: AppColors.backgroundPrimary,
      fontFamily: 'Pretendard',
      colorScheme: const ColorScheme.light(
        primary: AppColors.main,
        surface: AppColors.backgroundPrimary,
        error: AppColors.statusError,
        onPrimary: AppColors.backgroundWhite,
        onSurface: AppColors.textPrimary,
        onError: AppColors.backgroundWhite,
      ),
      textTheme: const TextTheme(
        bodyLarge: AppTypography.bodyExtraLarge,
        bodyMedium: AppTypography.bodyMedium,
        bodySmall: AppTypography.bodySmall,
        titleLarge: AppTypography.titleLarge,
        titleMedium: AppTypography.titleMedium,
        titleSmall: AppTypography.titleSmall,
      ),
    );
  }
}
