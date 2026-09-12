import 'package:flutter/material.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_typography.dart';
import '../../../core/network/api_exception.dart';
import '../../../core/widgets/banner/button_banner.dart';
import '../../../core/widgets/choice_chip/day_choice_chip.dart';
import '../../../core/widgets/map/kakao_map_view.dart';
import '../../../core/widgets/navigation/top_bar.dart';
import '../data/itinerary_api.dart';
import '../models/recommended_itinerary.dart';
import '../models/recommended_itinerary_mapper.dart';
import '../models/travel_room_plan_item.dart';
import '../widgets/main/itinerary_timeline.dart';
import 'itinerary_edit_page.dart';
import 'itinerary_place_detail_page.dart';

/// 9.1 일정 첫 화면 — 확정된 일정을 지도 + 일차별 타임라인으로 보여줍니다.
class ItineraryPage extends StatefulWidget {
  const ItineraryPage({super.key, required this.chonkangId});

  final int chonkangId;

  @override
  State<ItineraryPage> createState() => _ItineraryPageState();
}

class _ItineraryPageState extends State<ItineraryPage> {
  bool _isLoading = true;
  String? _errorMessage;
  RecommendedItinerary? _itinerary;
  int _selectedDayIndex = 0;

  @override
  void initState() {
    super.initState();

    _fetchItinerary();
  }

  Future<void> _fetchItinerary() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final itinerary = await ItineraryApi.getItinerary(widget.chonkangId);

      if (!mounted) {
        return;
      }

      setState(() {
        _itinerary = itinerary;
        if (_selectedDayIndex >= itinerary.days.length) {
          _selectedDayIndex = 0;
        }
      });
    } on ApiException catch (error) {
      if (mounted) {
        setState(() {
          _errorMessage = error.message;
        });
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _openEdit() async {
    final itinerary = _itinerary;
    if (itinerary == null) {
      return;
    }

    final changed = await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (_) => ItineraryEditPage(
          chonkangId: widget.chonkangId,
          initialDayNumber: itinerary.days[_selectedDayIndex].dayNumber,
        ),
      ),
    );

    if (changed == true) {
      await _fetchItinerary();
    }
  }

  Future<void> _openItemDetail(ItineraryItem item) async {
    if (item.place == null) {
      return;
    }

    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => ItineraryPlaceDetailPage(
          chonkangId: widget.chonkangId,
          itemId: item.itemId,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundPrimary,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            TopBar(
              type: TopBarType.title,
              title: '일정',
              onBack: () {
                Navigator.of(context).pop();
              },
            ),
            Expanded(child: _buildBody()),
          ],
        ),
      ),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(color: AppColors.main),
      );
    }

    final itinerary = _itinerary;

    if (_errorMessage != null || itinerary == null) {
      return Center(
        child: Text(
          _errorMessage ?? '일정을 불러오지 못했어요.',
          style: AppTypography.bodyExtraLarge.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
      );
    }

    if (itinerary.days.isEmpty) {
      return Center(
        child: Text(
          '아직 일정이 없어요.',
          style: AppTypography.bodyExtraLarge.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
      );
    }

    final selectedDay = itinerary.days[_selectedDayIndex];
    final planItems = selectedDay.items
        .map((item) => item.toPlanItem())
        .toList();
    final markers = _markersFor(selectedDay);

    return SingleChildScrollView(
      padding: const EdgeInsets.only(bottom: 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          KakaoMapView(markers: markers),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: ButtonBanner(
              message: '우리 여행 일정이에요.\n자유롭게 수정할 수 있어요.',
              buttonText: '일정 수정하기',
              onButtonTap: _openEdit,
            ),
          ),
          const SizedBox(height: 22),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Wrap(
              spacing: 3.83,
              runSpacing: 10,
              children: List.generate(itinerary.days.length, (index) {
                final day = itinerary.days[index];

                return DayChoiceChip(
                  label: '${day.dayNumber}일차',
                  selected: index == _selectedDayIndex,
                  onTap: () {
                    setState(() {
                      _selectedDayIndex = index;
                    });
                  },
                );
              }),
            ),
          ),
          const SizedBox(height: 25),
          if (planItems.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                '이 날에는 아직 담긴 일정이 없어요.',
                style: AppTypography.captionMedium.copyWith(
                  color: AppColors.grayPrimary,
                ),
              ),
            )
          else
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: ItineraryTimeline(
                items: planItems,
                onPlaceTap: _onPlanItemTap,
              ),
            ),
        ],
      ),
    );
  }

  List<KakaoMapMarker> _markersFor(ItineraryDay day) {
    final markers = <KakaoMapMarker>[];

    for (final item in day.items) {
      final place = item.place;
      final lat = place?.latitude;
      final lng = place?.longitude;

      if (place == null || lat == null || lng == null) {
        continue;
      }

      markers.add(
        KakaoMapMarker(
          latitude: lat,
          longitude: lng,
          number: item.order,
          color: item.toPlanItem().displayPinColor,
        ),
      );
    }

    return markers;
  }

  void _onPlanItemTap(TravelRoomPlanItem planItem) {
    final itinerary = _itinerary;
    if (itinerary == null) {
      return;
    }

    final day = itinerary.days[_selectedDayIndex];
    final match = day.items.where((item) => item.order == planItem.order);
    if (match.isEmpty) {
      return;
    }

    _openItemDetail(match.first);
  }
}
