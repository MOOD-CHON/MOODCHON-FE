class MoodCard {
  const MoodCard({
    required this.id,
    required this.imageUrl,
    required this.accommodationTypeName,
    required this.tagNames,
  });

  factory MoodCard.fromJson(Map<String, dynamic> json) {
    return MoodCard(
      id: json['id'] as int,
      imageUrl: json['imageUrl'] as String? ?? '',
      accommodationTypeName: json['accommodationTypeName'] as String? ?? '',
      tagNames:
          (json['tagNames'] as List?)?.map((tag) => tag as String).toList() ??
              const [],
    );
  }

  final int id;
  final String imageUrl;
  final String accommodationTypeName;
  final List<String> tagNames;
}
