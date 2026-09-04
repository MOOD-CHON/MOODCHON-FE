import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_typography.dart';
import '../button/stroke/white_medium_stroke_button.dart';
import '../character/character.dart';
import '../character/character_size.dart';
import '../character/character_type.dart';

class CharacterButtonBanner extends StatelessWidget {
  const CharacterButtonBanner({
    super.key,
    required this.title,
    required this.moodName,
    required this.caption,
    required this.buttonText,
    required this.onButtonTap,
  });

  final String title;
  final String moodName;
  final String caption;
  final String buttonText;
  final VoidCallback onButtonTap;

  static const double _radius = 16;
  static const double _borderWidth = 0.3;

  static const double _horizontalPadding = 17;
  static const double _topPadding = 18;

  static const double _titleMoodGap = 8;
  static const double _moodCaptionGap = 10;
  static const double _captionButtonGap = 10;
  static const double _bottomPadding = 18;

  static const double _maxCaptionWidth = 275;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.greenTab,
        borderRadius: BorderRadius.circular(_radius),
      ),
      foregroundDecoration: BoxDecoration(
        borderRadius: BorderRadius.circular(_radius),
        border: Border.all(color: AppColors.main, width: _borderWidth),
      ),
      clipBehavior: Clip.antiAlias,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final captionWidth = math.min(
            _maxCaptionWidth,
            constraints.maxWidth - (_horizontalPadding * 2),
          );

          return Stack(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  _horizontalPadding,
                  _topPadding,
                  _horizontalPadding,
                  _bottomPadding,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: AppTypography.titleSmall.copyWith(
                        color: AppColors.black,
                      ),
                    ),

                    const SizedBox(height: _titleMoodGap),

                    Text(
                      moodName,
                      style: AppTypography.titleNav.copyWith(
                        color: AppColors.main,
                      ),
                    ),

                    const SizedBox(height: _moodCaptionGap),

                    SizedBox(
                      width: captionWidth,
                      child: Text(
                        caption,
                        style: AppTypography.captionSmall.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ),

                    const SizedBox(height: _captionButtonGap),

                    WhiteMediumStrokeButton(
                      label: buttonText,
                      onTap: onButtonTap,
                    ),
                  ],
                ),
              ),

              Positioned(
                left: 286,
                top: 2,
                child: IgnorePointer(
                  child: Transform.rotate(
                    angle: -21.49 * math.pi / 180,
                    child: const Character(
                      type: CharacterType.greeting,
                      size: CharacterSize.large,
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
