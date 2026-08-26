import 'package:flutter/material.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_typography.dart';
import '../../../core/widgets/button/check/check_button.dart';
import '../models/place_folder.dart';

class PlaceFolderSelectItem extends StatelessWidget {
  const PlaceFolderSelectItem({
    super.key,
    required this.folder,
    required this.selected,
    required this.onTap,
  });

  final PlaceFolder folder;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CheckButton(selected: selected, onTap: onTap),

          const SizedBox(width: 13),

          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                folder.name,
                style: AppTypography.bodyExtraLarge.copyWith(
                  color: AppColors.textPrimary,
                ),
              ),

              const SizedBox(height: 2),

              Text(
                '장소 ${folder.placeCount}개',
                style: AppTypography.captionSmall.copyWith(
                  color: AppColors.graySecondary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
