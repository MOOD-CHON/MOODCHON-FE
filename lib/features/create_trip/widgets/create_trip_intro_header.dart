import 'package:flutter/material.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_typography.dart';

class CreateTripIntroHeader extends StatelessWidget {
  const CreateTripIntroHeader({
    super.key,
    required this.eyebrow,
    required this.title,
    required this.description,
  });

  final String eyebrow;
  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 316,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            eyebrow,
            style: AppTypography.captionLarge.copyWith(
              color: AppColors.main,
              height: 1,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTypography.titleInfo.copyWith(
              color: AppColors.textPrimary,
              height: 1,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            description,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTypography.descriptionLarge.copyWith(
              color: AppColors.textSecondary,
              height: 1,
            ),
          ),
        ],
      ),
    );
  }
}
