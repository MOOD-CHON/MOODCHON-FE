import 'package:flutter/material.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_typography.dart';

class OptionChip extends StatelessWidget {
  const OptionChip({
    super.key,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  static const double _height = 38;
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
        child: IntrinsicWidth(
          child: Container(
            height: _height,
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: _backgroundColor,
              borderRadius: BorderRadius.circular(_radius),
              border: Border.all(color: _borderColor, width: _borderWidth),
            ),
            child: ExcludeSemantics(
              child: Text(
                label,
                textAlign: TextAlign.center,
                style: AppTypography.bodyExtraLarge.copyWith(
                  color: _textColor,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
