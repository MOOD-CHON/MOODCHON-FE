import 'place_summary.dart';
import 'recommended_itinerary.dart';

/// 9.3.3 장소 상세 페이지 응답.
/// [itemId]가 null이면 아직 일정에 담기지 않은 장소를 미리보기한 상태입니다.
class ItineraryItemDetail {
  const ItineraryItemDetail({
    required this.itemId,
    required this.place,
    required this.moodFitScore,
    required this.aiSummary,
    required this.transportMode,
    required this.travelMinutes,
    required this.tags,
    required this.description,
    required this.images,
  });

  factory ItineraryItemDetail.fromJson(Map<String, dynamic> json) {
    return ItineraryItemDetail(
      itemId: json['itemId'] as int?,
      place: PlaceSummary.fromJson(json['place'] as Map<String, dynamic>),
      moodFitScore: json['moodFitScore'] as int? ?? 0,
      aiSummary: json['aiSummary'] as String? ?? '',
      transportMode: parseItineraryTransportMode(
        json['transportMode'] as String?,
      ),
      travelMinutes: json['travelMinutes'] as int?,
      tags: (json['tags'] as List? ?? [])
          .map((tag) => tag.toString())
          .toList(),
      description: json['description'] as String?,
      images: (json['images'] as List? ?? [])
          .map((image) => image.toString())
          .where((image) => image.isNotEmpty)
          .toList(),
    );
  }

  final int? itemId;
  final PlaceSummary place;
  final int moodFitScore;
  final String aiSummary;
  final ItineraryTransportMode? transportMode;
  final int? travelMinutes;
  final List<String> tags;
  final String? description;
  final List<String> images;

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
