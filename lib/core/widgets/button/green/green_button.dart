import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_interactions.dart';
import '../../../../app/theme/app_shadows.dart';
import '../../../../app/theme/app_typography.dart';
import 'green_button_size.dart';

class GreenButton extends StatefulWidget {
  const GreenButton({
    super.key,
    required this.size,
    required this.label,
    required this.onTap,
    this.disabled = false,
  }) : assert(
         !disabled || size != GreenButtonSize.small,
         'Small GreenButton에는 Disabled 상태가 정의되어 있지 않습니다.',
       );

  final GreenButtonSize size;
  final String label;
  final VoidCallback onTap;
  final bool disabled;

  @override
  State<GreenButton> createState() => _GreenButtonState();
}

class _GreenButtonState extends State<GreenButton> {
  static const double _flowerRotationDegree = -34.42;
  static const double _sparkRotationDegree = 1.31;

  static const double _flowerWidth = 31.85;
  static const double _flowerHeight = 29.11;

  bool _isPressed = false;

  bool get _isDisabled => widget.disabled;

  double get _designWidth {
    switch (widget.size) {
      case GreenButtonSize.long:
        return 361;
      case GreenButtonSize.medium:
        return 325;
      case GreenButtonSize.small:
        return 301;
    }
  }

  double get _height {
    switch (widget.size) {
      case GreenButtonSize.long:
        return 49;
      case GreenButtonSize.medium:
      case GreenButtonSize.small:
        return 38;
    }
  }

  double get _radius {
    switch (widget.size) {
      case GreenButtonSize.long:
        return 16;
      case GreenButtonSize.medium:
      case GreenButtonSize.small:
        return 14;
    }
  }

  double get _labelHorizontalPadding {
    switch (widget.size) {
      case GreenButtonSize.long:
      case GreenButtonSize.medium:
        return 47;
      case GreenButtonSize.small:
        return 49;
    }
  }

  TextStyle get _textStyle {
    final baseStyle = switch (widget.size) {
      GreenButtonSize.long => AppTypography.bodyExtraLarge,
      GreenButtonSize.medium || GreenButtonSize.small => AppTypography.tabLarge,
    };

    return baseStyle.copyWith(
      color: _isDisabled ? AppColors.graySecondary : AppColors.backgroundIvory,
    );
  }

  double get _flowerX {
    switch (widget.size) {
      case GreenButtonSize.long:
        return 314;
      case GreenButtonSize.medium:
        return 278;
      case GreenButtonSize.small:
        return 252;
    }
  }

  double get _flowerY => -5.84;

  double get _sparkX {
    switch (widget.size) {
      case GreenButtonSize.long:
        return 341;
      case GreenButtonSize.medium:
        return 305;
      case GreenButtonSize.small:
        return 279;
    }
  }

  double get _sparkY {
    switch (widget.size) {
      case GreenButtonSize.long:
        return 6.97;
      case GreenButtonSize.medium:
      case GreenButtonSize.small:
        return 5.97;
    }
  }

  double get _squiggleX {
    switch (widget.size) {
      case GreenButtonSize.long:
        return 335;
      case GreenButtonSize.medium:
        return 298;
      case GreenButtonSize.small:
        return 275;
    }
  }

  double get _squiggleY {
    switch (widget.size) {
      case GreenButtonSize.long:
        return 30;
      case GreenButtonSize.medium:
      case GreenButtonSize.small:
        return 20;
    }
  }

  String get _doodleStatePath => _isDisabled ? 'disabled' : 'active';

  Color get _backgroundColor =>
      _isDisabled ? AppColors.linePrimary : AppColors.main;

  void _setPressed(bool value) {
    if (_isDisabled) {
      return;
    }

    setState(() {
      _isPressed = value;
    });
  }

  double _responsiveLeft({
    required double actualWidth,
    required double designX,
  }) {
    return math.max(0, actualWidth - (_designWidth - designX));
  }

  double _toRadians(double degree) {
    return degree * math.pi / 180;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final actualWidth = constraints.hasBoundedWidth
            ? constraints.maxWidth
            : _designWidth;

        final labelHorizontalPadding = math.min(
          _labelHorizontalPadding,
          actualWidth / 2,
        );

        return Semantics(
          button: true,
          enabled: !_isDisabled,
          label: widget.label,
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: _isDisabled ? null : widget.onTap,
            onTapDown: (_) => _setPressed(true),
            onTapUp: (_) => _setPressed(false),
            onTapCancel: () => _setPressed(false),
            child: AnimatedScale(
              scale: _isPressed ? AppInteractions.pressedScale : 1,
              duration: AppInteractions.pressedDuration,
              child: SizedBox(
                width: actualWidth,
                height: _height,
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Positioned.fill(
                      child: Container(
                        decoration: BoxDecoration(
                          color: _backgroundColor,
                          borderRadius: BorderRadius.circular(_radius),
                          boxShadow: AppShadows.base,
                        ),
                      ),
                    ),
                    Positioned(
                      left: _responsiveLeft(
                        actualWidth: actualWidth,
                        designX: _flowerX,
                      ),
                      top: _flowerY,
                      child: Transform.rotate(
                        angle: _toRadians(_flowerRotationDegree),
                        alignment: Alignment.center,
                        child: SvgPicture.asset(
                          'assets/icons/doodle/medium/'
                          '$_doodleStatePath/one_flower.svg',
                          width: _flowerWidth,
                          height: _flowerHeight,
                        ),
                      ),
                    ),
                    Positioned(
                      left: _responsiveLeft(
                        actualWidth: actualWidth,
                        designX: _sparkX,
                      ),
                      top: _sparkY,
                      child: Transform.rotate(
                        angle: _toRadians(_sparkRotationDegree),
                        alignment: Alignment.center,
                        child: SvgPicture.asset(
                          'assets/icons/doodle/medium/'
                          '$_doodleStatePath/spark_lines.svg',
                        ),
                      ),
                    ),
                    Positioned(
                      left: _responsiveLeft(
                        actualWidth: actualWidth,
                        designX: _squiggleX,
                      ),
                      top: _squiggleY,
                      child: SvgPicture.asset(
                        'assets/icons/doodle/medium/'
                        '$_doodleStatePath/squiggle_1.svg',
                      ),
                    ),
                    Positioned.fill(
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: labelHorizontalPadding,
                        ),
                        child: Center(
                          child: ExcludeSemantics(
                            child: Text(
                              widget.label,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.center,
                              style: _textStyle,
                            ),
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
