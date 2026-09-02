import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_typography.dart';
import '../../models/accommodation_search_result.dart';

class AccommodationSearchItem extends StatelessWidget {
  const AccommodationSearchItem({
    super.key,
    required this.data,
    required this.onTap,
  });

  final AccommodationSearchResult data;
  final VoidCallback onTap;

  static const double _iconAreaSize = 45;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: _iconAreaSize,
            height: _iconAreaSize,
            child: Center(
              child: SvgPicture.asset('assets/icons/search/search.svg'),
            ),
          ),

          const SizedBox(width: 5),

          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  data.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTypography.titleSmall.copyWith(
                    color: AppColors.textPrimary,
                  ),
                ),

                const SizedBox(height: 4),

                Text(
                  data.address,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTypography.tabMedium.copyWith(
                    color: AppColors.grayPrimary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
