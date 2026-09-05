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
          child: Row(
            children: [
              const HomeTripThumbnail(),
              const SizedBox(width: 13),
              Expanded(
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
                        ),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      '${trip.dateRange}  |  ${trip.memberCount}명',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTypography.tabSmall.copyWith(
                        color: AppColors.grayPrimary,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              _StatusLabel(status: trip.status),
            ],
          ),
        ),
      ),
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
