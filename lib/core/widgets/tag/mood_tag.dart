import 'package:flutter/material.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_typography.dart';

enum MoodTagSize { large, medium, small }

enum MoodTagBackground { white, none, green }

class MoodTag extends StatelessWidget {
  const MoodTag({
    super.key,
    required this.label,
    required this.size,
    required this.background,
  }) : assert(
         !(size == MoodTagSize.large && background == MoodTagBackground.white),
         'Large + White 조합은 존재하지 않습니다.',
       ),
       assert(
         !(size == MoodTagSize.small && background == MoodTagBackground.white),
         'Small + White 조합은 존재하지 않습니다.',
       );

  final String label;
  final MoodTagSize size;
  final MoodTagBackground background;

  String get _displayLabel {
    final trimmed = label.trim();

    if (trimmed.startsWith('#')) {
      return trimmed;
    }

    return '#$trimmed';
  }

  EdgeInsets get _padding {
    switch ((size, background)) {
      case (MoodTagSize.medium, MoodTagBackground.white):
        return const EdgeInsets.symmetric(horizontal: 14, vertical: 6);

      case (MoodTagSize.large, MoodTagBackground.none):
        return const EdgeInsets.all(4);

      case (MoodTagSize.medium, MoodTagBackground.none):
        return const EdgeInsets.symmetric(horizontal: 3, vertical: 2);

      case (MoodTagSize.small, MoodTagBackground.none):
        return EdgeInsets.zero;

      case (MoodTagSize.large, MoodTagBackground.green):
        return const EdgeInsets.symmetric(horizontal: 10, vertical: 6);

      case (MoodTagSize.medium, MoodTagBackground.green):
        return const EdgeInsets.symmetric(horizontal: 6, vertical: 1);

      case (MoodTagSize.small, MoodTagBackground.green):
        return const EdgeInsets.symmetric(horizontal: 2, vertical: 1);

      default:
        throw StateError('지원하지 않는 MoodTag 조합입니다.');
    }
  }

  double get _radius {
    switch ((size, background)) {
      case (MoodTagSize.medium, MoodTagBackground.white):
        return 18;

      case (MoodTagSize.large, MoodTagBackground.none):
        return 18;

      case (MoodTagSize.medium, MoodTagBackground.none):
      case (MoodTagSize.small, MoodTagBackground.none):
        return 30;

      case (MoodTagSize.large, MoodTagBackground.green):
        return 6;

      case (MoodTagSize.medium, MoodTagBackground.green):
        return 4;

      case (MoodTagSize.small, MoodTagBackground.green):
        return 2;

      default:
        throw StateError('지원하지 않는 MoodTag 조합입니다.');
    }
  }

  Color get _backgroundColor {
    switch (background) {
      case MoodTagBackground.white:
        return AppColors.backgroundWhite;
      case MoodTagBackground.green:
        return AppColors.greenTab;
      case MoodTagBackground.none:
        return Colors.transparent;
    }
  }

  TextStyle get _textStyle {
    switch ((size, background)) {
      case (MoodTagSize.medium, MoodTagBackground.white):
        return AppTypography.tabMedium;

      case (MoodTagSize.large, MoodTagBackground.none):
        return AppTypography.tabMedium;

      case (MoodTagSize.medium, MoodTagBackground.none):
        return AppTypography.captionMedium;

      case (MoodTagSize.small, MoodTagBackground.none):
        return AppTypography.tabSmall;

      case (MoodTagSize.large, MoodTagBackground.green):
        return AppTypography.tabMedium;

      case (MoodTagSize.medium, MoodTagBackground.green):
        return AppTypography.captionMedium;

      case (MoodTagSize.small, MoodTagBackground.green):
        return AppTypography.tabSmall;

      default:
        throw StateError('지원하지 않는 MoodTag 조합입니다.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: _padding,
      decoration: BoxDecoration(
        color: _backgroundColor,
        borderRadius: BorderRadius.circular(_radius),
      ),
      child: Text(
        _displayLabel,
        style: _textStyle.copyWith(color: AppColors.main),
      ),
    );
  }
}
