import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_interactions.dart';
import '../../../app/theme/app_shadows.dart';
import '../../../app/theme/app_typography.dart';
import '../models/notification_item.dart';

class NotificationCard extends StatefulWidget {
  const NotificationCard({
    super.key,
    required this.notification,
    required this.onTap,
  });

  final NotificationItem notification;
  final VoidCallback onTap;

  @override
  State<NotificationCard> createState() => _NotificationCardState();
}

class _NotificationCardState extends State<NotificationCard> {
  bool _isPressed = false;

  void _setPressed(bool value) {
    setState(() {
      _isPressed = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    final notification = widget.notification;

    return Semantics(
      button: true,
      label: notification.title,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: widget.onTap,
        onTapDown: (_) {
          _setPressed(true);
        },
        onTapUp: (_) {
          _setPressed(false);
        },
        onTapCancel: () {
          _setPressed(false);
        },
        child: AnimatedScale(
          scale: _isPressed ? AppInteractions.pressedScale : 1,
          duration: AppInteractions.pressedDuration,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
            decoration: BoxDecoration(
              color: notification.isRead
                  ? AppColors.backgroundWhite
                  : AppColors.backgroundGreen,
              borderRadius: BorderRadius.circular(16),
              boxShadow: AppShadows.notification,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 20,
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            notification.title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontFamily: 'Pretendard',
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              height: 20 / 14,
                            ).copyWith(color: AppColors.textPrimary),
                          ),
                        ),
                      ),
                      const SizedBox(height: 7),
                      _buildMeta(notification),
                    ],
                  ),
                ),
                SvgPicture.asset(
                  'assets/icons/arrow_go/arrow_go_small_black.svg',
                  width: 12,
                  height: 12,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMeta(NotificationItem notification) {
    final metaTextStyle = AppTypography.bodyMedium.copyWith(
      color: AppColors.textSecondary,
      height: 1,
    );

    return SizedBox(
      height: 14,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Flexible(
            child: Text(
              notification.tripName,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: metaTextStyle,
            ),
          ),
          const SizedBox(width: 7),
          Container(
            width: 0.4,
            height: 7,
            decoration: BoxDecoration(
              color: AppColors.grayPrimary.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(1),
            ),
          ),
          const SizedBox(width: 7),
          Text(notification.relativeDate, maxLines: 1, style: metaTextStyle),
        ],
      ),
    );
  }
}
