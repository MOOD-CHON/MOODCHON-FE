import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_typography.dart';

class MoodMatchReasonBox extends StatelessWidget {
  const MoodMatchReasonBox({super.key, required this.reasons});

  final List<String> reasons;

  String _displayReason(String reason) {
    final trimmed = reason.trim();

    if (trimmed.startsWith('-')) {
      return trimmed;
    }

    return '- $trimmed';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.greenTab,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SvgPicture.asset('assets/icons/select/medium.svg'),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  '이런 점이 우리 무드랑 잘 맞아요.',
                  style: AppTypography.titleSmall.copyWith(
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          for (var index = 0; index < reasons.length; index++) ...[
            Text(
              _displayReason(reasons[index]),
              style: AppTypography.captionExtraSmall.copyWith(
                color: AppColors.textPrimary,
              ),
            ),
            if (index < reasons.length - 1) const SizedBox(height: 6),
          ],
        ],
      ),
    );
  }
}
