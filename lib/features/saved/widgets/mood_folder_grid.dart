import 'package:flutter/material.dart';

import '../../place_save/models/place_folder.dart';
import 'mood_folder_card.dart';

class MoodFolderGrid extends StatelessWidget {
  const MoodFolderGrid({
    super.key,
    required this.folders,
    required this.onFolderTap,
  });

  final List<PlaceFolder> folders;
  final ValueChanged<PlaceFolder> onFolderTap;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        const columnCount = 3;
        const horizontalGap = 8.0;
        const verticalGap = 16.0;

        final itemWidth =
            (constraints.maxWidth - horizontalGap * (columnCount - 1)) /
            columnCount;

        final childAspectRatio = itemWidth / MoodFolderCard.height;

        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: EdgeInsets.zero,
          itemCount: folders.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: columnCount,
            crossAxisSpacing: horizontalGap,
            mainAxisSpacing: verticalGap,
            childAspectRatio: childAspectRatio,
          ),
          itemBuilder: (context, index) {
            final folder = folders[index];

            return MoodFolderCard(
              folder: folder,
              width: itemWidth,
              onTap: () => onFolderTap(folder),
            );
          },
        );
      },
    );
  }
}
