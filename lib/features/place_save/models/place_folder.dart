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

  PlaceFolder copyWith({
    String? id,
    String? name,
    int? placeCount,
    String? coverImageUrl,
    bool clearCoverImageUrl = false,
  }) {
    return PlaceFolder(
      id: id ?? this.id,
      name: name ?? this.name,
      placeCount: placeCount ?? this.placeCount,
      coverImageUrl: clearCoverImageUrl
          ? null
          : coverImageUrl ?? this.coverImageUrl,
    );
  }
}
