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

  // place가 null이면(custom 항목) 장소 없이 직접 추가한 일정이라 activity로 취급하고
  // customName/customCategoryLabel을 대신 쓴다. accommodationDistanceText는 백엔드에
  // 대응 데이터가 없어 항상 null.
  factory TravelRoomPlanItem.fromJson(Map<String, dynamic> json) {
    final place = json['place'] as Map<String, dynamic>?;

    return TravelRoomPlanItem(
      order: json['order'] as int,
      title: place != null ? place['name'] as String : (json['customName'] as String? ?? ''),
      category: place != null
          ? travelRoomPlanCategoryFromPlaceCategory(place['category'] as String)
          : TravelRoomPlanCategory.activity,
      imageUrl: place != null ? place['thumbnailUrl'] as String? : null,
      summary: json['aiSummary'] as String?,
      moodMatchRate: json['moodFitScore'] as int?,
    );
  }
}
