class CreateTripMoodCard {
  const CreateTripMoodCard({
    required this.id,
    required this.imageUrl,
    required this.placeName,
    required this.placeCategoryLabel,
    required this.tagNames,
  });

  final int id;
  final String imageUrl;
  final String placeName;
  final String placeCategoryLabel;
  final List<String> tagNames;

  factory CreateTripMoodCard.fromJson(Map<String, dynamic> json) {
    return CreateTripMoodCard(
      id: json['id'] as int,
      imageUrl: json['imageUrl'] as String,
      placeName: json['placeName'] as String,
      placeCategoryLabel: json['placeCategoryLabel'] as String,
      tagNames: List<String>.from(json['tagNames'] as List),
    );
  }
}
