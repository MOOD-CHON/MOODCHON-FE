import '../models/notification_item.dart';

class NotificationMockStore {
  NotificationMockStore._();

  static List<NotificationItem> _notifications = [
    NotificationItem(
      id: '1',
      requesterName: 'OO',
      tripName: '촌캉스 이름',
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
      isRead: false,
    ),
  ];

  // 빈 상태
  // static List<NotificationItem> _notifications = [];

  static List<NotificationItem> get notifications {
    final items = List<NotificationItem>.from(_notifications);

    items.sort((a, b) => b.createdAt.compareTo(a.createdAt));

    return items;
  }

  static void addNotification({
    required String id,
    required String requesterName,
    required String tripName,
  }) {
    _notifications = [
      NotificationItem(
        id: id,
        requesterName: requesterName,
        tripName: tripName,
        createdAt: DateTime.now(),
        isRead: false,
      ),
      ..._notifications,
    ];
  }

  static void markAllAsRead() {
    _notifications = _notifications
        .map((notification) => notification.copyWith(isRead: true))
        .toList();
  }

  static void clear() {
    _notifications = [];
  }
}
