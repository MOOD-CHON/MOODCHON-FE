import 'recommended_itinerary.dart';
import 'travel_room_day_plan.dart';
import 'travel_room_plan_category.dart';
import 'travel_room_plan_item.dart';

extension ItineraryDayMapper on ItineraryDay {
  TravelRoomDayPlan toDayPlan() {
    return TravelRoomDayPlan(
      day: dayNumber,
      items: items.map((item) => item.toPlanItem()).toList(),
    );
  }
}

extension ItineraryItemMapper on ItineraryItem {
  TravelRoomPlanItem toPlanItem() {
    final hasPlace = place != null;

    return TravelRoomPlanItem(
      order: order,
      title: title,
      // hasPlace 여부만 필요하고, 실제 라벨/색상은 tagLabel/tagColor로
      // 덮어써서 표시하므로 임의의 비활동(non-activity) 값을 씁니다.
      category: hasPlace
          ? TravelRoomPlanCategory.tourism
          : TravelRoomPlanCategory.activity,
      imageUrl: place?.thumbnailUrl,
      summary: aiSummary,
      moodMatchRate: moodFitScore,
      accommodationDistanceText: _distanceText,
      tagLabel: place?.categoryLabel ?? customCategoryLabel,
      tagColor: place?.tagColor,
    );
  }

  String? get _distanceText {
    final minutes = travelMinutes;
    final mode = transportMode;

    if (minutes == null || mode == null) {
      return null;
    }

    final modeLabel = switch (mode) {
      ItineraryTransportMode.walk => '걸어서',
      ItineraryTransportMode.car => '차량으로',
    };

    return '숙소에서 $modeLabel $minutes분';
  }
}
