import '../../../core/widgets/tag/map_tag.dart';

class PlaceSummary {
  const PlaceSummary({
    required this.id,
    required this.name,
    required this.categoryLabel,
    required this.tagColor,
    required this.address,
    required this.latitude,
    required this.longitude,
    required this.thumbnailUrl,
  });

  factory PlaceSummary.fromJson(Map<String, dynamic> json) {
    return PlaceSummary(
      id: json['id'] as int,
      name: json['name'] as String? ?? '',
      categoryLabel: json['categoryLabel'] as String? ?? '',
      tagColor: _parseTagColor(json['tagColor'] as String?),
      address: json['address'] as String?,
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
      thumbnailUrl: json['thumbnailUrl'] as String?,
    );
  }

  final int id;
  final String name;
  final String categoryLabel;
  final MapTagColor tagColor;
  final String? address;
  final double? latitude;
  final double? longitude;
  final String? thumbnailUrl;

  static MapTagColor _parseTagColor(String? value) {
    switch (value) {
      case 'BLUE':
        return MapTagColor.blue;
      case 'RED':
        return MapTagColor.red;
      case 'PURPLE':
        return MapTagColor.purple;
      case 'GREEN':
      default:
        return MapTagColor.green;
    }
  }
}
