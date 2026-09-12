import 'package:flutter/material.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_typography.dart';
import '../../../core/network/api_exception.dart';
import '../../../core/widgets/banner/toast_overlay.dart';
import '../../../core/widgets/button/green/green_button.dart';
import '../../../core/widgets/button/green/green_button_size.dart';
import '../../../core/widgets/choice_chip/day_choice_chip.dart';
import '../../../core/widgets/map/map_pin.dart';
import '../../../core/widgets/navigation/top_bar.dart';
import '../data/travel_room_settings_api.dart';
import '../models/recommended_itinerary.dart';
import '../models/recommended_itinerary_mapper.dart';
import '../models/travel_room_plan_item.dart';
import '../widgets/main/itinerary_timeline.dart';

class RecommendedItineraryPage extends StatefulWidget {
  const RecommendedItineraryPage({super.key, required this.chonkangId});

  final int chonkangId;

  @override
  State<RecommendedItineraryPage> createState() =>
      _RecommendedItineraryPageState();
}

class _RecommendedItineraryPageState extends State<RecommendedItineraryPage> {
  bool _isLoading = true;
  bool _isCommitting = false;
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
      final itinerary = await TravelRoomSettingsApi.getRecommendedItinerary(
        widget.chonkangId,
      );

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
      setState(() {
        _errorMessage = error.message;
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _onPlaceTap(TravelRoomPlanItem item) {
    ToastOverlay.show(context, message: '상세 화면은 준비 중이에요.', bottom: 96);
  }

  Future<void> _handleCommit() async {
    setState(() {
      _isCommitting = true;
    });

    try {
      await TravelRoomSettingsApi.commitRecommendedItinerary(
        widget.chonkangId,
      );

      if (!mounted) {
        return;
      }

      Navigator.of(context).pop(true);
    } on ApiException catch (error) {
      ToastOverlay.show(context, message: error.message, bottom: 96);
    } finally {
      if (mounted) {
        setState(() {
          _isCommitting = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final itinerary = _itinerary;

    return Scaffold(
      backgroundColor: AppColors.backgroundPrimary,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            TopBar(
              type: TopBarType.title,
              title: '추천 일정',
              onBack: () {
                Navigator.of(context).pop();
              },
            ),
            Expanded(child: _buildBody(itinerary)),
            if (itinerary != null && !itinerary.committed)
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                child: GreenButton(
                  size: GreenButtonSize.long,
                  label: '추천 일정 담기',
                  onTap: _isCommitting ? () {} : _handleCommit,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildBody(RecommendedItinerary? itinerary) {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(color: AppColors.main),
      );
    }

    if (_errorMessage != null || itinerary == null) {
      return Center(
        child: Text(
          _errorMessage ?? '추천 일정을 불러오지 못했어요.',
          style: AppTypography.bodyExtraLarge.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
      );
    }

    if (itinerary.days.isEmpty) {
      return Center(
        child: Text(
          '아직 추천 일정이 만들어지지 않았어요.',
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

    return SingleChildScrollView(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 20, 16, 0),
            child: _ItineraryHeader(),
          ),
          const SizedBox(height: 20),
          _MapPlaceholder(items: planItems),
          const SizedBox(height: 20),
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
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: ItineraryTimeline(items: planItems, onPlaceTap: _onPlaceTap),
          ),
        ],
      ),
    );
  }
}

class _ItineraryHeader extends StatelessWidget {
  const _ItineraryHeader();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '확정된 숙소와 우리 무드를 바탕으로\n추천 일정을 만들어봤어요.',
          style: AppTypography.titleMood.copyWith(color: AppColors.black),
        ),
        const SizedBox(height: 6),
        Text(
          '일정을 담고, 활동을 추가하거나 자유롭게 수정할 수 있어요.',
          style: AppTypography.descriptionMedium.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }
}

class _MapPlaceholder extends StatelessWidget {
  const _MapPlaceholder({required this.items});

  final List<TravelRoomPlanItem> items;

  @override
  Widget build(BuildContext context) {
    final pins = items.where((item) => item.hasPlace).toList();

    return Container(
      width: double.infinity,
      height: 220,
      color: AppColors.backgroundGray,
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 8,
            runSpacing: 8,
            children: pins
                .map(
                  (item) => MapPin(
                    number: item.order,
                    color: item.displayPinColor,
                  ),
                )
                .toList(),
          ),
          const SizedBox(height: 12),
          Text(
            '지도는 준비 중이에요.',
            style: AppTypography.captionMedium.copyWith(
              color: AppColors.grayPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
