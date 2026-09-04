import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_typography.dart';
import '../../../core/widgets/banner/button_banner.dart';
import '../../../core/widgets/banner/character_banner.dart';
import '../../../core/widgets/banner/character_button_banner.dart';
import '../../../core/widgets/banner/info_banner.dart';
import '../../../core/widgets/banner/toast_overlay.dart';
import '../../../core/widgets/bottom_tab/bottom_tab_type.dart';
import '../../../core/widgets/button/floating/explore_floating_button.dart';
import '../../../core/widgets/navigation/bottom_tab_bar.dart';
import '../../../core/widgets/navigation/top_bar.dart';
import '../../main/pages/main_page.dart';
import '../../place_detail/data/event_detail_mock_data.dart';
import '../../place_detail/data/restaurant_detail_mock_data.dart';
import '../../place_detail/data/shopping_detail_mock_data.dart';
import '../../place_detail/data/tourism_detail_mock_data.dart';
import '../../place_detail/pages/event_detail_page.dart';
import '../../place_detail/pages/restaurant_detail_page.dart';
import '../../place_detail/pages/shopping_detail_page.dart';
import '../../place_detail/pages/tourism_detail_page.dart';
import '../models/accommodation_recommendation.dart';
import '../models/travel_room_main_data.dart';
import '../models/travel_room_plan_category.dart';
import '../models/travel_room_plan_item.dart';
import '../models/travel_room_stage.dart';
import '../widgets/accommodation/lodging_carousel.dart';
import '../widgets/accommodation/plan_card.dart';
import '../widgets/main/mood_selection_status_card.dart';
import '../widgets/main/travel_itinerary_section.dart';
import 'mood_accommodation_page.dart';
import 'mood_result_detail_page.dart';
import 'travel_accommodation_detail_page.dart';

class TravelRoomMainPage extends StatelessWidget {
  const TravelRoomMainPage({super.key, required this.data});

  final TravelRoomMainData data;

  static const double _bottomTabMinimumBottom = 22;
  static const double _bottomTabHeight = 64;

  static const double _floatingButtonGap = 22;
  static const double _toastGap = 8;

  void _handleBottomTabChanged(BuildContext context, BottomTabType tab) {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => MainPage(initialTab: tab)),
    );
  }

  double _bottomTabBottom(BuildContext context) {
    final safeBottom = MediaQuery.paddingOf(context).bottom;

    return safeBottom > _bottomTabMinimumBottom
        ? safeBottom
        : _bottomTabMinimumBottom;
  }

  double _floatingButtonBottom(BuildContext context) {
    return _bottomTabBottom(context) + _bottomTabHeight + _floatingButtonGap;
  }

  double _toastBottom(BuildContext context) {
    return _bottomTabBottom(context) + _bottomTabHeight + _toastGap;
  }

  void _requestMoodSelection(BuildContext context) {
    // TODO: 무드 선택 미완료 구성원에게 재요청 알림 API 연결

    ToastOverlay.show(
      context,
      message: '무드 선택 알림을 다시 보냈어요.',
      bottom: _toastBottom(context),
    );
  }

  void _openMoodResult(
    BuildContext context, {
    bool showAccommodationButton = true,
  }) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => MoodResultDetailPage(
          showAccommodationButton: showAccommodationButton,
        ),
      ),
    );
  }

  void _openAccommodationList(BuildContext context) {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (_) => const MoodAccommodationPage()));
  }

  void _openAccommodationDetail(
    BuildContext context,
    AccommodationRecommendation accommodation,
  ) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const TravelAccommodationDetailPage()),
    );
  }

  Future<void> _openConfirmedAccommodation(BuildContext context) async {
    final canceled = await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (_) => const TravelAccommodationDetailPage(
          mode: TravelAccommodationDetailMode.confirmed,
        ),
      ),
    );

    if (canceled != true || !context.mounted) {
      return;
    }

    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 220),
        reverseTransitionDuration: const Duration(milliseconds: 220),
        pageBuilder: (_, __, ___) {
          return TravelRoomMainPage(
            data: data.copyWith(
              stage: TravelRoomStage.accommodationRecommendation,
              clearConfirmedAccommodation: true,
            ),
          );
        },
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          final slideAnimation =
              Tween<Offset>(
                begin: const Offset(1, 0),
                end: Offset.zero,
              ).animate(
                CurvedAnimation(parent: animation, curve: Curves.easeOutCubic),
              );

          return SlideTransition(position: slideAnimation, child: child);
        },
      ),
    );
  }

  void _openPlanItem(BuildContext context, TravelRoomPlanItem item) {
    Widget? page;

    switch (item.category) {
      case TravelRoomPlanCategory.tourism:
        page = TourismDetailPage(
          data: attractionDetailMockData,
          moodMatchRate: item.moodMatchRate,
          accommodationDistanceText: item.accommodationDistanceText,
        );
        break;

      case TravelRoomPlanCategory.event:
        page = EventDetailPage(
          data: eventDetailMockData,
          moodMatchRate: item.moodMatchRate,
          accommodationDistanceText: item.accommodationDistanceText,
        );
        break;

      case TravelRoomPlanCategory.restaurant:
        page = RestaurantDetailPage(
          data: restaurantDetailMockData,
          moodMatchRate: item.moodMatchRate,
          accommodationDistanceText: item.accommodationDistanceText,
        );
        break;

      case TravelRoomPlanCategory.shopping:
        page = ShoppingDetailPage(
          data: shoppingDetailMockData,
          moodMatchRate: item.moodMatchRate,
          accommodationDistanceText: item.accommodationDistanceText,
        );
        break;

      case TravelRoomPlanCategory.accommodation:
        page = const TravelAccommodationDetailPage(
          mode: TravelAccommodationDetailMode.confirmed,
        );
        break;

      case TravelRoomPlanCategory.activity:
        return;
    }

    Navigator.of(context).push(MaterialPageRoute(builder: (_) => page!));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundPrimary,
      body: Stack(
        children: [
          SafeArea(
            bottom: false,
            child: Column(
              children: [
                TopBar(
                  type: TopBarType.date,
                  title: data.roomName,
                  date: data.travelDateText,
                  roomName: data.roomName,
                  onBack: () {
                    Navigator.of(context).pop();
                  },
                ),
                Expanded(child: _buildStageContent(context)),
              ],
            ),
          ),

          if (data.stage == TravelRoomStage.moodSelecting)
            Positioned(
              left: 16,
              right: 16,
              bottom: _floatingButtonBottom(context),
              child: ExploreFloatingButton(
                onTap: () {
                  _handleBottomTabChanged(context, BottomTabType.explore);
                },
              ),
            ),

          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: NavigationBottomTabBar(
              selectedTab: BottomTabType.home,
              onTabChanged: (tab) {
                _handleBottomTabChanged(context, tab);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStageContent(BuildContext context) {
    switch (data.stage) {
      case TravelRoomStage.moodSelecting:
        return _build61(context);

      case TravelRoomStage.accommodationRecommendation:
        return _build62(context);

      case TravelRoomStage.itineraryRecommendation:
        return _build631(context);

      case TravelRoomStage.itineraryConfirmed:
        return _build632(context);
    }
  }

  Widget _build61(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 17, 16, 190),
      child: Column(
        children: [
          const CharacterBanner(
            title: '구성원들이 무드를 선택하고 있어요.',
            caption:
                '무드 선택이 완료되면\n'
                '무드 맞춤 숙소와 일정 추천이 제공돼요.',
          ),
          const SizedBox(height: 17),
          MoodSelectionStatusCard(
            members: data.members,
            onRequestTap: () {
              _requestMoodSelection(context);
            },
          ),
        ],
      ),
    );
  }

  Widget _build62(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.only(top: 17, bottom: 120),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: CharacterButtonBanner(
              title: '우리의 무드가 완성됐어요!',
              moodName: data.moodName,
              caption: data.moodDescription,
              buttonText: '결과 자세히 보기',
              onButtonTap: () {
                _openMoodResult(context);
              },
            ),
          ),

          const SizedBox(height: 26),

          _AccommodationHeader(
            onTap: () {
              _openAccommodationList(context);
            },
          ),

          const SizedBox(height: 14),

          LodgingCarousel(
            items: data.accommodations.take(5).toList(),
            onPageChanged: (_) {},
            onDetailTap: (accommodation) {
              _openAccommodationDetail(context, accommodation);
            },
          ),

          const SizedBox(height: 24),

          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: InfoBanner(message: '숙소를 확정하면 무드촌이 맞춤 일정을 추천해드려요.'),
          ),
        ],
      ),
    );
  }

  Widget _build631(BuildContext context) {
    final accommodation = data.confirmedAccommodation;

    return SingleChildScrollView(
      padding: const EdgeInsets.only(top: 17, bottom: 120),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: CharacterButtonBanner(
              title: '우리의 무드',
              moodName: data.moodName,
              caption: data.moodDescription,
              buttonText: '결과 자세히 보기',
              onButtonTap: () {
                _openMoodResult(context, showAccommodationButton: false);
              },
            ),
          ),

          const SizedBox(height: 26),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              '우리의 숙소',
              style: AppTypography.titleMedium.copyWith(color: AppColors.black),
            ),
          ),

          const SizedBox(height: 14),

          if (accommodation != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: PlanCard(
                type: PlanCardType.lodging2,
                data: accommodation,
                summary: 'AI가 개요를 분석해 만든 한 줄 소개가 길면 이렇게 표시돼요.',
                onDetailTap: () {
                  _openConfirmedAccommodation(context);
                },
              ),
            ),

          const SizedBox(height: 26),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: ButtonBanner(
              message: '추천 일정이 도착했어요. 확인해볼까요?',
              buttonText: '추천 일정 담기',
              onButtonTap: () {
                // TODO: 8.1 구현 완료 후 연결
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _build632(BuildContext context) {
    final accommodation = data.confirmedAccommodation;

    return SingleChildScrollView(
      padding: const EdgeInsets.only(top: 17, bottom: 120),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: CharacterButtonBanner(
              title: '우리의 무드',
              moodName: data.moodName,
              caption: data.moodDescription,
              buttonText: '결과 자세히 보기',
              onButtonTap: () {
                _openMoodResult(context, showAccommodationButton: false);
              },
            ),
          ),

          const SizedBox(height: 26),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              '우리의 숙소',
              style: AppTypography.titleMedium.copyWith(color: AppColors.black),
            ),
          ),

          const SizedBox(height: 14),

          if (accommodation != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: PlanCard(
                type: PlanCardType.lodging2,
                data: accommodation,
                summary: 'AI가 개요를 분석해 만든 한 줄 소개가 길면 이렇게 표시돼요.',
                onDetailTap: () {
                  _openConfirmedAccommodation(context);
                },
              ),
            ),

          const SizedBox(height: 26),

          TravelItinerarySection(
            dayPlans: data.dayPlans,
            onDetailTap: () {
              // TODO: 전체 일정 상세 화면 구현 후 연결
            },
            onPlaceTap: (item) {
              _openPlanItem(context, item);
            },
          ),
        ],
      ),
    );
  }
}

class _AccommodationHeader extends StatelessWidget {
  const _AccommodationHeader({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Text(
              '무드 맞춤 숙소',
              style: AppTypography.titleMedium.copyWith(color: AppColors.black),
            ),
          ),
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: onTap,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  '전체 보기',
                  style: AppTypography.tabSmall.copyWith(
                    color: AppColors.grayPrimary,
                  ),
                ),
                SvgPicture.asset(
                  'assets/icons/arrow_go/arrow_go_smaller_gray.svg',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
