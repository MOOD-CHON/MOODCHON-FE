import 'travel_room_plan_item.dart';

class TravelRoomDayPlan {
  const TravelRoomDayPlan({required this.day, required this.items});

  final int day;
  final List<TravelRoomPlanItem> items;
}
