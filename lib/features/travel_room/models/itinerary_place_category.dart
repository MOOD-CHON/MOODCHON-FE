import '../../../core/widgets/tag/map_tag.dart';

/// 9.3.1-2 "장소 없이 추가하기"에서 고르는 활동 유형.
/// 서버 `PlaceCategory` enum과 이름을 맞춰야 합니다.
enum ItineraryPlaceCategory {
  touristSpot,
  culturalFacility,
  shopping,
  leisureSports,
  event,
  performance,
  festival,
  restaurant,
  accommodation,
}

extension ItineraryPlaceCategoryX on ItineraryPlaceCategory {
  String get apiValue {
    switch (this) {
      case ItineraryPlaceCategory.touristSpot:
        return 'TOURIST_SPOT';
      case ItineraryPlaceCategory.culturalFacility:
        return 'CULTURAL_FACILITY';
      case ItineraryPlaceCategory.shopping:
        return 'SHOPPING';
      case ItineraryPlaceCategory.leisureSports:
        return 'LEISURE_SPORTS';
      case ItineraryPlaceCategory.event:
        return 'EVENT';
      case ItineraryPlaceCategory.performance:
        return 'PERFORMANCE';
      case ItineraryPlaceCategory.festival:
        return 'FESTIVAL';
      case ItineraryPlaceCategory.restaurant:
        return 'RESTAURANT';
      case ItineraryPlaceCategory.accommodation:
        return 'ACCOMMODATION';
    }
  }

  String get label {
    switch (this) {
      case ItineraryPlaceCategory.touristSpot:
        return '관광지';
      case ItineraryPlaceCategory.culturalFacility:
        return '문화시설';
      case ItineraryPlaceCategory.shopping:
        return '쇼핑';
      case ItineraryPlaceCategory.leisureSports:
        return '레포츠';
      case ItineraryPlaceCategory.event:
        return '행사';
      case ItineraryPlaceCategory.performance:
        return '공연';
      case ItineraryPlaceCategory.festival:
        return '축제';
      case ItineraryPlaceCategory.restaurant:
        return '음식점';
      case ItineraryPlaceCategory.accommodation:
        return '숙박';
    }
  }

  MapTagColor get tagColor {
    switch (this) {
      case ItineraryPlaceCategory.touristSpot:
      case ItineraryPlaceCategory.culturalFacility:
      case ItineraryPlaceCategory.shopping:
        return MapTagColor.blue;
      case ItineraryPlaceCategory.leisureSports:
      case ItineraryPlaceCategory.event:
      case ItineraryPlaceCategory.performance:
      case ItineraryPlaceCategory.festival:
        return MapTagColor.red;
      case ItineraryPlaceCategory.restaurant:
        return MapTagColor.purple;
      case ItineraryPlaceCategory.accommodation:
        return MapTagColor.green;
    }
  }
}

/// 문자열 tagColor(BLUE/RED/PURPLE/GREEN)를 [MapTagColor]로 변환합니다.
MapTagColor parseMapTagColor(String? value) {
  switch (value) {
    case 'BLUE':
      return MapTagColor.blue;
    case 'RED':
      return MapTagColor.red;
    case 'PURPLE':
      return MapTagColor.purple;
    case 'GREEN':
    default:
      return MapTagColor.green;
  }
}
