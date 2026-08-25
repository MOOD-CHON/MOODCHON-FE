import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

enum PlaceInfoSmallIconType { puppy, bbq, cook }

enum PlaceInfoMediumIconType {
  bike,
  sauna,
  sports,
  fire,
  parking,
  toilet,
  stroller,
  card,
  puppy,
  takeout,
}

enum PlaceInfoMediumBlackIconType { bbq, cook }

enum PlaceInfoIconColor { black, gray }

class PlaceInfoIcon extends StatelessWidget {
  const PlaceInfoIcon.small({super.key, required PlaceInfoSmallIconType type})
    : _smallType = type,
      _mediumType = null,
      _mediumBlackType = null,
      _color = null;

  const PlaceInfoIcon.medium({
    super.key,
    required PlaceInfoMediumIconType type,
    required PlaceInfoIconColor color,
  }) : _smallType = null,
       _mediumType = type,
       _mediumBlackType = null,
       _color = color;

  const PlaceInfoIcon.mediumBlack({
    super.key,
    required PlaceInfoMediumBlackIconType type,
  }) : _smallType = null,
       _mediumType = null,
       _mediumBlackType = type,
       _color = null;

  final PlaceInfoSmallIconType? _smallType;
  final PlaceInfoMediumIconType? _mediumType;
  final PlaceInfoMediumBlackIconType? _mediumBlackType;
  final PlaceInfoIconColor? _color;

  String get _assetPath {
    if (_smallType != null) {
      return switch (_smallType!) {
        PlaceInfoSmallIconType.puppy =>
          'assets/icons/place_info/puppy_small_gray.svg',
        PlaceInfoSmallIconType.bbq =>
          'assets/icons/place_info/bbq_small_gray.svg',
        PlaceInfoSmallIconType.cook =>
          'assets/icons/place_info/cook_small_gray.svg',
      };
    }

    if (_mediumType != null) {
      final suffix = switch (_color!) {
        PlaceInfoIconColor.black => 'black',
        PlaceInfoIconColor.gray => 'gray',
      };

      final name = switch (_mediumType!) {
        PlaceInfoMediumIconType.bike => 'bike',
        PlaceInfoMediumIconType.sauna => 'sauna',
        PlaceInfoMediumIconType.sports => 'sports',
        PlaceInfoMediumIconType.fire => 'fire',
        PlaceInfoMediumIconType.parking => 'parking',
        PlaceInfoMediumIconType.toilet => 'toilet',
        PlaceInfoMediumIconType.stroller => 'stroller',
        PlaceInfoMediumIconType.card => 'card',
        PlaceInfoMediumIconType.puppy => 'puppy',
        PlaceInfoMediumIconType.takeout => 'takeout',
      };

      return 'assets/icons/place_info/${name}_medium_$suffix.svg';
    }

    return switch (_mediumBlackType!) {
      PlaceInfoMediumBlackIconType.bbq =>
        'assets/icons/place_info/bbq_medium_black.svg',
      PlaceInfoMediumBlackIconType.cook =>
        'assets/icons/place_info/cook_medium_black.svg',
    };
  }

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(_assetPath);
  }
}
