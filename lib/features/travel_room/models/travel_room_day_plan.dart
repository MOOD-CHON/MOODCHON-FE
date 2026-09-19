import 'travel_room_plan_item.dart';

class TravelRoomDayPlan {
  const TravelRoomDayPlan({required this.day, required this.items});

  final int day;
  final List<TravelRoomPlanItem> items;

  factory TravelRoomDayPlan.fromJson(Map<String, dynamic> json) {
    return TravelRoomDayPlan(
      day: json['dayNumber'] as int,
      items: (json['items'] as List)
          .map((item) => TravelRoomPlanItem.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }
}
