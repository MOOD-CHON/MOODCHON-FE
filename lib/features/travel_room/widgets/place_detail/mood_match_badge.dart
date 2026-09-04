import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_typography.dart';

class MoodMatchBadge extends StatelessWidget {
  const MoodMatchBadge({super.key, required this.matchRate});

  final int matchRate;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        color: AppColors.greenTab,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            '무드 적합도',
            style: AppTypography.bodyExtraLarge.copyWith(
              color: AppColors.textSecondary,
            ),
          ),

          const SizedBox(width: 4),

          Text(
            '$matchRate%',
            style: AppTypography.bodyPlace.copyWith(color: AppColors.main),
          ),
        ],
      ),
    );
  }
}
