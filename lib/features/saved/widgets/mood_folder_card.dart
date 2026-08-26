import 'package:flutter/material.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_typography.dart';
import '../../place_save/models/place_folder.dart';

class MoodFolderCard extends StatelessWidget {
  const MoodFolderCard({
    super.key,
    required this.folder,
    required this.width,
    required this.onTap,
  });

  final PlaceFolder folder;
  final double width;
  final VoidCallback onTap;

  static const double height = 124;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: SizedBox(
          width: width,
          height: height,
          child: Stack(
            fit: StackFit.expand,
            children: [
              _buildCoverImage(),

              const DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    stops: [0.4129, 1.0],
                    colors: [
                      Color.fromRGBO(0, 0, 0, 0.60),
                      Color.fromRGBO(0, 0, 0, 0.30),
                    ],
                  ),
                ),
              ),

              Positioned(
                top: 14,
                left: 12,
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 79),
                  child: Text(
                    folder.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: AppTypography.titleSmall.copyWith(
                      color: AppColors.backgroundPrimary,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCoverImage() {
    if (folder.placeCount == 0) {
      return _buildEmptyImage();
    }

    final imageUrl = folder.coverImageUrl;

    if (imageUrl == null || imageUrl.isEmpty) {
      return _buildEmptyImage();
    }

    return Image.network(
      imageUrl,
      fit: BoxFit.cover,
      errorBuilder: (_, __, ___) {
        return _buildEmptyImage();
      },
    );
  }

  Widget _buildEmptyImage() {
    return Image.asset(
      'assets/images/empty_state/empty_place_folder.png',
      fit: BoxFit.cover,
    );
  }
}
