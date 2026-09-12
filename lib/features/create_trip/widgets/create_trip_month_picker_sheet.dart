import 'package:flutter/material.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_typography.dart';
import '../../../core/widgets/button/half/half_button.dart';
import '../../../core/widgets/button/half/half_button_type.dart';

class CreateTripMonthPickerSheet extends StatefulWidget {
  const CreateTripMonthPickerSheet({super.key, required this.initialMonth});

  final DateTime initialMonth;

  static Future<DateTime?> show(
    BuildContext context, {
    required DateTime initialMonth,
  }) {
    return showModalBottomSheet<DateTime>(
      context: context,
      backgroundColor: Colors.transparent,
      useSafeArea: false,
      builder: (_) => CreateTripMonthPickerSheet(initialMonth: initialMonth),
    );
  }

  @override
  State<CreateTripMonthPickerSheet> createState() =>
      _CreateTripMonthPickerSheetState();
}

class _CreateTripMonthPickerSheetState
    extends State<CreateTripMonthPickerSheet> {
  static const List<int> _years = [2023, 2024, 2025, 2026, 2027, 2028, 2029];
  static const List<int> _months = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12];
  static const double _pickerHeight = 215;
  static const double _itemExtent = 33;

  late int _selectedYear;
  late int _selectedMonth;
  late FixedExtentScrollController _yearController;
  late FixedExtentScrollController _monthController;

  @override
  void initState() {
    super.initState();

    _selectedYear = widget.initialMonth.year;
    _selectedMonth = widget.initialMonth.month;
    _yearController = FixedExtentScrollController(
      initialItem: _initialYearIndex,
    );
    _monthController = FixedExtentScrollController(
      initialItem: _initialMonthIndex,
    );
  }

  int get _initialYearIndex {
    final index = _years.indexOf(widget.initialMonth.year);
    return index < 0 ? 3 : index;
  }

  int get _initialMonthIndex => widget.initialMonth.month - 1;

  @override
  void dispose() {
    _yearController.dispose();
    _monthController.dispose();
    super.dispose();
  }

  void _cancel() {
    Navigator.of(context).pop();
  }

  void _complete() {
    Navigator.of(context).pop(DateTime(_selectedYear, _selectedMonth));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 422,
      width: double.infinity,
      decoration: const BoxDecoration(
        color: AppColors.backgroundWhite,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      child: SafeArea(
        top: false,
        minimum: const EdgeInsets.only(bottom: 33),
        child: Column(
          children: [
            const SizedBox(height: 7),
            Container(
              width: 57,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.linePrimary,
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            const SizedBox(height: 19),
            Text(
              '연·월을 선택해주세요',
              style: AppTypography.titleMedium.copyWith(
                color: AppColors.textPrimary,
                height: 1,
              ),
            ),
            const SizedBox(height: 38),
            SizedBox(
              height: _pickerHeight,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    height: _itemExtent,
                    margin: const EdgeInsets.symmetric(horizontal: 28),
                    decoration: BoxDecoration(
                      color: AppColors.greenTab,
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 73),
                    child: Row(
                      children: [
                        Expanded(
                          child: _PickerWheel(
                            controller: _yearController,
                            itemExtent: _itemExtent,
                            items: [for (final year in _years) '$year년'],
                            selectedIndex: _years.indexOf(_selectedYear),
                            onSelectedItemChanged: (index) {
                              setState(() {
                                _selectedYear = _years[index];
                              });
                            },
                          ),
                        ),
                        Container(
                          width: 1,
                          height: 198,
                          margin: const EdgeInsets.symmetric(horizontal: 37),
                          color: AppColors.linePrimary,
                        ),
                        Expanded(
                          child: _PickerWheel(
                            controller: _monthController,
                            itemExtent: _itemExtent,
                            items: [for (final month in _months) '$month월'],
                            selectedIndex: _selectedMonth - 1,
                            onSelectedItemChanged: (index) {
                              setState(() {
                                _selectedMonth = _months[index];
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Expanded(
                    child: HalfButton(
                      type: HalfButtonType.stroke,
                      label: '취소',
                      onTap: _cancel,
                    ),
                  ),
                  const SizedBox(width: 13),
                  Expanded(
                    child: HalfButton(
                      type: HalfButtonType.full,
                      label: '선택 완료',
                      onTap: _complete,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PickerWheel extends StatelessWidget {
  const _PickerWheel({
    required this.controller,
    required this.itemExtent,
    required this.items,
    required this.selectedIndex,
    required this.onSelectedItemChanged,
  });

  final FixedExtentScrollController controller;
  final double itemExtent;
  final List<String> items;
  final int selectedIndex;
  final ValueChanged<int> onSelectedItemChanged;

  @override
  Widget build(BuildContext context) {
    return ListWheelScrollView.useDelegate(
      controller: controller,
      itemExtent: itemExtent,
      physics: const FixedExtentScrollPhysics(),
      perspective: 0.0001,
      diameterRatio: 100,
      overAndUnderCenterOpacity: 1,
      onSelectedItemChanged: onSelectedItemChanged,
      childDelegate: ListWheelChildBuilderDelegate(
        childCount: items.length,
        builder: (context, index) {
          final distance = (index - selectedIndex).abs();
          final color = switch (distance) {
            0 => AppColors.main,
            1 || 2 => AppColors.grayPrimary,
            _ => AppColors.grayTertiary,
          };

          return Center(
            child: Text(
              items[index],
              style: AppTypography.bodyExtraLarge.copyWith(
                color: color,
                height: 1,
              ),
            ),
          );
        },
      ),
    );
  }
}
