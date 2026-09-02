import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_typography.dart';
import '../../../features/travel_room/models/vote_member.dart';

enum VoteProfileSize { large, medium }

class VoteProfile extends StatelessWidget {
  const VoteProfile({
    super.key,
    required this.members,
    required this.size,
    this.onTap,
  });

  final List<VoteMember> members;
  final VoteProfileSize size;

  /// large + 4명 이상일 때 화살표/전체 영역 탭 용도
  final VoidCallback? onTap;

  double get _profileSize {
    switch (size) {
      case VoteProfileSize.large:
        return 24;
      case VoteProfileSize.medium:
        return 18;
    }
  }

  TextStyle get _counterStyle {
    switch (size) {
      case VoteProfileSize.large:
        return AppTypography.tabMedium;
      case VoteProfileSize.medium:
        return AppTypography.tabSmall;
    }
  }

  bool get _showArrow {
    return size == VoteProfileSize.large && members.length >= 4;
  }

  @override
  Widget build(BuildContext context) {
    if (members.isEmpty) {
      return const SizedBox.shrink();
    }

    final content = Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _buildProfiles(),

        if (_showArrow) ...[
          const SizedBox(width: 2),
          SvgPicture.asset('assets/icons/arrow_go/arrow_go_small_green.svg'),
        ],
      ],
    );

    if (!_showArrow) {
      return content;
    }

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: content,
    );
  }

  Widget _buildProfiles() {
    final int count = members.length;

    // 1~3명은 실제 프로필 수만큼 표시
    if (count <= 3) {
      final double width = _profileSize + ((_profileSize - 6) * (count - 1));

      return SizedBox(
        width: width,
        height: _profileSize,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            for (int index = 0; index < count; index++)
              Positioned(
                left: index * (_profileSize - 6),
                child: _ProfileCircle(
                  member: members[index],
                  size: _profileSize,
                ),
              ),
          ],
        ),
      );
    }

    // 4명 이상:
    // 프로필 2개 + 카운터 1개
    final double width = _profileSize + ((_profileSize - 6) * 2);

    return SizedBox(
      width: width,
      height: _profileSize,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            left: 0,
            child: _ProfileCircle(member: members[0], size: _profileSize),
          ),
          Positioned(
            left: _profileSize - 6,
            child: _ProfileCircle(member: members[1], size: _profileSize),
          ),
          Positioned(
            left: (_profileSize - 6) * 2,
            child: _CounterCircle(
              label: '+${count - 2}',
              size: _profileSize,
              style: _counterStyle,
            ),
          ),
        ],
      ),
    );
  }
}

class _ProfileCircle extends StatelessWidget {
  const _ProfileCircle({required this.member, required this.size});

  final VoteMember member;
  final double size;

  @override
  Widget build(BuildContext context) {
    final imageUrl = member.profileImageUrl?.trim();

    return ClipOval(
      child: SizedBox(
        width: size,
        height: size,
        child: imageUrl != null && imageUrl.isNotEmpty
            ? Image.network(
                imageUrl,
                width: size,
                height: size,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) {
                  return _DefaultProfile(size: size);
                },
              )
            : _DefaultProfile(size: size),
      ),
    );
  }
}

class _DefaultProfile extends StatelessWidget {
  const _DefaultProfile({required this.size});

  final double size;

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/images/empty_state/empty_profile.png',
      width: size,
      height: size,
      fit: BoxFit.cover,
    );
  }
}

class _CounterCircle extends StatelessWidget {
  const _CounterCircle({
    required this.label,
    required this.size,
    required this.style,
  });

  final String label;
  final double size;
  final TextStyle style;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: Color(0xFFF3F4E6),
      ),
      child: Text(label, style: style.copyWith(color: AppColors.main)),
    );
  }
}
