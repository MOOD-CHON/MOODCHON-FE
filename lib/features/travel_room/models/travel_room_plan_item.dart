import '../../../core/widgets/map/map_pin.dart';
import '../../../core/widgets/tag/map_tag.dart';
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
    this.tagLabel,
    this.tagColor,
  });

  final int order;
  final String title;
  final TravelRoomPlanCategory category;

  final String? imageUrl;
  final String? summary;

  final int? moodMatchRate;
  final String? accommodationDistanceText;

  /// 서버가 내려준 실제 장소 분류 라벨/색상입니다.
  /// 값이 있으면 [category]의 기본 라벨/색상 대신 이 값을 표시합니다.
  final String? tagLabel;
  final MapTagColor? tagColor;

  bool get hasPlace => category != TravelRoomPlanCategory.activity;

  String get displayTagLabel => tagLabel ?? category.label;

  MapTagColor get displayTagColor => tagColor ?? category.mapTagColor;

  MapPinColor get displayPinColor {
    final color = tagColor;

    if (color == null) {
      return category.mapPinColor;
    }

    switch (color) {
      case MapTagColor.blue:
        return MapPinColor.blue;
      case MapTagColor.red:
        return MapPinColor.red;
      case MapTagColor.purple:
        return MapPinColor.purple;
      case MapTagColor.green:
        return MapPinColor.green;
    }
  }
}
