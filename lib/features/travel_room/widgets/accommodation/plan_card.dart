import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_shadows.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../core/widgets/button/green/green_thin_button.dart';
import '../../../../core/widgets/icon/pin_icon.dart';
import '../../../../core/widgets/profile/vote_profile.dart';
import '../../../../core/widgets/tag/mood_tag.dart';
import '../../models/accommodation_recommendation.dart';

enum PlanCardType { lodging1 }

class PlanCard extends StatelessWidget {
  const PlanCard({
    super.key,
    required this.type,
    required this.data,
    required this.onDetailTap,
  });

  final PlanCardType type;
  final AccommodationRecommendation data;
  final VoidCallback onDetailTap;

  @override
  Widget build(BuildContext context) {
    switch (type) {
      case PlanCardType.lodging1:
        return _LodgingPlanCard(data: data, onDetailTap: onDetailTap);
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
