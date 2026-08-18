import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_typography.dart';
import '../../character/character.dart';
import '../../character/character_size.dart';
import '../../character/character_type.dart';

class EmptyStateCharacterMedium extends StatelessWidget {
  const EmptyStateCharacterMedium({
    super.key,
    required this.title,
    required this.description,
  });

  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Character(
          type: CharacterType.confused,
          size: CharacterSize.extraLarge,
          width: 150,
          height: 150,
        ),
        const SizedBox(height: 40),
        Text(
          title,
          textAlign: TextAlign.center,
          style: AppTypography.titleSmall.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          description,
          textAlign: TextAlign.center,
          style: AppTypography.bodyExtraLarge.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }
}
