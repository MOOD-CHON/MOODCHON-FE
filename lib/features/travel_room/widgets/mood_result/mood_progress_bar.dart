import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';

class MoodProgressBar extends StatelessWidget {
  const MoodProgressBar({
    super.key,
    required this.totalCount,
    required this.selectedCount,
  }) : assert(totalCount >= 1 && totalCount <= 6),
       assert(selectedCount >= 0 && selectedCount <= totalCount);

  final int totalCount;
  final int selectedCount;

  static const double _height = 9;
  static const double _gap = 2.8;
  static const double _radius = 20;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final double width = constraints.maxWidth;

        final double segmentWidth =
            (width - (_gap * (totalCount - 1))) / totalCount;

        return SizedBox(
          width: width,
          height: _height,
          child: Row(
            children: List.generate(totalCount, (index) {
              final bool selected = index < selectedCount;

              return Padding(
                padding: EdgeInsets.only(
                  right: index == totalCount - 1 ? 0 : _gap,
                ),
                child: Container(
                  width: segmentWidth,
                  height: _height,
                  decoration: BoxDecoration(
                    color: selected
                        ? AppColors.greenProgress
                        : AppColors.grayProgress,
                    borderRadius: _borderRadiusFor(index),
                  ),
                ),
              );
            }),
          ),
        );
      },
    );
  }

  BorderRadius _borderRadiusFor(int index) {
    if (totalCount == 1) {
      return BorderRadius.circular(_radius);
    }

    if (index == 0) {
      return const BorderRadius.horizontal(left: Radius.circular(_radius));
    }

    if (index == totalCount - 1) {
      return const BorderRadius.horizontal(right: Radius.circular(_radius));
    }

    return BorderRadius.zero;
  }
}
