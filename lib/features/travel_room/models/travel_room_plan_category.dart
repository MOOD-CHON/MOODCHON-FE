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
