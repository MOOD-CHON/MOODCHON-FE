import '../../../core/widgets/map/map_pin.dart';
import '../../../core/widgets/tag/map_tag.dart';

enum TravelRoomPlanCategory {
  tourism,
  event,
  restaurant,
  shopping,
  accommodation,
  activity,
}

extension TravelRoomPlanCategoryX on TravelRoomPlanCategory {
  String get label {
    switch (this) {
      case TravelRoomPlanCategory.tourism:
        return '관광지';

      case TravelRoomPlanCategory.event:
        return '행사';

      case TravelRoomPlanCategory.restaurant:
        return '음식점';

      case TravelRoomPlanCategory.shopping:
        return '쇼핑';

      case TravelRoomPlanCategory.accommodation:
        return '숙소';

      case TravelRoomPlanCategory.activity:
        return '';
    }
  }

  MapTagColor get mapTagColor {
    switch (this) {
      case TravelRoomPlanCategory.tourism:
        return MapTagColor.blue;

      case TravelRoomPlanCategory.event:
        return MapTagColor.red;

      case TravelRoomPlanCategory.restaurant:
        return MapTagColor.purple;

      case TravelRoomPlanCategory.shopping:
      case TravelRoomPlanCategory.accommodation:
      case TravelRoomPlanCategory.activity:
        return MapTagColor.green;
    }
  }

  MapPinColor get mapPinColor {
    switch (this) {
      case TravelRoomPlanCategory.tourism:
        return MapPinColor.blue;

      case TravelRoomPlanCategory.event:
        return MapPinColor.red;

      case TravelRoomPlanCategory.restaurant:
        return MapPinColor.purple;

      case TravelRoomPlanCategory.shopping:
      case TravelRoomPlanCategory.accommodation:
      case TravelRoomPlanCategory.activity:
        return MapPinColor.green;
    }
  }
}

// 백엔드 PlaceCategory(9종)를 화면의 6종 카테고리로 좁혀 매핑한다.
// 문화시설/레포츠처럼 대응 항목이 없는 카테고리는 관광지로 합친다.
TravelRoomPlanCategory travelRoomPlanCategoryFromPlaceCategory(String placeCategory) {
  switch (placeCategory) {
    case 'RESTAURANT':
      return TravelRoomPlanCategory.restaurant;
    case 'SHOPPING':
      return TravelRoomPlanCategory.shopping;
    case 'ACCOMMODATION':
      return TravelRoomPlanCategory.accommodation;
    case 'EVENT':
    case 'PERFORMANCE':
    case 'FESTIVAL':
      return TravelRoomPlanCategory.event;
    case 'TOURIST_SPOT':
    case 'CULTURAL_FACILITY':
    case 'LEISURE_SPORTS':
    default:
      return TravelRoomPlanCategory.tourism;
  }
}
