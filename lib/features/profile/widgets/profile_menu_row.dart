import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_typography.dart';

class ProfileMenuRow extends StatelessWidget {
  const ProfileMenuRow({
    super.key,
    required this.label,
    this.onTap,
    this.trailing,
    this.showArrow = false,
  });

  final String label;
  final VoidCallback? onTap;
  final Widget? trailing;
  final bool showArrow;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Text(
              label,
              style: AppTypography.captionMedium.copyWith(
                color: AppColors.textPrimary,
              ),
            ),
          ),
          if (trailing != null)
            trailing!
          else if (showArrow)
            SvgPicture.asset('assets/icons/arrow_go/arrow_go_small_black.svg'),
        ],
      ),
    );
  }
}
