import 'package:flutter/material.dart';

import '../../../app/theme/app_colors.dart';
import '../../../core/widgets/button/green/green_button.dart';
import '../../../core/widgets/button/green/green_button_size.dart';
import '../../../core/widgets/character/character.dart';
import '../../../core/widgets/character/character_size.dart';
import '../../../core/widgets/character/character_type.dart';
import '../../../core/widgets/navigation/top_bar.dart';
import '../models/create_trip_date_mode.dart';
import '../models/create_trip_form_section.dart';
import '../widgets/create_trip_date_picker.dart';
import '../widgets/create_trip_form_field.dart';
import '../widgets/create_trip_intro_header.dart';
import '../widgets/create_trip_month_picker_sheet.dart';

class CreateTripInfoPage extends StatefulWidget {
  const CreateTripInfoPage({super.key});

  @override
  State<CreateTripInfoPage> createState() => _CreateTripInfoPageState();
}

class _CreateTripInfoPageState extends State<CreateTripInfoPage> {
  final TextEditingController _nameController = TextEditingController();
  CreateTripFormSection _expandedSection = CreateTripFormSection.name;
  CreateTripDateMode _dateMode = CreateTripDateMode.date;
  DateTime _visibleMonth = DateTime(2026, 9);
  int? _selectedNights;
  DateTime? _startDate;
  DateTime? _endDate;

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _expand(CreateTripFormSection section) {
    setState(() {
      _expandedSection = section;
    });
  }

  void _goToMoodSelection() {
    // TODO: validate required fields and navigate to mood selection.
  }

  void _changeDateMode(CreateTripDateMode mode) {
    setState(() {
      _dateMode = mode;
      _endDate = null;
      if (mode == CreateTripDateMode.date) {
        _selectedNights = null;
      }
    });
  }

  void _selectDuration(int nights) {
    setState(() {
      _selectedNights = nights;
    });
  }

  void _selectDate(DateTime date) {
    setState(() {
      if (_dateMode != CreateTripDateMode.date) {
        return;
      }

      if (_startDate == null ||
          _endDate != null ||
          date.isBefore(_startDate!)) {
        _startDate = date;
        _endDate = null;
        return;
      }

      if (DateUtils.isSameDay(date, _startDate)) {
        _endDate = null;
        return;
      }

      final rangeLength = date.difference(_startDate!).inDays;
      _endDate = _startDate!.add(Duration(days: rangeLength.clamp(0, 6)));
    });
  }

  void _goToPreviousMonth() {
    setState(() {
      _visibleMonth = DateTime(_visibleMonth.year, _visibleMonth.month - 1);
    });
  }

  void _goToNextMonth() {
    setState(() {
      _visibleMonth = DateTime(_visibleMonth.year, _visibleMonth.month + 1);
    });
  }

  Future<void> _showMonthPicker() async {
    final selectedMonth = await CreateTripMonthPickerSheet.show(
      context,
      initialMonth: _visibleMonth,
    );

    if (selectedMonth == null || !mounted) {
      return;
    }

    setState(() {
      _visibleMonth = selectedMonth;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundSecondary,
      body: SafeArea(
        bottom: false,
        child: Stack(
          fit: StackFit.expand,
          children: [
            Positioned(
              left: 0,
              top: 0,
              right: 0,
              child: TopBar(
                type: TopBarType.title,
                title: '촌캉스 만들기',
                onBack: () => Navigator.of(context).pop(),
              ),
            ),
            Positioned(
              right: 2,
              top: 65,
              child: IgnorePointer(
                child: Character(
                  type: CharacterType.notebook,
                  size: CharacterSize.medium,
                  width: 89,
                  height: 89,
                ),
              ),
            ),
            Positioned.fill(
              top: 72,
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 47),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const CreateTripIntroHeader(
                      eyebrow: '여행 정보',
                      title: '어떤 촌캉스를 떠나볼까요?',
                      description: '입력한 정보는 구성원 모두에게 동일하게 반영돼요.',
                    ),
                    const SizedBox(height: 28),
                    _CreateTripInfoForm(
                      expandedSection: _expandedSection,
                      nameController: _nameController,
                      dateMode: _dateMode,
                      visibleMonth: _visibleMonth,
                      selectedNights: _selectedNights,
                      startDate: _startDate,
                      endDate: _endDate,
                      onSectionTap: _expand,
                      onDateModeChanged: _changeDateMode,
                      onDurationSelected: _selectDuration,
                      onDateSelected: _selectDate,
                      onMonthPickerTap: _showMonthPicker,
                      onPreviousMonth: _goToPreviousMonth,
                      onNextMonth: _goToNextMonth,
                    ),
                    const SizedBox(height: 34),
                    GreenButton(
                      size: GreenButtonSize.long,
                      label: '무드 선택하러 가기',
                      onTap: _goToMoodSelection,
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
}

class _CreateTripInfoForm extends StatelessWidget {
  const _CreateTripInfoForm({
    required this.expandedSection,
    required this.nameController,
    required this.dateMode,
    required this.visibleMonth,
    required this.selectedNights,
    required this.startDate,
    required this.endDate,
    required this.onSectionTap,
    required this.onDateModeChanged,
    required this.onDurationSelected,
    required this.onDateSelected,
    required this.onMonthPickerTap,
    required this.onPreviousMonth,
    required this.onNextMonth,
  });

  final CreateTripFormSection expandedSection;
  final TextEditingController nameController;
  final CreateTripDateMode dateMode;
  final DateTime visibleMonth;
  final int? selectedNights;
  final DateTime? startDate;
  final DateTime? endDate;
  final ValueChanged<CreateTripFormSection> onSectionTap;
  final ValueChanged<CreateTripDateMode> onDateModeChanged;
  final ValueChanged<int> onDurationSelected;
  final ValueChanged<DateTime> onDateSelected;
  final VoidCallback onMonthPickerTap;
  final VoidCallback onPreviousMonth;
  final VoidCallback onNextMonth;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (final section in CreateTripFormSection.values) ...[
          CreateTripFormField(
            section: section,
            expanded: expandedSection == section,
            onTap: () => onSectionTap(section),
            child: switch (section) {
              CreateTripFormSection.name => CreateTripNameField(
                controller: nameController,
              ),
              CreateTripFormSection.date => CreateTripDatePicker(
                mode: dateMode,
                visibleMonth: visibleMonth,
                selectedNights: selectedNights,
                startDate: startDate,
                endDate: endDate,
                onModeChanged: onDateModeChanged,
                onDurationSelected: onDurationSelected,
                onDateSelected: onDateSelected,
                onMonthPickerTap: onMonthPickerTap,
                onPreviousMonth: onPreviousMonth,
                onNextMonth: onNextMonth,
              ),
              _ => null,
            },
          ),
          if (section != CreateTripFormSection.values.last)
            const SizedBox(height: 16),
        ],
      ],
    );
  }
}
