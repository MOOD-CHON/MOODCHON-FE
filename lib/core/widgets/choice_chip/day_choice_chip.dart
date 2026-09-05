import 'package:flutter/material.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_typography.dart';

class DayChoiceChip extends StatelessWidget {
  const DayChoiceChip({
    super.key,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  static const double _width = 48;
  static const double _height = 26;
  static const double _radius = 14;
  static const double _borderWidth = 1.2;

  Color get _backgroundColor {
    return selected ? AppColors.greenTab : AppColors.backgroundWhite;
  }

  Color get _borderColor {
    return selected ? AppColors.main : AppColors.linePrimary;
  }

  Color get _textColor {
    return selected ? AppColors.main : AppColors.grayPrimary;
  }

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      selected: selected,
      label: label,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: Container(
          width: _width,
          height: _height,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: _backgroundColor,
            borderRadius: BorderRadius.circular(_radius),
            border: Border.all(color: _borderColor, width: _borderWidth),
          ),
          child: ExcludeSemantics(
            child: Text(
              label,
              textAlign: TextAlign.center,
              style: AppTypography.bodyMedium.copyWith(color: _textColor),
            ),
          ),
        ),
      ),
    );
  }
}
