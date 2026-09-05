import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../core/widgets/map/map_pin.dart';
import '../../models/travel_room_plan_category.dart';
import '../../models/travel_room_plan_item.dart';
import '../accommodation/plan_card.dart';

class ItineraryTimeline extends StatelessWidget {
  const ItineraryTimeline({
    super.key,
    required this.items,
    required this.onPlaceTap,
  });

  final List<TravelRoomPlanItem> items;
  final ValueChanged<TravelRoomPlanItem> onPlaceTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(items.length, (index) {
        final item = items[index];

        return Padding(
          padding: EdgeInsets.only(bottom: index == items.length - 1 ? 0 : 11),
          child: _TimelineItem(
            item: item,
            isLast: index == items.length - 1,
            onPlaceTap: onPlaceTap,
          ),
        );
      }),
    );
  }
}

class _TimelineItem extends StatelessWidget {
  const _TimelineItem({
    required this.item,
    required this.isLast,
    required this.onPlaceTap,
  });

  final TravelRoomPlanItem item;
  final bool isLast;
  final ValueChanged<TravelRoomPlanItem> onPlaceTap;

  static const double _pinWidth = 17;
  static const double _pinToContentGap = 10;

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: _pinWidth,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Align(
                  alignment: Alignment.topCenter,
                  child: MapPin(
                    number: item.order,
                    color: item.category.mapPinColor,
                  ),
                ),

                if (!isLast)
                  Positioned(
                    top: 17,
                    bottom: -11,
                    left: 8,
                    child: Container(width: 1, color: AppColors.linePrimary),
                  ),
              ],
            ),
          ),

          const SizedBox(width: _pinToContentGap),

          Expanded(
            child: item.hasPlace
                ? PlanCard(
                    type: PlanCardType.edit2,
                    planItem: item,
                    onDetailTap: () {
                      onPlaceTap(item);
                    },
                  )
                : SizedBox(
                    height: 17,
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        item.title,
                        style: AppTypography.captionMedium.copyWith(
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.w600,
                          letterSpacing: -0.12,
                        ),
                      ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
