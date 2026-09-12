import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_shadows.dart';
import '../../../app/theme/app_typography.dart';
import '../../../core/widgets/choice_chip/choice_chip_border_type.dart';
import '../../../core/widgets/choice_chip/mood_choice_chip.dart';
import '../models/create_trip_date_mode.dart';

class CreateTripDatePicker extends StatelessWidget {
  const CreateTripDatePicker({
    super.key,
    required this.mode,
    required this.visibleMonth,
    this.selectedNights,
    this.startDate,
    this.endDate,
    required this.onModeChanged,
    required this.onDurationSelected,
    required this.onDateSelected,
    required this.onMonthPickerTap,
    required this.onPreviousMonth,
    required this.onNextMonth,
  });

  final CreateTripDateMode mode;
  final DateTime visibleMonth;
  final int? selectedNights;
  final DateTime? startDate;
  final DateTime? endDate;
  final ValueChanged<CreateTripDateMode> onModeChanged;
  final ValueChanged<int> onDurationSelected;
  final ValueChanged<DateTime> onDateSelected;
  final VoidCallback onMonthPickerTap;
  final VoidCallback onPreviousMonth;
  final VoidCallback onNextMonth;

  static const List<String> _weekdays = ['일', '월', '화', '수', '목', '금', '토'];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _DateModeTab(mode: mode, onChanged: onModeChanged),
        const SizedBox(height: 13),
        Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            children: [
              _CalendarHeader(
                visibleMonth: visibleMonth,
                onMonthPickerTap: onMonthPickerTap,
                onPreviousMonth: onPreviousMonth,
                onNextMonth: onNextMonth,
              ),
              const SizedBox(height: 24),
              if (mode == CreateTripDateMode.range)
                _DurationOptions(
                  selectedNights: selectedNights,
                  onSelected: onDurationSelected,
                )
              else ...[
                Row(
                  children: [
                    for (final weekday in _weekdays)
                      Expanded(
                        child: Center(
                          child: Text(
                            weekday,
                            style: AppTypography.dateExtraSmall.copyWith(
                              color: AppColors.grayPrimary,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 16),
                _CalendarGrid(
                  visibleMonth: visibleMonth,
                  mode: mode,
                  startDate: startDate,
                  endDate: endDate,
                  onDateSelected: onDateSelected,
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _DateModeTab extends StatelessWidget {
  const _DateModeTab({required this.mode, required this.onChanged});

  final CreateTripDateMode mode;
  final ValueChanged<CreateTripDateMode> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 29,
      decoration: BoxDecoration(
        color: AppColors.backgroundWhite,
        borderRadius: BorderRadius.circular(20),
        boxShadow: AppShadows.base,
      ),
      child: Row(
        children: [
          _DateModeTabItem(
            mode: CreateTripDateMode.date,
            selected: mode == CreateTripDateMode.date,
            onTap: onChanged,
          ),
          const SizedBox(width: 15),
          _DateModeTabItem(
            mode: CreateTripDateMode.range,
            selected: mode == CreateTripDateMode.range,
            onTap: onChanged,
          ),
        ],
      ),
    );
  }
}

class _DateModeTabItem extends StatelessWidget {
  const _DateModeTabItem({
    required this.mode,
    required this.selected,
    required this.onTap,
  });

  final CreateTripDateMode mode;
  final bool selected;
  final ValueChanged<CreateTripDateMode> onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => onTap(mode),
        child: Padding(
          padding: const EdgeInsets.all(3),
          child: Container(
            height: 23,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: selected ? AppColors.greenTab : Colors.transparent,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              mode.label,
              style: AppTypography.tabLarge.copyWith(
                color: selected ? AppColors.main : AppColors.grayPrimary,
                height: 1,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _DurationOptions extends StatelessWidget {
  const _DurationOptions({
    required this.selectedNights,
    required this.onSelected,
  });

  final int? selectedNights;
  final ValueChanged<int> onSelected;

  static const _options = [
    _DurationOption(nights: 1, label: '1박 2일'),
    _DurationOption(nights: 2, label: '2박 3일'),
    _DurationOption(nights: 3, label: '3박 4일'),
    _DurationOption(nights: 4, label: '4박 5일'),
    _DurationOption(nights: 5, label: '5박 6일'),
    _DurationOption(nights: 6, label: '일주일'),
  ];

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Wrap(
        spacing: 8,
        runSpacing: 12,
        children: [
          for (final option in _options)
            MoodChoiceChip(
              label: option.label,
              borderType: ChoiceChipBorderType.borderO,
              selected: selectedNights == option.nights,
              onSelected: (_) => onSelected(option.nights),
            ),
        ],
      ),
    );
  }
}

class _DurationOption {
  const _DurationOption({required this.nights, required this.label});

  final int nights;
  final String label;
}

class _CalendarHeader extends StatelessWidget {
  const _CalendarHeader({
    required this.visibleMonth,
    required this.onMonthPickerTap,
    required this.onPreviousMonth,
    required this.onNextMonth,
  });

  final DateTime visibleMonth;
  final VoidCallback onMonthPickerTap;
  final VoidCallback onPreviousMonth;
  final VoidCallback onNextMonth;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: onMonthPickerTap,
            child: Row(
              children: [
                Text(
                  '${visibleMonth.year}년 ${visibleMonth.month}월',
                  style: AppTypography.dateLarge.copyWith(
                    color: AppColors.black,
                  ),
                ),
                const SizedBox(width: 4),
                Transform.rotate(
                  angle: 1.5707963267948966,
                  child: SvgPicture.asset(
                    'assets/icons/arrow_go/arrow_go_small_green.svg',
                    width: 12,
                    height: 12,
                    colorFilter: const ColorFilter.mode(
                      AppColors.grayPrimary,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        Row(
          children: [
            _MonthButton(label: '이전 달', turns: 2, onTap: onPreviousMonth),
            const SizedBox(width: 15),
            _MonthButton(label: '다음 달', turns: 0, onTap: onNextMonth),
          ],
        ),
      ],
    );
  }
}

class _MonthButton extends StatelessWidget {
  const _MonthButton({
    required this.label,
    required this.turns,
    required this.onTap,
  });

  final String label;
  final int turns;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: label,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: RotatedBox(
          quarterTurns: turns,
          child: SvgPicture.asset(
            'assets/icons/arrow_go/arrow_go_small_green.svg',
            width: 12,
            height: 12,
          ),
        ),
      ),
    );
  }
}

class _CalendarGrid extends StatelessWidget {
  const _CalendarGrid({
    required this.visibleMonth,
    required this.mode,
    required this.startDate,
    required this.endDate,
    required this.onDateSelected,
  });

  final DateTime visibleMonth;
  final CreateTripDateMode mode;
  final DateTime? startDate;
  final DateTime? endDate;
  final ValueChanged<DateTime> onDateSelected;

  static const double _height = 172.254;
  static const double _cellWidth = 41.86;
  static const double _cellHeight = 32.05;
  static const double _rowSpacing = 3;
  static const double _rangeHeight = 38;

  @override
  Widget build(BuildContext context) {
    final dates = _calendarDates(visibleMonth);

    return SizedBox(
      height: _height,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          ..._buildRangeBands(dates),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            clipBehavior: Clip.none,
            padding: EdgeInsets.zero,
            itemCount: dates.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7,
              mainAxisSpacing: _rowSpacing,
              childAspectRatio: _cellWidth / _cellHeight,
            ),
            itemBuilder: (context, index) {
              final date = dates[index];
              final isCurrentMonth = date.month == visibleMonth.month;
              final isStart = _isSameDay(date, startDate);
              final isEnd = _isSameDay(date, endDate);
              final isInRange = _isInSelectedRange(date);

              return _CalendarDayButton(
                date: date,
                currentMonth: isCurrentMonth,
                start: isStart,
                end: isEnd,
                inRange: isInRange,
                onTap: () => onDateSelected(date),
              );
            },
          ),
        ],
      ),
    );
  }

  List<Widget> _buildRangeBands(List<DateTime> dates) {
    if (mode != CreateTripDateMode.date ||
        startDate == null ||
        endDate == null) {
      return const [];
    }

    final startIndex = dates.indexWhere((date) => _isSameDay(date, startDate));
    final endIndex = dates.indexWhere((date) => _isSameDay(date, endDate));

    if (startIndex < 0 || endIndex < 0) {
      return const [];
    }

    final bands = <Widget>[];
    final startRow = startIndex ~/ 7;
    final endRow = endIndex ~/ 7;
    final startColumn = startIndex % 7;
    final endColumn = endIndex % 7;

    for (var row = startRow; row <= endRow; row++) {
      final left = row == startRow ? _centerX(startColumn) : 0.0;
      final right = row == endRow ? _centerX(endColumn) : _cellWidth * 7;

      bands.add(
        _CalendarRangeBand(
          top: row * (_cellHeight + _rowSpacing) + 2,
          left: left,
          width: right - left,
        ),
      );
    }

    return bands;
  }

  static double _centerX(int column) => column * _cellWidth + (_cellWidth / 2);

  bool _isInSelectedRange(DateTime date) {
    if (mode != CreateTripDateMode.date ||
        startDate == null ||
        endDate == null) {
      return false;
    }

    final value = DateUtils.dateOnly(date);
    final start = DateUtils.dateOnly(startDate!);
    final end = DateUtils.dateOnly(endDate!);

    return !value.isBefore(start) && !value.isAfter(end);
  }

  static List<DateTime> _calendarDates(DateTime month) {
    final firstDay = DateTime(month.year, month.month);
    final firstGridDay = firstDay.subtract(
      Duration(days: firstDay.weekday % 7),
    );

    return [
      for (var index = 0; index < 35; index++)
        firstGridDay.add(Duration(days: index)),
    ];
  }

  static bool _isSameDay(DateTime a, DateTime? b) {
    if (b == null) {
      return false;
    }

    return DateUtils.isSameDay(a, b);
  }
}

class _CalendarDayButton extends StatelessWidget {
  const _CalendarDayButton({
    required this.date,
    required this.currentMonth,
    required this.start,
    required this.end,
    required this.inRange,
    required this.onTap,
  });

  final DateTime date;
  final bool currentMonth;
  final bool start;
  final bool end;
  final bool inRange;
  final VoidCallback onTap;

  static const double _selectedSize = 38;
  static const double _labelHeight = 8.5;

  @override
  Widget build(BuildContext context) {
    final color = currentMonth ? AppColors.black : AppColors.grayPrimary;
    final selected = start || end;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          if (selected)
            Positioned(
              top: 2,
              left: 1.93,
              child: Container(
                width: _selectedSize,
                height: _selectedSize,
                decoration: const BoxDecoration(
                  color: AppColors.main,
                  shape: BoxShape.circle,
                ),
              ),
            ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: 32.05,
            child: Center(
              child: Text(
                '${date.day}',
                style: AppTypography.dateMedium.copyWith(
                  color: selected
                      ? AppColors.backgroundIvory
                      : inRange
                      ? AppColors.textSecondary
                      : color,
                  height: 1,
                ),
              ),
            ),
          ),
          if (selected)
            Positioned(
              top: 29.5 - (_labelHeight / 2),
              left: 0,
              right: 0,
              child: Text(
                start ? '가는 날' : '오는 날',
                textAlign: TextAlign.center,
                style: AppTypography.dateSmall.copyWith(
                  color: AppColors.backgroundIvory,
                  height: 1,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _CalendarRangeBand extends StatelessWidget {
  const _CalendarRangeBand({
    required this.top,
    required this.left,
    required this.width,
  });

  final double top;
  final double left;
  final double width;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: top,
      left: left,
      width: width,
      height: _CalendarGrid._rangeHeight,
      child: ColoredBox(color: AppColors.main.withValues(alpha: 0.16)),
    );
  }
}
