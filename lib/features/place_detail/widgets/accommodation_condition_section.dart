import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../core/widgets/icon/place_info_icon.dart';

class AccommodationConditionSection extends StatelessWidget {
  const AccommodationConditionSection({
    super.key,
    required this.petAllowed,
    required this.bbqAvailable,
    required this.cookingAvailable,
  });

  final bool petAllowed;
  final bool bbqAvailable;
  final bool cookingAvailable;

  @override
  Widget build(BuildContext context) {
    final items = <Widget>[
      if (petAllowed)
        const _AccommodationConditionItem(
          icon: PlaceInfoMediumIconType.puppy,
          label: '반려동물 동반',
        ),
      if (bbqAvailable)
        const _AccommodationConditionBlackOnlyItem(
          icon: PlaceInfoMediumBlackIconType.bbq,
          label: '바비큐 가능',
        ),
      if (cookingAvailable)
        const _AccommodationConditionBlackOnlyItem(
          icon: PlaceInfoMediumBlackIconType.cook,
          label: '취사 가능',
        ),
    ];

    if (items.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '숙소 조건',
          style: AppTypography.titleMedium.copyWith(
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 12),
        Wrap(spacing: 24, runSpacing: 8, children: items),
      ],
    );
  }
}

class _AccommodationConditionItem extends StatelessWidget {
  const _AccommodationConditionItem({required this.icon, required this.label});

  final PlaceInfoMediumIconType icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        PlaceInfoIcon.medium(type: icon, color: PlaceInfoIconColor.black),
        const SizedBox(width: 4),
        Text(
          label,
          style: AppTypography.tabMedium.copyWith(color: AppColors.textPrimary),
        ),
      ],
    );
  }
}

class _AccommodationConditionBlackOnlyItem extends StatelessWidget {
  const _AccommodationConditionBlackOnlyItem({
    required this.icon,
    required this.label,
  });

  final PlaceInfoMediumBlackIconType icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        PlaceInfoIcon.mediumBlack(type: icon),
        const SizedBox(width: 4),
        Text(
          label,
          style: AppTypography.tabMedium.copyWith(color: AppColors.textPrimary),
        ),
      ],
    );
  }
}
