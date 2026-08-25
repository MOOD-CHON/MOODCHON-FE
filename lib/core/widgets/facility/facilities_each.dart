import 'package:flutter/material.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_typography.dart';
import '../icon/place_info_icon.dart';
import 'facility_type.dart';

enum FacilityExistence { exist, nonexistence }

class FacilitiesEach extends StatelessWidget {
  const FacilitiesEach({
    super.key,
    required this.type,
    required this.existence,
  });

  final FacilityType type;
  final FacilityExistence existence;

  bool get _isExist => existence == FacilityExistence.exist;

  PlaceInfoMediumIconType get _iconType {
    switch (type) {
      case FacilityType.bike:
        return PlaceInfoMediumIconType.bike;
      case FacilityType.fire:
        return PlaceInfoMediumIconType.fire;
      case FacilityType.parking:
        return PlaceInfoMediumIconType.parking;
      case FacilityType.stroller:
        return PlaceInfoMediumIconType.stroller;
      case FacilityType.card:
        return PlaceInfoMediumIconType.card;
      case FacilityType.puppy:
        return PlaceInfoMediumIconType.puppy;
      case FacilityType.takeout:
        return PlaceInfoMediumIconType.takeout;
      case FacilityType.sauna:
        return PlaceInfoMediumIconType.sauna;
      case FacilityType.sports:
        return PlaceInfoMediumIconType.sports;
      case FacilityType.toilet:
        return PlaceInfoMediumIconType.toilet;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        PlaceInfoIcon.medium(
          type: _iconType,
          color: _isExist ? PlaceInfoIconColor.black : PlaceInfoIconColor.gray,
        ),
        const SizedBox(width: 8),
        SizedBox(
          width: 100,
          child: Text(
            _isExist ? type.existLabel : type.nonexistenceLabel,
            style: AppTypography.tabMedium.copyWith(
              color: _isExist ? AppColors.textPrimary : AppColors.grayPrimary,
            ),
          ),
        ),
      ],
    );
  }
}
