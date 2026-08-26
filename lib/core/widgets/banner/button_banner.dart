import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_typography.dart';
import '../button/stroke/stroke_button.dart';
import '../button/stroke/stroke_button_type.dart';

class ButtonBanner extends StatelessWidget {
  const ButtonBanner({
    super.key,
    required this.message,
    required this.buttonText,
    required this.onButtonTap,
  });

  final String message;
  final String buttonText;
  final VoidCallback onButtonTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 39, vertical: 14),
      decoration: BoxDecoration(
        color: AppColors.greenTab,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 283),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SvgPicture.asset('assets/icons/banner/banner_icon_leaf.svg'),
                const SizedBox(width: 11),
                Flexible(
                  child: Text(
                    message,
                    textAlign: TextAlign.center,
                    style: AppTypography.tabLarge.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 8),

          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 283),
            child: StrokeButton(
              type: StrokeButtonType.whiteSmall,
              text: buttonText,
              onTap: onButtonTap,
            ),
          ),
        ],
      ),
    );
  }
}
