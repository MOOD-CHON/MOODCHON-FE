import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_typography.dart';

class MoodSelect extends StatelessWidget {
  const MoodSelect({super.key, required this.completed, this.name});

  final bool completed;
  final String? name;

  String get _assetPath {
    return completed
        ? 'assets/images/character/mood_select/select_o.svg'
        : 'assets/images/character/mood_select/select_x.svg';
  }

  String get _label {
    if (!completed) {
      return '대기 중';
    }

    final trimmedName = name?.trim() ?? '';

    return trimmedName.isEmpty ? '완료' : trimmedName;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 83,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.asset(_assetPath, width: 83, height: 65),

          const SizedBox(height: 6),

          Text(
            _label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: AppTypography.captionMedium.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
