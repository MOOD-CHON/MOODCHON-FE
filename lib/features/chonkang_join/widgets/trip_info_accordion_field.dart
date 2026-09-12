import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_shadows.dart';
import '../../../app/theme/app_typography.dart';

class TripInfoAccordionField extends StatelessWidget {
  const TripInfoAccordionField({
    super.key,
    required this.label,
    required this.expanded,
    required this.onHeaderTap,
    this.isRequired = true,
    this.child,
  });

  final String label;
  final bool expanded;
  final VoidCallback onHeaderTap;
  final bool isRequired;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    final titleColor = expanded ? AppColors.textPrimary : AppColors.grayPrimary;

    return Semantics(
      button: true,
      expanded: expanded,
      label: label,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onHeaderTap,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
          decoration: BoxDecoration(
            color: AppColors.backgroundWhite,
            borderRadius: BorderRadius.circular(16),
            boxShadow: AppShadows.base,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Flexible(
                          child: Text(
                            label,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppTypography.titleSmall.copyWith(
                              color: titleColor,
                              height: 1,
                            ),
                          ),
                        ),
                        if (isRequired) ...[
                          const SizedBox(width: 6),
                          Text(
                            '*',
                            style: AppTypography.bodyMedium.copyWith(
                              color: AppColors.statusError,
                              height: 1,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  ExcludeSemantics(
                    child: Transform.rotate(
                      angle: expanded ? 3.14159 : 0,
                      child: SvgPicture.asset(
                        'assets/icons/filter/dropdown_down_black.svg',
                        width: 12,
                        height: 12,
                        colorFilter: ColorFilter.mode(
                          titleColor,
                          BlendMode.srcIn,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              if (expanded && child != null) ...[
                const SizedBox(height: 13),
                child!,
              ],
            ],
          ),
        ),
      ),
    );
  }
}
