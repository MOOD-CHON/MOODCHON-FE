import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_interactions.dart';
import '../../../../app/theme/app_typography.dart';

class GreenThinButton extends StatefulWidget {
  const GreenThinButton({super.key, required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  State<GreenThinButton> createState() => _GreenThinButtonState();
}

class _GreenThinButtonState extends State<GreenThinButton> {
  static const double _designWidth = 232;
  static const double _height = 24;
  static const double _radius = 10;

  static const double _flowerRotationDegree = -34.42;

  bool _isPressed = false;

  void _setPressed(bool value) {
    setState(() {
      _isPressed = value;
    });
  }

  double _responsiveLeft({
    required double actualWidth,
    required double designX,
  }) {
    return actualWidth - (_designWidth - designX);
  }

  double _toRadians(double degree) {
    return degree * math.pi / 180;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final actualWidth = constraints.maxWidth;

        return Semantics(
          button: true,
          label: widget.label,
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: widget.onTap,
            onTapDown: (_) => _setPressed(true),
            onTapUp: (_) => _setPressed(false),
            onTapCancel: () => _setPressed(false),
            child: AnimatedScale(
              scale: _isPressed ? AppInteractions.pressedScale : 1,
              duration: AppInteractions.pressedDuration,
              child: SizedBox(
                width: double.infinity,
                height: _height,
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Positioned.fill(
                      child: Container(
                        decoration: BoxDecoration(
                          color: AppColors.main,
                          borderRadius: BorderRadius.circular(_radius),
                          border: Border.all(color: AppColors.main, width: 0.4),
                        ),
                      ),
                    ),
                    Positioned(
                      left: _responsiveLeft(
                        actualWidth: actualWidth,
                        designX: 203,
                      ),
                      top: -4,
                      child: Transform.rotate(
                        angle: _toRadians(_flowerRotationDegree),
                        alignment: Alignment.center,
                        child: SvgPicture.asset(
                          'assets/icons/doodle/small/active/one_flower.svg',
                        ),
                      ),
                    ),
                    Positioned(
                      left: _responsiveLeft(
                        actualWidth: actualWidth,
                        designX: 219.23,
                      ),
                      top: 3.17,
                      child: SvgPicture.asset(
                        'assets/icons/doodle/small/active/spark_lines.svg',
                      ),
                    ),
                    Positioned(
                      left: _responsiveLeft(
                        actualWidth: actualWidth,
                        designX: 217,
                      ),
                      top: 12,
                      child: SvgPicture.asset(
                        'assets/icons/doodle/small/active/squiggle_1.svg',
                      ),
                    ),
                    Positioned.fill(
                      child: Center(
                        child: Text(
                          widget.label,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                          style: AppTypography.bodyMap.copyWith(
                            color: AppColors.backgroundPrimary,
                          ),
                        ),
                      ),
                    ),
                    if (_isPressed)
                      Positioned.fill(
                        child: IgnorePointer(
                          child: Container(
                            decoration: BoxDecoration(
                              color: AppColors.backgroundWhite.withValues(
                                alpha: 0.14,
                              ),
                              borderRadius: BorderRadius.circular(_radius),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
