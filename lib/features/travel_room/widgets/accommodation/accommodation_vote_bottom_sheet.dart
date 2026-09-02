import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../core/widgets/button/green/green_button.dart';
import '../../../../core/widgets/button/green/green_button_size.dart';
import '../../models/vote_member.dart';

class AccommodationVoteBottomSheet extends StatelessWidget {
  const AccommodationVoteBottomSheet({super.key, required this.members});

  final List<VoteMember> members;

  static Future<void> show(
    BuildContext context, {
    required List<VoteMember> members,
  }) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: false,
      backgroundColor: Colors.transparent,
      barrierColor: AppColors.black.withValues(alpha: 0.50),
      builder: (context) {
        return AccommodationVoteBottomSheet(members: members);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(top: 12),
      decoration: const BoxDecoration(
        color: AppColors.backgroundWhite,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
      ),
      child: SafeArea(
        top: false,
        minimum: const EdgeInsets.only(bottom: 33),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.linePrimary,
                borderRadius: BorderRadius.circular(2),
              ),
            ),

            const SizedBox(height: 18),

            Text(
              '이 숙소에 투표한 구성원',
              style: AppTypography.titleMedium.copyWith(
                color: AppColors.textPrimary,
              ),
            ),

            const SizedBox(height: 20),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 19),
              child: Column(
                children: List.generate(members.length, (index) {
                  return Padding(
                    padding: EdgeInsets.only(
                      bottom: index == members.length - 1 ? 0 : 13,
                    ),
                    child: _VoteMemberItem(member: members[index]),
                  );
                }),
              ),
            ),

            const SizedBox(height: 20),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: GreenButton(
                size: GreenButtonSize.long,
                label: '확인',
                onTap: () {
                  Navigator.of(context).pop();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _VoteMemberItem extends StatelessWidget {
  const _VoteMemberItem({required this.member});

  final VoteMember member;

  static const double _profileSize = 31;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _ProfileImage(imageUrl: member.profileImageUrl),

        const SizedBox(width: 16),

        Expanded(
          child: Text(
            member.nickname?.trim().isNotEmpty == true
                ? member.nickname!
                : '사용자',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTypography.bodyExtraLarge.copyWith(
              color: AppColors.black,
            ),
          ),
        ),
      ],
    );
  }
}

class _ProfileImage extends StatelessWidget {
  const _ProfileImage({required this.imageUrl});

  final String? imageUrl;

  static const double _size = 31;

  @override
  Widget build(BuildContext context) {
    final hasImage = imageUrl != null && imageUrl!.trim().isNotEmpty;

    return ClipOval(
      child: SizedBox(
        width: _size,
        height: _size,
        child: hasImage
            ? Image.network(
                imageUrl!,
                width: _size,
                height: _size,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) {
                  return Image.asset(
                    'assets/images/empty_state/empty_profile.png',
                    width: _size,
                    height: _size,
                    fit: BoxFit.cover,
                  );
                },
              )
            : Image.asset(
                'assets/images/empty_state/empty_profile.png',
                width: _size,
                height: _size,
                fit: BoxFit.cover,
              ),
      ),
    );
  }
}
