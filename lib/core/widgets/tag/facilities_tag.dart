import 'package:flutter/material.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_typography.dart';
import '../icon/place_info_icon.dart';

enum FacilitiesTagSize { large, medium, small }

class FacilitiesTag extends StatelessWidget {
  const FacilitiesTag.large({super.key, required this.label})
    : size = FacilitiesTagSize.large,
      iconType = null;

  const FacilitiesTag.medium({
    super.key,
    required this.label,
    required PlaceInfoSmallIconType this.iconType,
  }) : size = FacilitiesTagSize.medium;

  const FacilitiesTag.small({super.key, required this.label})
    : size = FacilitiesTagSize.small,
      iconType = null;

  final String label;
  final FacilitiesTagSize size;
  final PlaceInfoSmallIconType? iconType;

  EdgeInsets get _padding {
    switch (size) {
      case FacilitiesTagSize.large:
        return const EdgeInsets.symmetric(horizontal: 14, vertical: 8);
      case FacilitiesTagSize.medium:
        return const EdgeInsets.symmetric(horizontal: 6, vertical: 2);
      case FacilitiesTagSize.small:
        return const EdgeInsets.symmetric(horizontal: 6, vertical: 4);
    }
  }

  double get _radius {
    switch (size) {
      case FacilitiesTagSize.large:
        return 10;
      case FacilitiesTagSize.medium:
      case FacilitiesTagSize.small:
        return 6;
    }
  }

  double get _borderWidth {
    switch (size) {
      case FacilitiesTagSize.large:
        return 1.2;
      case FacilitiesTagSize.medium:
        return 1;
      case FacilitiesTagSize.small:
        return 0.6;
    }
  }

  TextStyle get _textStyle {
    switch (size) {
      case FacilitiesTagSize.large:
        return AppTypography.tabMedium;
      case FacilitiesTagSize.medium:
      case FacilitiesTagSize.small:
        return AppTypography.tabSmall;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: _padding,
      decoration: BoxDecoration(
        color: AppColors.backgroundWhite,
        borderRadius: BorderRadius.circular(_radius),
        border: Border.all(color: AppColors.linePrimary, width: _borderWidth),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (size == FacilitiesTagSize.medium) ...[
            PlaceInfoIcon.small(type: iconType!),
            const SizedBox(width: 2),
          ],
          Text(label, style: _textStyle.copyWith(color: AppColors.grayPrimary)),
        ],
      ),
    );
  }
}
