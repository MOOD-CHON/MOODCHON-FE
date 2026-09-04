import 'package:flutter/material.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_typography.dart';
import '../character/character.dart';
import '../character/character_size.dart';
import '../character/character_type.dart';

class CharacterBanner extends StatelessWidget {
  const CharacterBanner({
    super.key,
    required this.title,
    required this.caption,
  });

  final String title;
  final String caption;

  static const double _height = 96;
  static const double _radius = 16;
  static const double _borderWidth = 0.3;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: _height,
      decoration: BoxDecoration(
        color: AppColors.greenTab,
        borderRadius: BorderRadius.circular(_radius),
      ),
      foregroundDecoration: BoxDecoration(
        borderRadius: BorderRadius.circular(_radius),
        border: Border.all(color: AppColors.main, width: _borderWidth),
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          Positioned(
            left: 17,
            top: 18,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTypography.titleSmall.copyWith(
                    color: AppColors.black,
                  ),
                ),
                const SizedBox(height: 9),
                SizedBox(
                  width: 210,
                  child: Text(
                    caption,
                    style: AppTypography.captionSmall.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Positioned(
            left: 242,
            top: -4,
            child: Character(
              type: CharacterType.excited,
              size: CharacterSize.extraLarge,
            ),
          ),
        ],
      ),
    );
  }
}
