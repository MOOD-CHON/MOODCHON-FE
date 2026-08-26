class PlaceFolder {
  const PlaceFolder({
    required this.id,
    required this.name,
    required this.placeCount,
    this.coverImageUrl,
  });

  final String id;
  final String name;
  final int placeCount;
  final String? coverImageUrl;
}
