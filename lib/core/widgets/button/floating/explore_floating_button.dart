import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_interactions.dart';
import '../../../../app/theme/app_typography.dart';
import '../../border/wiggly_border.dart';
import '../go_background_button.dart';

class ExploreFloatingButton extends StatefulWidget {
  const ExploreFloatingButton({super.key, required this.onTap});

  final VoidCallback onTap;

  @override
  State<ExploreFloatingButton> createState() => _ExploreFloatingButtonState();
}

class _ExploreFloatingButtonState extends State<ExploreFloatingButton> {
  static const double _height = 61;
  static const double _radius = 20;

  static const double _horizontalPadding = 16;

  static const double _textTop = 13;
  static const double _textGap = 3;

  static const double _squiggleRightOffset = 25;
  static const double _squiggleTop = 40;

  bool _pressed = false;

  void _setPressed(bool value) {
    if (_pressed == value) {
      return;
    }

    setState(() {
      _pressed = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: '무드별 장소 둘러보기',
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTapDown: (_) {
          _setPressed(true);
        },
        onTapCancel: () {
          _setPressed(false);
        },
        onTapUp: (_) {
          _setPressed(false);
          widget.onTap();
        },
        child: AnimatedScale(
          scale: _pressed ? AppInteractions.pressedScale : 1,
          duration: AppInteractions.pressedDuration,
          child: SizedBox(
            width: double.infinity,
            height: _height,
            child: LayoutBuilder(
              builder: (context, constraints) {
                return Stack(
                  clipBehavior: Clip.none,
                  children: [
                    // 버튼 배경
                    Positioned.fill(
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          color: AppColors.main,
                          borderRadius: BorderRadius.circular(_radius),
                        ),
                      ),
                    ),

                    // 꾸불꾸불한 외곽선
                    Positioned.fill(
                      child: IgnorePointer(
                        child: CustomPaint(
                          foregroundPainter: const WigglyBorderPainter(
                            color: AppColors.main,
                            radius: _radius,
                            strokeWidth: 1,
                            amplitude: 0.9,
                            drawOutside: true,
                          ),
                        ),
                      ),
                    ),

                    // 텍스트
                    Positioned(
                      left: _horizontalPadding,
                      top: _textTop,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '무드 선택을 기다리는 동안',
                            style: AppTypography.tabSmall.copyWith(
                              color: AppColors.backgroundPrimary,
                            ),
                          ),
                          const SizedBox(height: _textGap),
                          Text(
                            '무드별 장소 둘러보기',
                            style: AppTypography.titleSmall.copyWith(
                              color: AppColors.backgroundPrimary,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Go 버튼
                    Positioned(
                      right: _horizontalPadding,
                      top: 0,
                      bottom: 0,
                      child: Center(
                        child: IgnorePointer(
                          child: GoBackgroundButton(onTap: () {}),
                        ),
                      ),
                    ),

                    // Doodle
                    // 버튼 높이 61에는 포함되지 않고,
                    // 버튼 영역 밖으로 나가도 그대로 노출
                    Positioned(
                      left: constraints.maxWidth - _squiggleRightOffset,
                      top: _squiggleTop,
                      child: IgnorePointer(
                        child: SvgPicture.asset(
                          'assets/icons/doodle/medium/active/squiggle_1.svg',
                        ),
                      ),
                    ),

                    // Click overlay
                    if (_pressed)
                      Positioned.fill(
                        child: IgnorePointer(
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              color: AppColors.backgroundWhite.withValues(
                                alpha: 0.20,
                              ),
                              borderRadius: BorderRadius.circular(_radius),
                            ),
                          ),
                        ),
                      ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
