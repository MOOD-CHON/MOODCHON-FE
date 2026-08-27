import 'package:flutter/material.dart';

import '../../../app/theme/app_colors.dart';
import '../../../core/widgets/empty_state/character/empty_state_character_medium.dart';
import '../../../core/widgets/navigation/top_bar.dart';
import '../data/notification_mock_store.dart';
import '../models/notification_item.dart';
import '../widgets/notification_card.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  late List<NotificationItem> _notifications;

  @override
  void initState() {
    super.initState();

    _notifications = NotificationMockStore.notifications;
  }

  @override
  void dispose() {
    NotificationMockStore.markAllAsRead();

    super.dispose();
  }

  void _onNotificationTap(NotificationItem notification) {
    // TODO: 무드 선택 화면 구현 완료 후 연결
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundPrimary,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            TopBar(
              type: TopBarType.title,
              title: '알림',
              onBack: () {
                Navigator.of(context).pop();
              },
            ),
            Expanded(
              child: _notifications.isEmpty
                  ? _buildEmptyState()
                  : _buildNotificationList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationList() {
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 32),
      itemCount: _notifications.length,
      separatorBuilder: (_, __) {
        return const SizedBox(height: 10);
      },
      itemBuilder: (context, index) {
        final notification = _notifications[index];

        return NotificationCard(
          notification: notification,
          onTap: () {
            _onNotificationTap(notification);
          },
        );
      },
    );
  }

  Widget _buildEmptyState() {
    final safeTop = MediaQuery.paddingOf(context).top;

    final top = 335 - safeTop - 56;

    return Stack(
      children: [
        Positioned(
          top: top,
          left: 0,
          right: 0,
          child: const Center(
            child: EmptyStateCharacterMedium(
              title: '아직 알림이 없어요.',
              description: '새로운 소식이 생기면 알려드릴게요.',
            ),
          ),
        ),
      ],
    );
  }
}
