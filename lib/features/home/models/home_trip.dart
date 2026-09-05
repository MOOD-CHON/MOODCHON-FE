enum HomeTripStatus { inProgress, completed }

class HomeTrip {
  const HomeTrip({
    required this.name,
    required this.moodLabel,
    required this.dateRange,
    required this.memberCount,
    required this.dDay,
    required this.status,
  });

  final String name;
  final String moodLabel;
  final String dateRange;
  final int memberCount;
  final int dDay;
  final HomeTripStatus status;

  bool get isInProgress => status == HomeTripStatus.inProgress;
}
