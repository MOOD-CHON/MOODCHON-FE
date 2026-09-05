import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../core/widgets/choice_chip/day_choice_chip.dart';
import '../../models/travel_room_day_plan.dart';
import '../../models/travel_room_plan_item.dart';
import 'itinerary_timeline.dart';

class TravelItinerarySection extends StatefulWidget {
  const TravelItinerarySection({
    super.key,
    required this.dayPlans,
    required this.onDetailTap,
    required this.onPlaceTap,
  });

  final List<TravelRoomDayPlan> dayPlans;

  final VoidCallback onDetailTap;

  final ValueChanged<TravelRoomPlanItem> onPlaceTap;

  @override
  State<TravelItinerarySection> createState() => _TravelItinerarySectionState();
}

class _TravelItinerarySectionState extends State<TravelItinerarySection> {
  int _selectedDayIndex = 0;

  @override
  void didUpdateWidget(covariant TravelItinerarySection oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (_selectedDayIndex >= widget.dayPlans.length) {
      _selectedDayIndex = 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.dayPlans.isEmpty) {
      return const SizedBox.shrink();
    }

    final selectedPlan = widget.dayPlans[_selectedDayIndex];

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
                  '우리의 일정',
                  style: AppTypography.titleMedium.copyWith(
                    color: AppColors.black,
                  ),
                ),
              ),
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: widget.onDetailTap,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '자세히 보기',
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
        ),

        const SizedBox(height: 14),

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Wrap(
            spacing: 3.83,
            runSpacing: 10,
            children: List.generate(widget.dayPlans.length, (index) {
              final plan = widget.dayPlans[index];

              return DayChoiceChip(
                label: '${plan.day}일차',
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
          child: ItineraryTimeline(
            items: selectedPlan.items,
            onPlaceTap: widget.onPlaceTap,
          ),
        ),
      ],
    );
  }
}
