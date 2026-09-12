import '../../../core/widgets/tag/map_tag.dart';
import 'itinerary_place_category.dart';
import 'recommended_itinerary.dart';

/// 9.3.1-1 "무드촌이 추천하는 활동" 카드 한 개.
class ItineraryActivitySuggestion {
  const ItineraryActivitySuggestion({
    required this.placeId,
    required this.name,
    required this.categoryLabel,
    required this.tagColor,
    required this.thumbnailUrl,
    required this.moodFitScore,
    required this.aiSummary,
    required this.transportMode,
    required this.travelMinutes,
  });

  factory ItineraryActivitySuggestion.fromJson(Map<String, dynamic> json) {
    return ItineraryActivitySuggestion(
      placeId: json['placeId'] as int,
      name: json['name'] as String? ?? '',
      categoryLabel: json['categoryLabel'] as String? ?? '',
      tagColor: parseMapTagColor(json['tagColor'] as String?),
      thumbnailUrl: json['thumbnailUrl'] as String?,
      moodFitScore: json['moodFitScore'] as int? ?? 0,
      aiSummary: json['aiSummary'] as String? ?? '',
      transportMode: parseItineraryTransportMode(
        json['transportMode'] as String?,
      ),
      travelMinutes: json['travelMinutes'] as int?,
    );
  }

  final int placeId;
  final String name;
  final String categoryLabel;
  final MapTagColor tagColor;
  final String? thumbnailUrl;
  final int moodFitScore;
  final String aiSummary;
  final ItineraryTransportMode? transportMode;
  final int? travelMinutes;

  String? get accommodationDistanceText {
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
