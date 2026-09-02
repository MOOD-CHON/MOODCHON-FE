import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_typography.dart';
import '../../../core/widgets/button/stroke/stroke_button.dart';
import '../../../core/widgets/button/stroke/stroke_button_type.dart';
import '../../../core/widgets/navigation/top_bar.dart';
import '../data/mood_accommodation_mock_data.dart';
import '../models/accommodation_recommendation.dart';
import '../models/mood_accommodation_page_data.dart';
import '../widgets/accommodation/lodging_carousel.dart';
import '../widgets/accommodation/mood_accommodation_header.dart';
import '../widgets/accommodation/plan_card.dart';
import 'accommodation_search_page.dart';

class MoodAccommodationPage extends StatefulWidget {
  const MoodAccommodationPage({
    super.key,
    this.data = moodAccommodationMockData,
  });

  final MoodAccommodationPageData data;

  @override
  State<MoodAccommodationPage> createState() => _MoodAccommodationPageState();
}

class _MoodAccommodationPageState extends State<MoodAccommodationPage> {
  int _currentTopIndex = 0;

  void _onTopAccommodationChanged(int index) {
    setState(() {
      _currentTopIndex = index;
    });
  }

  void _onAccommodationDetailTap(AccommodationRecommendation accommodation) {
    // TODO: 숙소 상세 페이지 구현 후 연결
  }

  void _onDirectAccommodationSearchTap() {
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (_) => const AccommodationSearchPage()));
  }

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
              title: '무드 맞춤 숙소',
              onBack: () {
                Navigator.of(context).pop();
              },
            ),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.only(bottom: 36),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 9),

                    MoodAccommodationHeader(
                      moodName: widget.data.moodName,
                      moodTags: widget.data.moodTags,
                      travelInfo: widget.data.travelInfo,
                    ),

                    const SizedBox(height: 26),

                    _buildTopSection(),

                    const SizedBox(height: 26),

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: _DirectAccommodationBanner(
                        onButtonTap: _onDirectAccommodationSearchTap,
                      ),
                    ),

                    const SizedBox(height: 26),

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        '비슷한 숙소도 살펴보세요',
                        style: AppTypography.titleMedium.copyWith(
                          color: AppColors.black,
                        ),
                      ),
                    ),

                    const SizedBox(height: 14),

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        children: List.generate(
                          widget.data.similarAccommodations.length,
                          (index) {
                            final accommodation =
                                widget.data.similarAccommodations[index];

                            return Padding(
                              padding: EdgeInsets.only(
                                bottom:
                                    index ==
                                        widget
                                                .data
                                                .similarAccommodations
                                                .length -
                                            1
                                    ? 0
                                    : 10,
                              ),
                              child: PlanCard(
                                type: PlanCardType.lodging1,
                                data: accommodation,
                                onDetailTap: () {
                                  _onAccommodationDetailTap(accommodation);
                                },
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Text(
                  '우리 무드에 가장 잘 맞는 숙소',
                  style: AppTypography.titleMedium.copyWith(
                    color: AppColors.black,
                  ),
                ),
              ),

              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '${_currentTopIndex + 1}',
                    style: AppTypography.tabSmall.copyWith(
                      color: AppColors.main,
                    ),
                  ),
                  Text(
                    '/5',
                    style: AppTypography.tabSmall.copyWith(
                      color: AppColors.grayPrimary,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

        const SizedBox(height: 14),

        LodgingCarousel(
          items: widget.data.topAccommodations.take(5).toList(),
          onPageChanged: _onTopAccommodationChanged,
          onDetailTap: _onAccommodationDetailTap,
        ),
      ],
    );
  }
}

class _DirectAccommodationBanner extends StatelessWidget {
  const _DirectAccommodationBanner({required this.onButtonTap});

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
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SvgPicture.asset('assets/icons/banner/banner_icon_leaf.svg'),

                const SizedBox(width: 11),

                Expanded(
                  child: Text(
                    '원하는 숙소가 따로 있나요? 숙소 이름이나 주소를\n'
                    '입력하면 우리 무드와 얼마나 잘 맞는지 확인해드려요.',
                    textAlign: TextAlign.left,
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
              text: '직접 찾은 숙소 확인하기',
              onTap: onButtonTap,
            ),
          ),
        ],
      ),
    );
  }
}
