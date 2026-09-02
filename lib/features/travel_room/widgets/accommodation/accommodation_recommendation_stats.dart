import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../core/widgets/profile/vote_profile.dart';
import '../../models/vote_member.dart';

class AccommodationRecommendationStats extends StatelessWidget {
  const AccommodationRecommendationStats({
    super.key,
    required this.matchRate,
    required this.voters,
    required this.onVoteProfileTap,
    this.recommendationRank,
  });

  final int matchRate;
  final int? recommendationRank;
  final List<VoteMember> voters;
  final VoidCallback onVoteProfileTap;

  static const double _itemWidth = 74;
  static const double _itemHeight = 45;
  static const double _dividerWidth = 0.8;

  bool get _hasRank => recommendationRank != null;
  bool get _hasVoters => voters.isNotEmpty;

  TextStyle get _secondaryTextStyle {
    return AppTypography.bodyExtraLarge.copyWith(
      color: AppColors.textSecondary,
      height: 1,
    );
  }

  double _measureTextWidth(String text) {
    final painter = TextPainter(
      text: TextSpan(text: text, style: _secondaryTextStyle),
      maxLines: 1,
      textDirection: TextDirection.ltr,
    )..layout();

    return painter.width;
  }

  double get _twoLineNoVoteWidth {
    final double firstLineWidth = _measureTextWidth('투표한');

    final double secondLineWidth = _measureTextWidth('구성원이 없어요');

    final double longestWidth = firstLineWidth > secondLineWidth
        ? firstLineWidth
        : secondLineWidth;

    // 마지막 글자 잘림 방지용 안전 여유
    return longestWidth + 2;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: _itemHeight,
      child: LayoutBuilder(
        builder: (context, constraints) {
          if (_hasRank && _hasVoters) {
            return _buildRankAndVote(constraints.maxWidth);
          }

          if (_hasRank && !_hasVoters) {
            return _buildRankWithoutVote(constraints.maxWidth);
          }

          if (!_hasRank && _hasVoters) {
            return _buildVoteWithoutRank(constraints.maxWidth);
          }

          return _buildMatchWithoutVote(constraints.maxWidth);
        },
      ),
    );
  }

  /// 1.
  /// 무드 적합도 + 추천 순위 + 구성원 투표
  Widget _buildRankAndVote(double width) {
    final double gap = ((width - (_itemWidth * 3) - (_dividerWidth * 2)) / 4)
        .clamp(0.0, 26.5)
        .toDouble();

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _MatchRate(rate: matchRate),

        SizedBox(width: gap),

        const _StatsDivider(),

        SizedBox(width: gap),

        _Rank(rank: recommendationRank!),

        SizedBox(width: gap),

        const _StatsDivider(),

        SizedBox(width: gap),

        _Vote(voters: voters, onTap: onVoteProfileTap),
      ],
    );
  }

  /// 2.
  /// 무드 적합도 + 추천 순위 + 투표한 구성원 없음
  Widget _buildRankWithoutVote(double width) {
    final double noVoteWidth = _twoLineNoVoteWidth;

    final double gap =
        ((width - (_itemWidth * 2) - noVoteWidth - (_dividerWidth * 2)) / 4)
            .clamp(0.0, 22.75)
            .toDouble();

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _MatchRate(rate: matchRate),

        SizedBox(width: gap),

        const _StatsDivider(),

        SizedBox(width: gap),

        _Rank(rank: recommendationRank!),

        SizedBox(width: gap),

        const _StatsDivider(),

        SizedBox(width: gap),

        SizedBox(
          width: noVoteWidth,
          height: _itemHeight,
          child: _NoVoteText(
            text: '투표한\n구성원이 없어요',
            maxLines: 2,
            style: _secondaryTextStyle,
          ),
        ),
      ],
    );
  }

  /// 3.
  /// 무드 적합도 + 투표한 구성원 없음
  Widget _buildMatchWithoutVote(double width) {
    const double sidePadding = 23;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: sidePadding),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _MatchRate(rate: matchRate),

          // 남는 공간 안에서
          // 세로선의 왼쪽/오른쪽 간격을 동일하게 사용
          Expanded(
            child: Row(
              children: [
                const Expanded(child: SizedBox()),

                const _StatsDivider(),

                const Expanded(child: SizedBox()),
              ],
            ),
          ),

          // 고정 너비 X
          // 텍스트가 실제 필요한 너비만큼 사용
          Text(
            '투표한 구성원이 없어요',
            maxLines: 1,
            softWrap: false,
            textAlign: TextAlign.center,
            style: _secondaryTextStyle,
          ),
        ],
      ),
    );
  }

  /// 4.
  /// 무드 적합도 + 구성원 투표
  Widget _buildVoteWithoutRank(double width) {
    const double sidePadding = 44;

    final double gap =
        ((width - (sidePadding * 2) - (_itemWidth * 2) - _dividerWidth) / 2)
            .clamp(0.0, 46.0)
            .toDouble();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: sidePadding),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _MatchRate(rate: matchRate),

          SizedBox(width: gap),

          const _StatsDivider(),

          SizedBox(width: gap),

          _Vote(voters: voters, onTap: onVoteProfileTap),
        ],
      ),
    );
  }
}

class _MatchRate extends StatelessWidget {
  const _MatchRate({required this.rate});

  final int rate;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 74,
      height: 45,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            '$rate%',
            textAlign: TextAlign.center,
            style: AppTypography.bodyPlace.copyWith(
              color: AppColors.main,
              height: 1,
            ),
          ),

          const SizedBox(height: 4),

          Text(
            '무드 적합도',
            maxLines: 1,
            textAlign: TextAlign.center,
            style: AppTypography.bodyExtraLarge.copyWith(
              color: AppColors.textSecondary,
              height: 1,
            ),
          ),
        ],
      ),
    );
  }
}

class _Rank extends StatelessWidget {
  const _Rank({required this.rank});

  final int rank;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 74,
      height: 45,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            '$rank위',
            textAlign: TextAlign.center,
            style: AppTypography.bodyPlace.copyWith(
              color: AppColors.main,
              height: 1,
            ),
          ),

          const SizedBox(height: 4),

          Text(
            '추천 순위',
            maxLines: 1,
            textAlign: TextAlign.center,
            style: AppTypography.bodyExtraLarge.copyWith(
              color: AppColors.textSecondary,
              height: 1,
            ),
          ),
        ],
      ),
    );
  }
}

class _Vote extends StatelessWidget {
  const _Vote({required this.voters, required this.onTap});

  final List<VoteMember> voters;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final bool canOpen = voters.length >= 4;

    return SizedBox(
      width: 74,
      height: 45,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: canOpen ? onTap : null,
            child: SizedBox(
              width: 74,
              child: Center(
                child: VoteProfile(
                  members: voters,
                  size: VoteProfileSize.large,
                ),
              ),
            ),
          ),

          const SizedBox(height: 4),

          Text(
            '구성원 투표',
            maxLines: 1,
            textAlign: TextAlign.center,
            style: AppTypography.bodyExtraLarge.copyWith(
              color: AppColors.textSecondary,
              height: 1,
            ),
          ),
        ],
      ),
    );
  }
}

class _NoVoteText extends StatelessWidget {
  const _NoVoteText({
    required this.text,
    required this.maxLines,
    required this.style,
  });

  final String text;
  final int maxLines;
  final TextStyle style;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        text,
        maxLines: maxLines,
        textAlign: TextAlign.center,
        style: style,
      ),
    );
  }
}

class _StatsDivider extends StatelessWidget {
  const _StatsDivider();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 0.8,
      height: 45,
      color: AppColors.linePrimary.withValues(alpha: 0.7),
    );
  }
}
