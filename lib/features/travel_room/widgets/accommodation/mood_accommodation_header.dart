import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../core/widgets/tag/mood_tag.dart';

class MoodAccommodationHeader extends StatelessWidget {
  const MoodAccommodationHeader({
    super.key,
    required this.moodName,
    required this.moodTags,
    required this.travelInfo,
  });

  final String moodName;
  final List<String> moodTags;
  final List<String> travelInfo;

  @override
  Widget build(BuildContext context) {
    final visibleInfo = travelInfo
        .map((value) => value.trim())
        .where((value) => value.isNotEmpty)
        .toList();

    return Container(
      width: double.infinity,
      color: AppColors.backgroundWhiteIvory,
      padding: const EdgeInsets.fromLTRB(16, 11, 16, 11),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Text(
                  moodName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTypography.titleNav.copyWith(color: AppColors.main),
                ),
              ),
              const SizedBox(width: 8),
              Wrap(
                spacing: 7,
                children: moodTags
                    .take(4)
                    .map(
                      (tag) => MoodTag(
                        label: tag,
                        size: MoodTagSize.small,
                        background: MoodTagBackground.none,
                      ),
                    )
                    .toList(),
              ),
            ],
          ),
          if (visibleInfo.isNotEmpty) ...[
            const SizedBox(height: 14),
            _TravelInfoWrap(values: visibleInfo),
          ],
        ],
      ),
    );
  }
}

class _TravelInfoWrap extends StatelessWidget {
  const _TravelInfoWrap({required this.values});

  final List<String> values;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      runSpacing: 6,
      children: [
        for (var index = 0; index < values.length; index++) ...[
          Text(
            values[index],
            style: AppTypography.tabSmall.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          if (index < values.length - 1)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 9),
              child: Container(
                width: 0.4,
                height: 7,
                color: AppColors.textSecondary.withValues(alpha: 0.5),
              ),
            ),
        ],
      ],
    );
  }
}
