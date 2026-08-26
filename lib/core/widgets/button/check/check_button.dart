import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../app/theme/app_colors.dart';

class CheckButton extends StatelessWidget {
  const CheckButton({super.key, required this.selected, required this.onTap});

  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Container(
        width: 19,
        height: 19,
        decoration: BoxDecoration(
          color: selected ? AppColors.main : AppColors.backgroundWhite,
          borderRadius: BorderRadius.circular(4),
          border: Border.all(
            color: selected ? AppColors.main : AppColors.graySecondary,
            width: 1,
          ),
        ),
        alignment: Alignment.center,
        child: selected
            ? SvgPicture.asset(
                'assets/icons/check/check.svg',
                width: 11,
                height: 9,
              )
            : null,
      ),
    );
  }
}
