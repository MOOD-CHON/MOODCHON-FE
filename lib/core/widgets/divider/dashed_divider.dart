import 'package:flutter/material.dart';

import '../../../app/theme/app_colors.dart';

enum DashedDividerDirection { horizontal, vertical }

class DashedDivider extends StatelessWidget {
  const DashedDivider({
    super.key,
    required this.direction,
    required this.length,
  });

  final DashedDividerDirection direction;
  final double length;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: direction == DashedDividerDirection.horizontal
          ? Size(length, 1)
          : Size(1, length),
      painter: _DashedDividerPainter(direction: direction),
    );
  }
}

class _DashedDividerPainter extends CustomPainter {
  const _DashedDividerPainter({required this.direction});

  final DashedDividerDirection direction;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.linePrimary
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    const dashLength = 2.0;
    const gapLength = 2.0;

    if (direction == DashedDividerDirection.vertical) {
      double current = 0;

      while (current < size.height) {
        canvas.drawLine(
          Offset(0, current),
          Offset(0, (current + dashLength).clamp(0, size.height)),
          paint,
        );

        current += dashLength + gapLength;
      }

      return;
    }

    double current = 0;

    while (current < size.width) {
      canvas.drawLine(
        Offset(current, 0),
        Offset((current + dashLength).clamp(0, size.width), 0),
        paint,
      );

      current += dashLength + gapLength;
    }
  }

  @override
  bool shouldRepaint(covariant _DashedDividerPainter oldDelegate) {
    return oldDelegate.direction != direction;
  }
}
