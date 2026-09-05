import 'dart:math' as math;

import 'package:flutter/material.dart';

class WigglyBorderPainter extends CustomPainter {
  const WigglyBorderPainter({
    required this.color,
    required this.radius,
    required this.strokeWidth,
    this.amplitude = 0.7,
    this.drawOutside = false,
  });

  final Color color;
  final double radius;
  final double strokeWidth;
  final double amplitude;

  /// true일 경우 버튼 외곽 경계까지 선이 흔들리도록 그림
  final bool drawOutside;

  @override
  void paint(Canvas canvas, Size size) {
    if (size.width <= 0 || size.height <= 0) {
      return;
    }

    final double inset = drawOutside
        ? strokeWidth / 2
        : (strokeWidth / 2) + amplitude;

    final Rect rect = Rect.fromLTWH(
      inset,
      inset,
      size.width - (inset * 2),
      size.height - (inset * 2),
    );

    final double safeRadius = math.max(0, radius - inset);

    final Path basePath = Path()
      ..addRRect(RRect.fromRectAndRadius(rect, Radius.circular(safeRadius)));

    final metrics = basePath.computeMetrics().toList();

    if (metrics.isEmpty) {
      return;
    }

    final metric = metrics.first;

    final List<Offset> points = [];

    const double sampleGap = 1.2;

    for (double distance = 0; distance < metric.length; distance += sampleGap) {
      final tangent = metric.getTangentForOffset(distance);

      if (tangent == null) {
        continue;
      }

      final vector = tangent.vector;

      final normal = Offset(-vector.dy, vector.dx);

      final double wave =
          math.sin(distance * 0.115) * amplitude +
          math.sin(distance * 0.047 + 1.3) * amplitude * 0.35;

      points.add(tangent.position + normal * wave);
    }

    if (points.length < 3) {
      return;
    }

    final Path path = Path()..moveTo(points.first.dx, points.first.dy);

    for (int i = 1; i < points.length - 1; i++) {
      final current = points[i];
      final next = points[i + 1];

      final midpoint = Offset(
        (current.dx + next.dx) / 2,
        (current.dy + next.dy) / 2,
      );

      path.quadraticBezierTo(current.dx, current.dy, midpoint.dx, midpoint.dy);
    }

    path
      ..lineTo(points.last.dx, points.last.dy)
      ..close();

    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..isAntiAlias = true;

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant WigglyBorderPainter oldDelegate) {
    return oldDelegate.color != color ||
        oldDelegate.radius != radius ||
        oldDelegate.strokeWidth != strokeWidth ||
        oldDelegate.amplitude != amplitude ||
        oldDelegate.drawOutside != drawOutside;
  }
}
