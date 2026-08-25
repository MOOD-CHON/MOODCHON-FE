import '../../../core/widgets/tag/map_tag.dart';

enum TourismPlaceType { attraction, culturalFacility, leisureSports }

extension TourismPlaceTypeX on TourismPlaceType {
  String get label {
    switch (this) {
      case TourismPlaceType.attraction:
        return '관광지';

      case TourismPlaceType.culturalFacility:
        return '문화시설';

      case TourismPlaceType.leisureSports:
        return '레포츠';
    }
  }

  MapTagColor get mapTagColor {
    switch (this) {
      case TourismPlaceType.attraction:
      case TourismPlaceType.culturalFacility:
        return MapTagColor.blue;

      case TourismPlaceType.leisureSports:
        return MapTagColor.red;
    }
  }
}
