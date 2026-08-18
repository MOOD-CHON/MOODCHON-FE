import 'package:flutter/material.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_typography.dart';
import 'choice_chip_border_type.dart';

class MoodChoiceChip extends StatelessWidget {
  const MoodChoiceChip({
    super.key,
    required this.label,
    required this.borderType,
    required this.selected,
    required this.onSelected,
  });

  final String label;
  final ChoiceChipBorderType borderType;
  final bool selected;
  final ValueChanged<bool> onSelected;

  static const double _horizontalPadding = 14;
  static const double _verticalPadding = 8;
  static const double _radius = 18;
  static const double _borderWidth = 1.2;

  Color get _backgroundColor {
    if (selected) {
      return AppColors.greenTab;
    }

    return AppColors.backgroundWhite;
  }

  Color get _borderColor {
    if (selected) {
      return AppColors.main;
    }

    switch (borderType) {
      case ChoiceChipBorderType.borderO:
        return AppColors.linePrimary;
      case ChoiceChipBorderType.borderX:
        return AppColors.backgroundWhite;
    }
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
        onTap: () => onSelected(!selected),
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: _horizontalPadding,
            vertical: _verticalPadding,
          ),
          decoration: BoxDecoration(
            color: _backgroundColor,
            borderRadius: BorderRadius.circular(_radius),
            border: Border.all(color: _borderColor, width: _borderWidth),
          ),
          child: ExcludeSemantics(
            child: Text(
              label,
              textAlign: TextAlign.center,
              style: AppTypography.tabMedium.copyWith(color: _textColor),
            ),
          ),
        ),
      ),
    );
  }
}
