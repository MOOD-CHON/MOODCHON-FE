class RoomInfo {
  const RoomInfo({
    required this.name,
    this.imagePath,
    this.roomCount,
    this.standardCapacity,
    this.maximumCapacity,
    this.offSeasonWeekdayPrice,
    this.offSeasonWeekendPrice,
    this.peakSeasonWeekdayPrice,
    this.peakSeasonWeekendPrice,
    this.facilities = const [],
  });

  final String name;
  final String? imagePath;

  final int? roomCount;
  final int? standardCapacity;
  final int? maximumCapacity;

  final String? offSeasonWeekdayPrice;
  final String? offSeasonWeekendPrice;
  final String? peakSeasonWeekdayPrice;
  final String? peakSeasonWeekendPrice;

  final List<String> facilities;
}
