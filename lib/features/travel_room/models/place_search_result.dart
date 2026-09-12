import '../../../core/widgets/tag/map_tag.dart';
import 'itinerary_place_category.dart';

/// 9.3.2 일정 추가 검색 결과 카드 한 개.
class PlaceSearchResult {
  const PlaceSearchResult({
    required this.placeId,
    required this.name,
    required this.address,
    required this.categoryLabel,
    required this.tagColor,
    required this.thumbnailUrl,
  });

  factory PlaceSearchResult.fromJson(Map<String, dynamic> json) {
    return PlaceSearchResult(
      placeId: json['placeId'] as int,
      name: json['name'] as String? ?? '',
      address: json['address'] as String? ?? '',
      categoryLabel: json['categoryLabel'] as String? ?? '',
      tagColor: parseMapTagColor(json['tagColor'] as String?),
      thumbnailUrl: json['thumbnailUrl'] as String?,
    );
  }

  final int placeId;
  final String name;
  final String address;
  final String categoryLabel;
  final MapTagColor tagColor;
  final String? thumbnailUrl;
}
