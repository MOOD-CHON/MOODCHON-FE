import 'package:flutter/material.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_typography.dart';

class ImageTag extends StatelessWidget {
  const ImageTag({super.key, required this.label});

  final String label;

  String get _formattedLabel {
    if (label.startsWith('#')) {
      return label;
    }

    return '#$label';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.black.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        _formattedLabel,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: AppTypography.captionExtraSmall.copyWith(
          color: AppColors.backgroundWhite,
        ),
      ),
    );
  }
}
