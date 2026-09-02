import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_shadows.dart';
import '../../../app/theme/app_typography.dart';
import '../../../core/widgets/button/charge/charge_button.dart';
import '../../../core/widgets/navigation/top_bar.dart';
import '../../../core/widgets/tag/order_tag.dart';

class ProPlanPage extends StatelessWidget {
  const ProPlanPage({super.key});

  static const List<String> _freeFeatures = [
    '촌캉스 최대 6명 참여',
    '촌캉스별 공통 무드 생성',
    '촌캉스별 무드에 따른 숙소 추천',
    '숙소 기준 추천 일정 1개 제공',
    '자유로운 일정 수정',
    '저장 폴더 최대 6개 생성',
  ];

  static const List<String> _proFeatures = [
    'Free의 모든 기능 포함',
    '촌캉스 최대 10명 참여',
    '숙소 기준 추천 일정 3개 제공',
    '저장 폴더 무제한 생성',
    '촌캉네컷 기능 제공',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundSecondary,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            TopBar(
              type: TopBarType.title,
              title: '요금제 안내',
              onBack: () {
                Navigator.of(context).pop();
              },
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 30, 16, 32),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '나에게 맞는 무드촌 요금제를 확인해보세요.',
                      style: AppTypography.titleMedium.copyWith(
                        color: AppColors.textPrimary,
                      ),
                    ),

                    const SizedBox(height: 22),

                    _buildFreeCard(),

                    const SizedBox(height: 16),

                    _buildProCard(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFreeCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 24),
      decoration: BoxDecoration(
        color: AppColors.backgroundWhite,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.main, width: 1),
        boxShadow: AppShadows.base,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Free',
                style: AppTypography.titleNav.copyWith(color: AppColors.main),
              ),
              const SizedBox(width: 11),
              const OrderTag(label: '현재 이용 중'),
            ],
          ),

          const SizedBox(height: 14),

          Text(
            '₩0',
            style: AppTypography.titleMood.copyWith(
              color: AppColors.textPrimary,
            ),
          ),

          const SizedBox(height: 14),

          const _FeatureList(features: _freeFeatures),
        ],
      ),
    );
  }

  Widget _buildProCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 24),
      decoration: BoxDecoration(
        color: AppColors.greenTab,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.main, width: 1),
        boxShadow: AppShadows.base,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Pro',
                style: AppTypography.titleNav.copyWith(color: AppColors.main),
              ),
              const SizedBox(width: 11),
              Container(
                height: 23,
                padding: const EdgeInsets.symmetric(horizontal: 8),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: AppColors.backgroundPrimary,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Text(
                  '오픈 예정',
                  style: AppTypography.captionMedium.copyWith(
                    color: AppColors.main,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 18),

          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                '₩2,900',
                style: AppTypography.titleMood.copyWith(
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                '월 구독',
                style: AppTypography.bodyMap.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),

          const SizedBox(height: 18),

          const _FeatureList(features: _proFeatures),

          const SizedBox(height: 15),

          const SizedBox(
            width: double.infinity,
            child: ChargeButton(text: '오픈 예정이에요'),
          ),
        ],
      ),
    );
  }
}

class _FeatureList extends StatelessWidget {
  const _FeatureList({required this.features});

  final List<String> features;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (var index = 0; index < features.length; index++) ...[
          _PlanFeatureItem(text: features[index]),
          if (index < features.length - 1) const SizedBox(height: 9),
        ],
      ],
    );
  }
}

class _PlanFeatureItem extends StatelessWidget {
  const _PlanFeatureItem({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          width: 16,
          height: 16,
          child: SvgPicture.asset(
            'assets/icons/banner/banner_icon_leaf.svg',
            fit: BoxFit.contain,
          ),
        ),

        const SizedBox(width: 12),

        Expanded(
          child: Text(
            text,
            style: AppTypography.titleSmall.copyWith(
              color: AppColors.textSecondary,
              height: 17 / 14,
            ),
          ),
        ),
      ],
    );
  }
}
