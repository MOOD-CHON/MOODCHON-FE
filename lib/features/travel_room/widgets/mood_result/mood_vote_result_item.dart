import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_typography.dart';
import '../../models/mood_vote_result.dart';
import 'mood_progress_bar.dart';

class MoodVoteResultItem extends StatelessWidget {
  const MoodVoteResultItem({
    super.key,
    required this.result,
    required this.memberCount,
    required this.labelWidth,
  });

  final MoodVoteResult result;
  final int memberCount;
  final double labelWidth;

  static const double _gap = 23;

  @override
  Widget build(BuildContext context) {
    final textStyle = AppTypography.bodyMedium.copyWith(
      color: AppColors.textPrimary,
    );

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          width: labelWidth,
          child: Text(result.tag, maxLines: 1, style: textStyle),
        ),
        const SizedBox(width: _gap),
        Expanded(
          child: MoodProgressBar(
            totalCount: memberCount,
            selectedCount: result.voteCount,
          ),
        ),
      ],
    );
  }
}
