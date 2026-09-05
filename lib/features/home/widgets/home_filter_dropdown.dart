import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_shadows.dart';
import '../../../app/theme/app_typography.dart';

enum HomeTripFilter { all, inProgress, completed }

extension HomeTripFilterLabel on HomeTripFilter {
  String get label {
    switch (this) {
      case HomeTripFilter.all:
        return '전체';
      case HomeTripFilter.inProgress:
        return '진행중';
      case HomeTripFilter.completed:
        return '완료';
    }
  }
}

class HomeFilterDropdown extends StatelessWidget {
  const HomeFilterDropdown({
    super.key,
    required this.selectedFilter,
    required this.onChanged,
  });

  final HomeTripFilter selectedFilter;
  final ValueChanged<HomeTripFilter> onChanged;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<HomeTripFilter>(
      initialValue: selectedFilter,
      color: AppColors.backgroundWhite,
      elevation: 0,
      shadowColor: Colors.transparent,
      padding: EdgeInsets.zero,
      offset: const Offset(0, 32),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      onSelected: onChanged,
      itemBuilder: (context) {
        return [
          for (final filter in HomeTripFilter.values)
            PopupMenuItem<HomeTripFilter>(
              value: filter,
              child: Text(
                filter.label,
                style: AppTypography.bodyMedium.copyWith(
                  color: AppColors.textPrimary,
                ),
              ),
            ),
        ];
      },
      child: Container(
        height: 26,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: AppColors.backgroundWhite,
          borderRadius: BorderRadius.circular(20),
          boxShadow: AppShadows.card,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              selectedFilter.label,
              style: AppTypography.bodyMedium.copyWith(
                color: AppColors.textPrimary,
                height: 1,
              ),
            ),
            const SizedBox(width: 3),
            SvgPicture.asset(
              'assets/icons/filter/dropdown_down_black.svg',
              width: 12,
              height: 12,
            ),
          ],
        ),
      ),
    );
  }
}
