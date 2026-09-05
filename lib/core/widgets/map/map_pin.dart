import 'package:flutter/material.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_typography.dart';

enum MapPinColor { blue, red, purple, green }

class MapPin extends StatelessWidget {
  const MapPin({super.key, required this.number, required this.color});

  final int number;
  final MapPinColor color;

  static const Color _blue = Color(0xFF3493EA);
  static const Color _red = Color(0xFFF27A70);
  static const Color _purple = Color(0xFF956BE0);

  Color get _backgroundColor {
    switch (color) {
      case MapPinColor.blue:
        return _blue;

      case MapPinColor.red:
        return _red;

      case MapPinColor.purple:
        return _purple;

      case MapPinColor.green:
        return AppColors.main;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 17,
      height: 17,
      decoration: BoxDecoration(
        color: _backgroundColor,
        shape: BoxShape.circle,
      ),
      alignment: Alignment.center,
      child: Text(
        '$number',
        style: AppTypography.bodyMap.copyWith(
          color: AppColors.backgroundPrimary,
        ),
      ),
    );
  }
}
