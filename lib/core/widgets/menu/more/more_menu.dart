import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_shadows.dart';
import '../../../../app/theme/app_typography.dart';

class MoreMenu extends StatelessWidget {
  const MoreMenu({
    super.key,
    required this.roomName,
    this.onEditInfo,
    this.onMemberInfo,
    this.onInvite,
    this.onLeave,
  });

  final String roomName;

  final VoidCallback? onEditInfo;
  final VoidCallback? onMemberInfo;
  final VoidCallback? onInvite;
  final VoidCallback? onLeave;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 152,
      height: 126,
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 20),
      decoration: BoxDecoration(
        color: AppColors.backgroundWhite,
        borderRadius: BorderRadius.circular(22),
        boxShadow: AppShadows.base,
      ),
      child: Column(
        children: [
          _MoreMenuItem(text: '정보 수정', onTap: onEditInfo),
          const SizedBox(height: 10),
          _MoreMenuItem(text: '구성원 정보', onTap: onMemberInfo),
          const SizedBox(height: 10),
          _MoreMenuItem(text: '$roomName 초대', onTap: onInvite),
          const SizedBox(height: 10),
          _MoreMenuItem(text: '$roomName 나가기', onTap: onLeave),
        ],
      ),
    );
  }
}

class _MoreMenuItem extends StatelessWidget {
  const _MoreMenuItem({required this.text, this.onTap});

  final String text;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: SizedBox(
        width: 116,
        height: 14,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              text,
              style: AppTypography.bodyMedium.copyWith(
                color: AppColors.textPrimary,
              ),
            ),
            SvgPicture.asset(
              'assets/icons/arrow_go/arrow_go_small_black.svg',
              width: 12,
              height: 12,
            ),
          ],
        ),
      ),
    );
  }
}
