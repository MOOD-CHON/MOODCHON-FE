import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_shadows.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../core/widgets/button/green/green_thin_button.dart';
import '../../../../core/widgets/icon/pin_icon.dart';
import '../../../../core/widgets/profile/vote_profile.dart';
import '../../../../core/widgets/tag/map_tag.dart';
import '../../../../core/widgets/tag/mood_tag.dart';
import '../../models/accommodation_recommendation.dart';
import '../../models/travel_room_plan_category.dart';
import '../../models/travel_room_plan_item.dart';

enum PlanCardType { lodging1, lodging2, edit2 }

class PlanCard extends StatelessWidget {
  const PlanCard({
    super.key,
    required this.type,
    required this.onDetailTap,
    this.data,
    this.planItem,
    this.summary,
  }) : assert(
         type == PlanCardType.edit2 ? planItem != null : data != null,
         'edit2는 planItem, lodging 타입은 data가 필요합니다.',
       );

  final PlanCardType type;

  final AccommodationRecommendation? data;
  final TravelRoomPlanItem? planItem;

  final String? summary;

  final VoidCallback onDetailTap;

  @override
  Widget build(BuildContext context) {
    switch (type) {
      case PlanCardType.lodging1:
        return _LodgingPlanCard(data: data!, onDetailTap: onDetailTap);

      case PlanCardType.lodging2:
        return _ConfirmedLodgingPlanCard(
          data: data!,
          summary: summary ?? '',
          onDetailTap: onDetailTap,
        );

      case PlanCardType.edit2:
        return _ItineraryPlaceCard(item: planItem!, onTap: onDetailTap);
    }
  }
}

class _LodgingPlanCard extends StatelessWidget {
  const _LodgingPlanCard({required this.data, required this.onDetailTap});

  final AccommodationRecommendation data;
  final VoidCallback onDetailTap;

  static const double _imageWidth = 98;
  static const double _imageToContentGap = 15;

  bool get _hasVotes => data.voters.isNotEmpty;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: AppColors.backgroundWhite,
        borderRadius: BorderRadius.circular(16),
        boxShadow: AppShadows.card,
      ),
      child: Stack(
        children: [
          Positioned(
            left: 0,
            top: 0,
            bottom: 0,
            width: _imageWidth,
            child: _buildImage(),
          ),
          Padding(
            padding: const EdgeInsets.only(
              left: _imageWidth + _imageToContentGap,
            ),
            child: _buildContent(),
          ),
        ],
      ),
    );
  }

  Widget _buildImage() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: data.imageUrl == null || data.imageUrl!.trim().isEmpty
          ? Container(color: AppColors.linePrimary)
          : Image.network(
              data.imageUrl!,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) {
                return Container(color: AppColors.linePrimary);
              },
            ),
    );
  }

  Widget _buildContent() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildHeader(),

        const SizedBox(height: 6),

        _buildLocation(),

        const SizedBox(height: 6),

        _buildMoodTags(),

        if (_hasVotes) ...[
          const SizedBox(height: 6),

          VoteProfile(members: data.voters, size: VoteProfileSize.medium),
        ],

        const SizedBox(height: 6),

        SizedBox(
          width: double.infinity,
          child: GreenThinButton(label: '숙소 자세히 보기', onTap: onDetailTap),
        ),
      ],
    );
  }

  Widget _buildHeader() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Text(
            data.name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTypography.titleSmall.copyWith(
              color: AppColors.textPrimary,
            ),
          ),
        ),

        const SizedBox(width: 6),

        Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              '무드 적합도',
              style: AppTypography.tabMedium.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(width: 4),
            Text(
              '${data.matchRate}%',
              style: AppTypography.bodyMood.copyWith(color: AppColors.main),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildLocation() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const PinIcon(size: PinIconSize.medium),
        const SizedBox(width: 4),
        Expanded(
          child: Transform.translate(
            offset: const Offset(0, -1),
            child: Text(
              data.location,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTypography.tabMedium.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMoodTags() {
    return Wrap(
      spacing: 2,
      runSpacing: 2,
      children: data.moodTags
          .take(3)
          .map(
            (tag) => MoodTag(
              label: tag,
              size: MoodTagSize.medium,
              background: MoodTagBackground.green,
            ),
          )
          .toList(),
    );
  }
}

class _ConfirmedLodgingPlanCard extends StatelessWidget {
  const _ConfirmedLodgingPlanCard({
    required this.data,
    required this.summary,
    required this.onDetailTap,
  });

  final AccommodationRecommendation data;
  final String summary;
  final VoidCallback onDetailTap;

  static const double _imageWidth = 98;
  static const double _imageToContentGap = 15;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onDetailTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: AppColors.backgroundWhite,
          borderRadius: BorderRadius.circular(16),
          boxShadow: AppShadows.card,
        ),
        child: Stack(
          children: [
            Positioned(
              left: 0,
              top: 0,
              bottom: 0,
              width: _imageWidth,
              child: _buildImage(),
            ),

            Padding(
              padding: const EdgeInsets.only(
                left: _imageWidth + _imageToContentGap,
              ),
              child: _buildContent(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImage() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: data.imageUrl == null || data.imageUrl!.trim().isEmpty
          ? Container(color: AppColors.linePrimary)
          : Image.network(
              data.imageUrl!,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) {
                return Container(color: AppColors.linePrimary);
              },
            ),
    );
  }

  Widget _buildContent() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildHeader(),

        const SizedBox(height: 6),

        _buildLocation(),

        const SizedBox(height: 6),

        _buildMoodTags(),

        const SizedBox(height: 8),

        _buildSummary(),
      ],
    );
  }

  Widget _buildHeader() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Text(
            data.name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTypography.tabLarge.copyWith(
              color: AppColors.textPrimary,
            ),
          ),
        ),

        const SizedBox(width: 6),

        Text(
          '무드 적합도',
          style: AppTypography.tabSmall.copyWith(
            color: AppColors.textSecondary,
          ),
        ),

        const SizedBox(width: 4),

        Text(
          '${data.matchRate}%',
          style: AppTypography.tabLarge.copyWith(color: AppColors.main),
        ),
      ],
    );
  }

  Widget _buildLocation() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const PinIcon(size: PinIconSize.small),

        const SizedBox(width: 4),

        Expanded(
          child: Transform.translate(
            offset: const Offset(0, -1),
            child: Text(
              data.location,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTypography.tabSmall.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMoodTags() {
    return Wrap(
      spacing: 2,
      runSpacing: 2,
      children: data.moodTags
          .take(3)
          .map(
            (tag) => MoodTag(
              label: tag,
              size: MoodTagSize.small,
              background: MoodTagBackground.green,
            ),
          )
          .toList(),
    );
  }

  Widget _buildSummary() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const MapTag(
          label: '숙소',
          color: MapTagColor.green,
          size: MapTagSize.small,
        ),

        const SizedBox(width: 2),

        Expanded(
          child: Text(
            summary,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTypography.captionExtraSmall.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ),
      ],
    );
  }
}

class _ItineraryPlaceCard extends StatelessWidget {
  const _ItineraryPlaceCard({required this.item, required this.onTap});

  final TravelRoomPlanItem item;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Container(
        width: 341,
        height: 70,
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 11),
        decoration: BoxDecoration(
          color: AppColors.backgroundWhite,
          borderRadius: BorderRadius.circular(16),
          boxShadow: AppShadows.card,
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: item.imageUrl == null || item.imageUrl!.trim().isEmpty
                  ? Container(
                      width: 68,
                      height: 48,
                      color: AppColors.linePrimary,
                    )
                  : Image.network(
                      item.imageUrl!,
                      width: 68,
                      height: 48,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) {
                        return Container(
                          width: 68,
                          height: 48,
                          color: AppColors.linePrimary,
                        );
                      },
                    ),
            ),

            const SizedBox(width: 13),

            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTypography.tabLarge.copyWith(
                      color: AppColors.textPrimary,
                    ),
                  ),

                  const SizedBox(height: 6),

                  Row(
                    children: [
                      MapTag(
                        label: item.category.label,
                        color: item.category.mapTagColor,
                        size: MapTagSize.small,
                      ),

                      const SizedBox(width: 2),

                      Expanded(
                        child: Text(
                          item.summary ?? '',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTypography.captionExtraSmall.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
