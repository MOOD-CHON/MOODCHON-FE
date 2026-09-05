import 'package:flutter/material.dart';

import '../../../app/theme/app_colors.dart';

class MoodSelectionProgressBar extends StatelessWidget {
  const MoodSelectionProgressBar({super.key, required this.value});

  final double value;

  static const double _height = 13;
  static const double _radius = 20;

  @override
  Widget build(BuildContext context) {
    final progress = value.clamp(0.0, 1.0).toDouble();

    return ClipRRect(
      borderRadius: BorderRadius.circular(_radius),
      child: SizedBox(
        width: double.infinity,
        height: _height,
        child: Stack(
          fit: StackFit.expand,
          children: [
            Container(
              decoration: BoxDecoration(
                color: AppColors.grayProgress,
                borderRadius: BorderRadius.circular(_radius),
              ),
            ),
            FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: progress,
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.greenProgress,
                  borderRadius: BorderRadius.circular(_radius),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
