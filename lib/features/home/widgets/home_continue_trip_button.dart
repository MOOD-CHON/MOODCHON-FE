import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_interactions.dart';
import '../../../app/theme/app_shadows.dart';
import '../../../app/theme/app_typography.dart';
import '../models/home_trip.dart';

class HomeContinueTripButton extends StatefulWidget {
  const HomeContinueTripButton({
    super.key,
    required this.trip,
    required this.onTap,
  });

  final HomeTrip trip;
  final VoidCallback onTap;

  @override
  State<HomeContinueTripButton> createState() => _HomeContinueTripButtonState();
}

class _HomeContinueTripButtonState extends State<HomeContinueTripButton> {
  static const double _height = 59;
  static const double _radius = 50;

  bool _isPressed = false;

  void _setPressed(bool value) {
    if (_isPressed == value) {
      return;
    }

    setState(() {
      _isPressed = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: '${widget.trip.name} 계획 이어가기',
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
            height: _height,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Positioned(
                  left: 0,
                  top: 0,
                  right: 0,
                  child: Container(
                    height: _height,
                    padding: const EdgeInsets.fromLTRB(4, 4, 15, 4),
                    decoration: BoxDecoration(
                      color: AppColors.main,
                      borderRadius: BorderRadius.circular(_radius),
                      boxShadow: AppShadows.base,
                    ),
                    child: Row(
                      children: [
                        const HomeTripThumbnail(
                          width: 51,
                          height: 51,
                          borderRadius: 100,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text.rich(
                                TextSpan(
                                  children: [
                                    TextSpan(text: widget.trip.name),
                                    const TextSpan(text: ' 계획 이어가기'),
                                  ],
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: AppTypography.bodyExtraLarge.copyWith(
                                  color: AppColors.backgroundIvory,
                                  height: 1,
                                ),
                              ),
                              const SizedBox(height: 6),
                              _ContinueTripMeta(trip: widget.trip),
                            ],
                          ),
                        ),
                        const SizedBox(width: 12),
                        SvgPicture.asset(
                          'assets/icons/arrow_go/arrow_go_medium_white.svg',
                          width: 12,
                          height: 12,
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  right: 2,
                  bottom: -9,
                  child: SvgPicture.asset(
                    'assets/icons/doodle/medium/active/squiggle_1.svg',
                    width: 28.97,
                    height: 28.97,
                  ),
                ),
                Positioned(
                  left: 40,
                  top: -3,
                  child: SvgPicture.asset(
                    'assets/icons/doodle/medium/active/heart_bubble.svg',
                    width: 28.97,
                    height: 28.97,
                  ),
                ),
                if (_isPressed)
                  Positioned.fill(
                    child: IgnorePointer(
                      child: DecoratedBox(
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
  }
}

class HomeTripThumbnail extends StatelessWidget {
  const HomeTripThumbnail({
    super.key,
    this.width = 82,
    this.height = 66,
    this.borderRadius = 10,
  });

  final double width;
  final double height;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: Image.asset(
          'assets/images/home/empty_thumbnail.png',
          fit: BoxFit.cover,
          width: width,
          height: height,
        ),
      ),
    );
  }
}

class _ContinueTripMeta extends StatelessWidget {
  const _ContinueTripMeta({required this.trip});

  final HomeTrip trip;

  @override
  Widget build(BuildContext context) {
    final textStyle = AppTypography.tabSmall.copyWith(
      color: AppColors.backgroundIvory,
      height: 1,
    );

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Flexible(child: Text('다가오는 촌캉스', maxLines: 1, style: textStyle)),
        const _VerticalSeparator(color: AppColors.backgroundIvory, height: 7),
        Text('D-${trip.dDay}', maxLines: 1, style: textStyle),
        const _VerticalSeparator(color: AppColors.backgroundIvory, height: 7),
        Flexible(
          child: Text(
            trip.dateRange,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: textStyle,
          ),
        ),
      ],
    );
  }
}

class _VerticalSeparator extends StatelessWidget {
  const _VerticalSeparator({required this.color, required this.height});

  final Color color;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1,
      height: height,
      margin: const EdgeInsets.symmetric(horizontal: 5),
      color: color.withValues(alpha: 0.72),
    );
  }
}
