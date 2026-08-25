import 'package:flutter/material.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_typography.dart';

enum MapTagColor { blue, red, purple, green }

enum MapTagSize { small, medium }

class MapTag extends StatelessWidget {
  const MapTag({
    super.key,
    required this.label,
    required this.color,
    required this.size,
  });

  final String label;
  final MapTagColor color;
  final MapTagSize size;

  static const Color _blueBackground = Color(0xFFE4F5FF);
  static const Color _blueText = Color(0xFF3493EA);

  static const Color _redBackground = Color(0xFFFFEEEE);
  static const Color _redText = Color(0xFFF27A70);

  static const Color _purpleBackground = Color(0xFFF5EAFC);
  static const Color _purpleText = Color(0xFF956BE0);

  EdgeInsets get _padding {
    switch (size) {
      case MapTagSize.small:
        return const EdgeInsets.symmetric(horizontal: 6, vertical: 1);
      case MapTagSize.medium:
        return const EdgeInsets.symmetric(horizontal: 6, vertical: 2);
    }
  }

  double get _radius {
    switch (size) {
      case MapTagSize.small:
        return 30;
      case MapTagSize.medium:
        return 12;
    }
  }

  Color get _backgroundColor {
    switch (color) {
      case MapTagColor.blue:
        return _blueBackground;
      case MapTagColor.red:
        return _redBackground;
      case MapTagColor.purple:
        return _purpleBackground;
      case MapTagColor.green:
        return AppColors.greenTab;
    }
  }

  Color get _textColor {
    switch (color) {
      case MapTagColor.blue:
        return _blueText;
      case MapTagColor.red:
        return _redText;
      case MapTagColor.purple:
        return _purpleText;
      case MapTagColor.green:
        return AppColors.main;
    }
  }

  TextStyle get _textStyle {
    switch (size) {
      case MapTagSize.small:
        return AppTypography.tabSmall;
      case MapTagSize.medium:
        return AppTypography.tabMedium;
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
      child: Text(label, style: _textStyle.copyWith(color: _textColor)),
    );
  }
}
