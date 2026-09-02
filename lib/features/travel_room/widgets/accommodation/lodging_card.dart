import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_shadows.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../core/widgets/button/green/green_button.dart';
import '../../../../core/widgets/button/green/green_button_size.dart';
import '../../../../core/widgets/icon/pin_icon.dart';
import '../../../../core/widgets/icon/place_info_icon.dart';
import '../../../../core/widgets/profile/vote_profile.dart';
import '../../../../core/widgets/tag/facilities_tag.dart';
import '../../../../core/widgets/tag/mood_tag.dart';
import '../../../../core/widgets/tag/order_tag.dart';
import '../../models/accommodation_recommendation.dart';
import 'mood_match_reason_box.dart';

class LodgingCard extends StatelessWidget {
  const LodgingCard({
    super.key,
    required this.data,
    required this.onDetailTap,
    this.imageHeight = 174,
  });

  final AccommodationRecommendation data;
  final VoidCallback onDetailTap;

  /// 기본 174.
  /// 캐러셀에서 카드 높이를 맞출 때 짧은 카드만 이 값을 늘린다.
  final double imageHeight;

  static const double width = 320;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: AppColors.backgroundWhite,
        borderRadius: BorderRadius.circular(16),
        boxShadow: AppShadows.card,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildImage(),

          const SizedBox(height: 15),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 1.5),
            child: _buildInformation(),
          ),

          const SizedBox(height: 10),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 1.5),
            child: MoodMatchReasonBox(reasons: data.matchReasons),
          ),

          // 잘 맞아요 박스 → 버튼 10
          const SizedBox(height: 10),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 1.5),
            child: SizedBox(
              width: double.infinity,
              child: GreenButton(
                size: GreenButtonSize.small,
                label: '숙소 자세히 보기',
                onTap: onDetailTap,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImage() {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: SizedBox(
            width: 304,
            height: imageHeight,
            child: data.imageUrl == null || data.imageUrl!.trim().isEmpty
                ? Container(color: AppColors.linePrimary)
                : Image.network(
                    data.imageUrl!,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) {
                      return Container(color: AppColors.linePrimary);
                    },
                  ),
          ),
        ),

        Positioned(left: 6, top: 6, child: OrderTag(label: '${data.rank}위')),
      ],
    );
  }

  Widget _buildInformation() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildTopArea(),

        const SizedBox(height: 10),

        _buildMoodTags(),

        if (data.facilities.isNotEmpty) ...[
          const SizedBox(height: 10),
          _buildFacilities(),
        ],
      ],
    );
  }

  Widget _buildTopArea() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 숙소명과 무드 적합도는 세로 가운데 정렬
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Text(
                data.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTypography.titleNav.copyWith(
                  color: AppColors.textPrimary,
                ),
              ),
            ),

            const SizedBox(width: 5),

            // 카드 오른쪽 기준:
            // card padding 8 + information padding 1.5 = 9.5
            Padding(
              padding: const EdgeInsets.all(2),
              child: Row(
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
                    style: AppTypography.titleNav.copyWith(
                      color: AppColors.main,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),

        // 첫 번째 행 아래에서
        // 위치는 8px,
        // VoteProfile은 5px 아래에 각각 독립적으로 배치
        SizedBox(
          height: 26,
          child: Stack(
            children: [
              Positioned(top: 8, left: 0, right: 70, child: _buildLocation()),

              if (data.voters.isNotEmpty)
                Positioned(
                  top: 5,
                  right: 2.5,
                  child: VoteProfile(
                    members: data.voters,
                    size: VoteProfileSize.medium,
                  ),
                ),
            ],
          ),
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

  Widget _buildFacilities() {
    return Wrap(
      spacing: 6,
      runSpacing: 6,
      children: data.facilities.map((facility) {
        switch (facility) {
          case LodgingFacility.puppy:
            return const FacilitiesTag.medium(
              label: '반려동물 동반',
              iconType: PlaceInfoSmallIconType.puppy,
            );

          case LodgingFacility.bbq:
            return const FacilitiesTag.medium(
              label: '바비큐 가능',
              iconType: PlaceInfoSmallIconType.bbq,
            );

          case LodgingFacility.cook:
            return const FacilitiesTag.medium(
              label: '취사 가능',
              iconType: PlaceInfoSmallIconType.cook,
            );
        }
      }).toList(),
    );
  }
}
