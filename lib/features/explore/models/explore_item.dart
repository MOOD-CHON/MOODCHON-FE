class ExploreItem {
  const ExploreItem({
    required this.id,
    required this.imageUrl,
    required this.tag,
    required this.placeName,
    required this.description,
    required this.mood,
    this.searchKeywords = const [],
  });

  final String id;
  final String imageUrl;
  final String tag;

  final String placeName;
  final String description;
  final String mood;

  final List<String> searchKeywords;

  bool matchesQuery(String query) {
    final normalizedQuery = query.trim().toLowerCase();

    if (normalizedQuery.isEmpty) {
      return true;
    }

    return placeName.toLowerCase().contains(normalizedQuery) ||
        description.toLowerCase().contains(normalizedQuery) ||
        searchKeywords.any(
          (keyword) => keyword.toLowerCase().contains(normalizedQuery),
        );
  }
}
