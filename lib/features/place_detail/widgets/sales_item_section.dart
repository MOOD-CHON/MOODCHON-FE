import 'package:flutter/material.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_typography.dart';

class SalesItemSection extends StatelessWidget {
  const SalesItemSection({super.key, required this.salesItem});

  final String? salesItem;

  bool get _hasValue => salesItem != null && salesItem!.trim().isNotEmpty;

  @override
  Widget build(BuildContext context) {
    if (!_hasValue) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '판매 품목',
          style: AppTypography.titleMedium.copyWith(
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          salesItem!.trim(),
          style: AppTypography.tabMedium.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }
}
