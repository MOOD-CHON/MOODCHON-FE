import 'package:flutter/material.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_shadows.dart';
import '../../../app/theme/app_typography.dart';
import '../../../core/widgets/tag/facilities_tag.dart';
import '../models/room_info.dart';

class AccommodationRoomCard extends StatelessWidget {
  const AccommodationRoomCard({
    super.key,
    required this.room,
    this.expandHeight = false,
  });

  final RoomInfo room;
  final bool expandHeight;

  bool get _hasMetaInfo =>
      room.roomCount != null ||
      room.standardCapacity != null ||
      room.maximumCapacity != null;

  bool get _hasPrice =>
      _hasValue(room.offSeasonWeekdayPrice) ||
      _hasValue(room.offSeasonWeekendPrice) ||
      _hasValue(room.peakSeasonWeekdayPrice) ||
      _hasValue(room.peakSeasonWeekendPrice);

  bool _hasValue(String? value) {
    return value != null && value.trim().isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 189,
      height: expandHeight ? double.infinity : null,
      decoration: BoxDecoration(
        color: AppColors.backgroundWhite,
        borderRadius: BorderRadius.circular(16),
        boxShadow: AppShadows.card,
      ),
      child: Column(
        mainAxisSize: expandHeight ? MainAxisSize.max : MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 8),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: _RoomImage(imagePath: room.imagePath),
          ),

          const SizedBox(height: 12),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  room.name,
                  style: AppTypography.titleSmall.copyWith(
                    color: AppColors.textPrimary,
                  ),
                ),

                if (_hasMetaInfo) ...[
                  const SizedBox(height: 4),
                  _RoomMetaInfo(
                    roomCount: room.roomCount,
                    standardCapacity: room.standardCapacity,
                    maximumCapacity: room.maximumCapacity,
                  ),
                ],

                if (_hasPrice) ...[
                  const SizedBox(height: 14),
                  const _RoomSectionTitle(label: '객실 가격'),
                  const SizedBox(height: 6),

                  if (_hasValue(room.offSeasonWeekdayPrice))
                    _PriceRow(
                      label: '비수기 주중 최소',
                      value: room.offSeasonWeekdayPrice!,
                    ),

                  if (_hasValue(room.offSeasonWeekendPrice)) ...[
                    const SizedBox(height: 4),
                    _PriceRow(
                      label: '비수기 주말 최소',
                      value: room.offSeasonWeekendPrice!,
                    ),
                  ],

                  if (_hasValue(room.peakSeasonWeekdayPrice)) ...[
                    const SizedBox(height: 4),
                    _PriceRow(
                      label: '성수기 주중 최소',
                      value: room.peakSeasonWeekdayPrice!,
                    ),
                  ],

                  if (_hasValue(room.peakSeasonWeekendPrice)) ...[
                    const SizedBox(height: 4),
                    _PriceRow(
                      label: '성수기 주말 최소',
                      value: room.peakSeasonWeekendPrice!,
                    ),
                  ],
                ],

                if (room.facilities.isNotEmpty) ...[
                  const SizedBox(height: 14),
                  const _RoomSectionTitle(label: '객실 시설'),
                  const SizedBox(height: 6),

                  SizedBox(
                    width: 159,
                    child: Wrap(
                      spacing: 7,
                      runSpacing: 7,
                      children: room.facilities
                          .map(
                            (facility) => FacilitiesTag.small(label: facility),
                          )
                          .toList(),
                    ),
                  ),
                ],
              ],
            ),
          ),

          const SizedBox(height: 12),
        ],
      ),
    );
  }
}

class _RoomImage extends StatelessWidget {
  const _RoomImage({required this.imagePath});

  final String? imagePath;

  @override
  Widget build(BuildContext context) {
    final hasImage = imagePath != null && imagePath!.trim().isNotEmpty;

    return ClipRRect(
      borderRadius: BorderRadius.circular(14),
      child: SizedBox(
        width: 173,
        height: 118,
        child: hasImage
            ? Image.asset(imagePath!, fit: BoxFit.cover)
            : const ColoredBox(color: AppColors.linePrimary),
      ),
    );
  }
}

class _RoomMetaInfo extends StatelessWidget {
  const _RoomMetaInfo({
    required this.roomCount,
    required this.standardCapacity,
    required this.maximumCapacity,
  });

  final int? roomCount;
  final int? standardCapacity;
  final int? maximumCapacity;

  @override
  Widget build(BuildContext context) {
    final items = <String>[
      if (roomCount != null) '객실 수 $roomCount',
      if (standardCapacity != null) '기준 ${standardCapacity}인',
      if (maximumCapacity != null) '최대 ${maximumCapacity}인',
    ];

    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        for (var index = 0; index < items.length; index++) ...[
          Text(
            items[index],
            style: AppTypography.tabSmall.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          if (index < items.length - 1) ...[
            const SizedBox(width: 6),
            const _MetaDivider(),
            const SizedBox(width: 6),
          ],
        ],
      ],
    );
  }
}

class _MetaDivider extends StatelessWidget {
  const _MetaDivider();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 2,
      height: 9,
      decoration: BoxDecoration(
        color: AppColors.linePrimary,
        borderRadius: BorderRadius.circular(999),
      ),
    );
  }
}

class _RoomSectionTitle extends StatelessWidget {
  const _RoomSectionTitle({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: const TextStyle(
        fontFamily: 'Pretendard',
        fontSize: 10,
        fontWeight: FontWeight.w600,
        height: 1,
        letterSpacing: 0,
        color: AppColors.textPrimary,
      ),
    );
  }
}

class _PriceRow extends StatelessWidget {
  const _PriceRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTypography.tabSmall.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(width: 4),
        Flexible(
          child: Text(
            value,
            style: AppTypography.tabSmall.copyWith(
              color: AppColors.textPrimary,
            ),
          ),
        ),
      ],
    );
  }
}
