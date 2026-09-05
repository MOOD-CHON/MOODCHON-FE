import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_interactions.dart';
import '../../../app/theme/app_shadows.dart';
import '../../../app/theme/app_typography.dart';
import '../../../core/widgets/border/wiggly_border.dart';
import '../../../core/widgets/character/character.dart';
import '../../../core/widgets/character/character_size.dart';
import '../../../core/widgets/character/character_type.dart';
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
                Positioned.fill(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: AppColors.main,
                      borderRadius: BorderRadius.circular(_radius),
                      boxShadow: AppShadows.base,
                    ),
                  ),
                ),
                Positioned.fill(
                  child: IgnorePointer(
                    child: CustomPaint(
                      foregroundPainter: const WigglyBorderPainter(
                        color: AppColors.main,
                        radius: _radius,
                        strokeWidth: 1,
                        amplitude: 0.8,
                        drawOutside: true,
                      ),
                    ),
                  ),
                ),
                Positioned(left: 4, top: 4, child: _TripThumbnail(size: 51)),
                Positioned(
                  left: 63,
                  top: 13,
                  right: 46,
                  child: Column(
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
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        '다가오는 촌캉스   D-${widget.trip.dDay}   ${widget.trip.dateRange}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTypography.tabSmall.copyWith(
                          color: AppColors.backgroundIvory,
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  right: 16,
                  top: 0,
                  bottom: 0,
                  child: Center(
                    child: SvgPicture.asset(
                      'assets/icons/arrow_go/arrow_go_medium_white.svg',
                      width: 12,
                      height: 12,
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
  const HomeTripThumbnail({super.key, this.width = 82, this.height = 66});

  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: FittedBox(
          fit: BoxFit.cover,
          child: _TripThumbnail(size: width),
        ),
      ),
    );
  }
}

class _TripThumbnail extends StatelessWidget {
  const _TripThumbnail({required this.size});

  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      color: const Color(0xFFF3F4E6),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            left: size * 0.14,
            top: size * 0.14,
            child: Character(
              type: CharacterType.defaultCharacter,
              size: CharacterSize.small,
              width: size * 0.65,
              height: size * 0.65,
            ),
          ),
        ],
      ),
    );
  }
}
