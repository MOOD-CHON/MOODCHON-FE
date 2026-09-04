import 'travel_room_plan_category.dart';

class TravelRoomPlanItem {
  const TravelRoomPlanItem({
    required this.order,
    required this.title,
    required this.category,
    this.imageUrl,
    this.summary,
    this.moodMatchRate,
    this.accommodationDistanceText,
  });

  final int order;
  final String title;
  final TravelRoomPlanCategory category;

  final String? imageUrl;
  final String? summary;

  final int? moodMatchRate;
  final String? accommodationDistanceText;

  bool get hasPlace => category != TravelRoomPlanCategory.activity;
}
