import 'package:flutter/material.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_shadows.dart';
import '../../../app/theme/app_typography.dart';
import '../models/home_trip.dart';
import 'home_continue_trip_button.dart';

class HomePlanCard extends StatelessWidget {
  const HomePlanCard({super.key, required this.trip, required this.onTap});

  final HomeTrip trip;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: '${trip.name} 촌캉스 기록',
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: Container(
          height: 78,
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: AppColors.backgroundWhite,
            borderRadius: BorderRadius.circular(16),
            boxShadow: AppShadows.card,
          ),
          child: Stack(
            children: [
              Row(
                children: [
                  const HomeTripThumbnail(),
                  const SizedBox(width: 13),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(right: 52),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            trip.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppTypography.titleSmall.copyWith(
                              color: AppColors.textPrimary,
                              height: 1,
                            ),
                          ),
                          const SizedBox(height: 3),
                          Container(
                            padding: const EdgeInsets.all(2),
                            decoration: BoxDecoration(
                              color: AppColors.greenTab,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              trip.moodLabel,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: AppTypography.tabSmall.copyWith(
                                color: AppColors.main,
                                height: 1,
                              ),
                            ),
                          ),
                          const SizedBox(height: 6),
                          _PlanCardMeta(trip: trip),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              Positioned(
                right: 1,
                top: 1,
                child: _StatusLabel(status: trip.status),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PlanCardMeta extends StatelessWidget {
  const _PlanCardMeta({required this.trip});

  final HomeTrip trip;

  @override
  Widget build(BuildContext context) {
    final textStyle = AppTypography.tabSmall.copyWith(
      color: AppColors.grayPrimary,
      height: 1,
    );

    return Row(
      children: [
        Flexible(
          child: Text(
            trip.dateRange,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: textStyle,
          ),
        ),
        Container(
          width: 1,
          height: 5,
          margin: const EdgeInsets.symmetric(horizontal: 6),
          color: AppColors.grayPrimary.withValues(alpha: 0.7),
        ),
        Text('${trip.memberCount}명', maxLines: 1, style: textStyle),
      ],
    );
  }
}

class _StatusLabel extends StatelessWidget {
  const _StatusLabel({required this.status});

  final HomeTripStatus status;

  @override
  Widget build(BuildContext context) {
    final isInProgress = status == HomeTripStatus.inProgress;
    final color = isInProgress ? AppColors.main : AppColors.grayPrimary;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
      decoration: BoxDecoration(
        color: isInProgress ? AppColors.greenTab : AppColors.backgroundGray,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color, width: 0.8),
      ),
      child: Text(
        isInProgress ? '진행중' : '완료',
        style: AppTypography.bodyLabel.copyWith(color: color),
      ),
    );
  }
}
