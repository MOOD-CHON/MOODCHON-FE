import 'package:flutter/material.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_typography.dart';
import 'facilities_each.dart';
import 'facility_item.dart';

class FacilitiesAll extends StatelessWidget {
  const FacilitiesAll({super.key, required this.title, required this.items});

  final String title;
  final List<FacilityItem> items;

  @override
  Widget build(BuildContext context) {
    final visibleItems = items.where((item) => item.available != null).toList();

    if (visibleItems.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppTypography.titleMedium.copyWith(
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 61,
          runSpacing: 10,
          children: visibleItems
              .map(
                (item) => FacilitiesEach(
                  type: item.type,
                  existence: item.available!
                      ? FacilityExistence.exist
                      : FacilityExistence.nonexistence,
                ),
              )
              .toList(),
        ),
      ],
    );
  }
}
