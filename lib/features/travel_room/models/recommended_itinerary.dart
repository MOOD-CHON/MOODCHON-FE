import 'place_summary.dart';

enum ItineraryTransportMode { walk, car }

/// 서버 문자열(WALK/CAR)을 [ItineraryTransportMode]로 변환합니다.
ItineraryTransportMode? parseItineraryTransportMode(String? value) {
  switch (value) {
    case 'WALK':
      return ItineraryTransportMode.walk;
    case 'CAR':
      return ItineraryTransportMode.car;
    default:
      return null;
  }
}

class RecommendedItinerary {
  const RecommendedItinerary({
    required this.recommendedItineraryId,
    required this.committed,
    required this.totalDays,
    required this.days,
  });

  factory RecommendedItinerary.fromJson(Map<String, dynamic> json) {
    return RecommendedItinerary(
      recommendedItineraryId: json['recommendedItineraryId'] as int,
      committed: json['committed'] as bool? ?? false,
      totalDays: json['totalDays'] as int? ?? 0,
      days: (json['days'] as List? ?? [])
          .map((day) => ItineraryDay.fromJson(day as Map<String, dynamic>))
          .toList(),
    );
  }

  final int recommendedItineraryId;
  final bool committed;
  final int totalDays;
  final List<ItineraryDay> days;
}

class ItineraryDay {
  const ItineraryDay({required this.dayNumber, required this.items});

  factory ItineraryDay.fromJson(Map<String, dynamic> json) {
    return ItineraryDay(
      dayNumber: json['dayNumber'] as int,
      items: (json['items'] as List? ?? [])
          .map((item) => ItineraryItem.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }

  final int dayNumber;
  final List<ItineraryItem> items;
}

class ItineraryItem {
  const ItineraryItem({
    required this.itemId,
    required this.order,
    required this.place,
    required this.customName,
    required this.customCategoryLabel,
    required this.customTagColor,
    required this.moodFitScore,
    required this.aiSummary,
    required this.transportMode,
    required this.travelMinutes,
  });

  factory ItineraryItem.fromJson(Map<String, dynamic> json) {
    final placeJson = json['place'];

    return ItineraryItem(
      itemId: json['itemId'] as int,
      order: json['order'] as int,
      place: placeJson is Map<String, dynamic>
          ? PlaceSummary.fromJson(placeJson)
          : null,
      customName: json['customName'] as String?,
      customCategoryLabel: json['customCategoryLabel'] as String?,
      customTagColor: json['customTagColor'] as String?,
      moodFitScore: json['moodFitScore'] as int?,
      aiSummary: json['aiSummary'] as String?,
      transportMode: _parseTransportMode(json['transportMode'] as String?),
      travelMinutes: json['travelMinutes'] as int?,
    );
  }

  final int itemId;
  final int order;

  /// AI가 추천한 실제 장소. 촌캉스 특성상 특정 장소가 아니라
  /// '숙소 주변 산책하기' 같은 활동일 때는 null입니다.
  final PlaceSummary? place;
  final String? customName;
  final String? customCategoryLabel;
  final String? customTagColor;

  final int? moodFitScore;
  final String? aiSummary;
  final ItineraryTransportMode? transportMode;
  final int? travelMinutes;

  String get title => place?.name ?? customName ?? '';

  static ItineraryTransportMode? _parseTransportMode(String? value) =>
      parseItineraryTransportMode(value);
}
