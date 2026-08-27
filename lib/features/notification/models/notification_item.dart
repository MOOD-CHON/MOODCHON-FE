class NotificationItem {
  const NotificationItem({
    required this.id,
    required this.requesterName,
    required this.tripName,
    required this.createdAt,
    required this.isRead,
  });

  final String id;
  final String requesterName;
  final String tripName;
  final DateTime createdAt;
  final bool isRead;

  String get title => '$requesterName님이 무드 선택을 요청했어요.';

  String get relativeDate {
    final now = DateTime.now();

    final today = DateTime(now.year, now.month, now.day);

    final createdDay = DateTime(createdAt.year, createdAt.month, createdAt.day);

    final days = today.difference(createdDay).inDays;

    return '$days일 전';
  }

  NotificationItem copyWith({
    String? id,
    String? requesterName,
    String? tripName,
    DateTime? createdAt,
    bool? isRead,
  }) {
    return NotificationItem(
      id: id ?? this.id,
      requesterName: requesterName ?? this.requesterName,
      tripName: tripName ?? this.tripName,
      createdAt: createdAt ?? this.createdAt,
      isRead: isRead ?? this.isRead,
    );
  }
}
