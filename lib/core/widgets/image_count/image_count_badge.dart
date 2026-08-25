import 'package:flutter/material.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_typography.dart';

class ImageCountBadge extends StatelessWidget {
  const ImageCountBadge({super.key, required this.current, required this.total})
    : assert(current >= 1),
      assert(total >= 1),
      assert(current <= total);

  final int current;
  final int total;

  static const double _horizontalPadding = 12;
  static const double _verticalPadding = 4;

  double _calculateWidth(BuildContext context) {
    final textStyle = AppTypography.bodySmall.copyWith(
      color: AppColors.backgroundWhite,
    );

    final maxText = '$total/$total';

    final textPainter = TextPainter(
      text: TextSpan(text: maxText, style: textStyle),
      maxLines: 1,
      textDirection: Directionality.of(context),
    )..layout();

    return textPainter.width + (_horizontalPadding * 2);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: _calculateWidth(context),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: _horizontalPadding,
          vertical: _verticalPadding,
        ),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: 0.5),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Text(
          '$current/$total',
          maxLines: 1,
          textAlign: TextAlign.center,
          style: AppTypography.bodySmall.copyWith(
            color: AppColors.backgroundWhite,
          ),
        ),
      ),
    );
  }
}
