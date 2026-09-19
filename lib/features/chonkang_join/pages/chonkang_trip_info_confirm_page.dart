import 'package:flutter/material.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_typography.dart';
import '../../../core/network/api_exception.dart';
import '../../../core/widgets/banner/toast_overlay.dart';
import '../../../core/widgets/button/green/green_button.dart';
import '../../../core/widgets/button/green/green_button_size.dart';
import '../../../core/widgets/character/character.dart';
import '../../../core/widgets/character/character_size.dart';
import '../../../core/widgets/character/character_type.dart';
import '../../../core/widgets/choice_chip/choice_chip_border_type.dart';
import '../../../core/widgets/choice_chip/mood_choice_chip.dart';
import '../../../core/widgets/inputs/text_field/moodchon_text_field.dart';
import '../../../core/widgets/inputs/text_field/text_field_size.dart';
import '../../../core/widgets/modal/confirm/confirm_modal.dart';
import '../../../core/widgets/modal/confirm/confirm_modal_type.dart';
import '../../../core/widgets/navigation/top_bar.dart';
import '../../create_trip/models/create_trip_date_mode.dart';
import '../../create_trip/widgets/create_trip_date_picker.dart';
import '../../create_trip/widgets/create_trip_month_picker_sheet.dart';
import '../data/chonkang_join_api.dart';
import '../models/accommodation_condition.dart';
import '../models/chonkang_trip_info.dart';
import '../models/companion_type.dart';
import '../models/desired_region.dart';
import '../models/travel_method.dart';
import '../widgets/trip_info_accordion_field.dart';
import 'chonkang_mood_select_page.dart';

enum _AccordionSection {
  name,
  date,
  memberCount,
  companion,
  method,
  region,
  conditions,
}

class ChonkangTripInfoConfirmPage extends StatefulWidget {
  const ChonkangTripInfoConfirmPage({
    super.key,
    required this.inviteCode,
    required this.tripInfo,
  });

  final String inviteCode;
  final ChonkangTripInfo tripInfo;

  @override
  State<ChonkangTripInfoConfirmPage> createState() =>
      _ChonkangTripInfoConfirmPageState();
}

class _ChonkangTripInfoConfirmPageState
    extends State<ChonkangTripInfoConfirmPage> {
  late final TextEditingController _nameController = TextEditingController(
    text: widget.tripInfo.name,
  );

  CreateTripDateMode _dateMode = CreateTripDateMode.date;
  late DateTime _visibleMonth = DateTime(
    widget.tripInfo.startDate.year,
    widget.tripInfo.startDate.month,
  );
  int? _selectedNights;
  late DateTime? _startDate = widget.tripInfo.startDate;
  late DateTime? _endDate = widget.tripInfo.endDate;
  late int _plannedMemberCount = widget.tripInfo.plannedMemberCount;
  late CompanionType _companionType = widget.tripInfo.companionType;
  late TravelMethod _travelMethod = widget.tripInfo.travelMethod;
  late DesiredRegion _desiredRegion = widget.tripInfo.desiredRegion;
  late final Set<AccommodationCondition> _accommodationConditions = {
    ...widget.tripInfo.accommodationConditions,
  };

  _AccordionSection? _expandedSection = _AccordionSection.name;
  String? _nameErrorMessage;
  bool _isSubmitting = false;

  @override
  void dispose() {
    _nameController.dispose();

    super.dispose();
  }

  void _toggleSection(_AccordionSection section) {
    setState(() {
      _expandedSection = _expandedSection == section ? null : section;
    });
  }

  bool get _hasValidDate {
    return switch (_dateMode) {
      CreateTripDateMode.date => _startDate != null && _endDate != null,
      CreateTripDateMode.range => _selectedNights != null,
    };
  }

  (DateTime, DateTime) get _resolvedDateRange {
    if (_dateMode == CreateTripDateMode.date) {
      return (_startDate!, _endDate!);
    }

    final today = DateTime.now();
    final start = DateTime(today.year, today.month, today.day);

    return (start, start.add(Duration(days: _selectedNights!)));
  }

  bool get _hasChanges {
    final original = widget.tripInfo;
    final (resolvedStart, resolvedEnd) = _hasValidDate
        ? _resolvedDateRange
        : (original.startDate, original.endDate);

    return _nameController.text.trim() != original.name ||
        resolvedStart != original.startDate ||
        resolvedEnd != original.endDate ||
        _plannedMemberCount != original.plannedMemberCount ||
        _companionType != original.companionType ||
        _travelMethod != original.travelMethod ||
        _desiredRegion != original.desiredRegion ||
        !_setEquals(
          _accommodationConditions,
          original.accommodationConditions,
        );
  }

  bool _setEquals<T>(Set<T> a, Set<T> b) {
    return a.length == b.length && a.containsAll(b);
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

      final start = _startDate;

      if (start == null || _endDate != null || date.isBefore(start)) {
        _startDate = date;
        _endDate = null;
        return;
      }

      if (DateUtils.isSameDay(date, start)) {
        _endDate = null;
        return;
      }

      final rangeLength = date.difference(start).inDays;
      if (rangeLength > 6) {
        return;
      }

      _endDate = date;
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

  Future<void> _handleSubmit() async {
    final name = _nameController.text.trim();

    if (name.isEmpty) {
      setState(() {
        _expandedSection = _AccordionSection.name;
        _nameErrorMessage = '여행 이름을 입력해주세요.';
      });

      return;
    }

    if (!_hasValidDate) {
      setState(() {
        _expandedSection = _AccordionSection.date;
      });

      return;
    }

    if (!_hasChanges) {
      _goToMoodSelect();

      return;
    }

    final confirmed = await ConfirmModal.show(
      context,
      type: ConfirmModalType.mdTwo,
      title: '여행 정보를 수정할까요?',
      description: '수정한 내용은 모든 구성원에게 동일하게 적용됩니다.',
      confirmText: '수정하기',
      cancelText: '취소',
    );

    if (confirmed != true || !mounted) {
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    final (resolvedStart, resolvedEnd) = _resolvedDateRange;

    try {
      await ChonkangJoinApi.updateTripInfo(
        widget.inviteCode,
        name: name,
        startDate: resolvedStart,
        endDate: resolvedEnd,
        plannedMemberCount: _plannedMemberCount,
        companionType: _companionType,
        travelMethod: _travelMethod,
        desiredRegion: _desiredRegion,
        accommodationConditions: _accommodationConditions,
      );

      if (!mounted) {
        return;
      }

      _goToMoodSelect();
    } on ApiException catch (error) {
      ToastOverlay.show(context, message: error.message, bottom: 96);
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }

  void _goToMoodSelect() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) =>
            ChonkangMoodSelectPage(inviteCode: widget.inviteCode),
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
              title: '촌캉스 참여하기',
              onBack: () {
                Navigator.of(context).pop();
              },
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 20, 16, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '여행 정보',
                      style: AppTypography.captionLarge.copyWith(
                        color: AppColors.main,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            '함께 떠날 촌캉스를 확인해주세요.',
                            style: AppTypography.titleMood.copyWith(
                              color: AppColors.black,
                            ),
                          ),
                        ),
                        const Character(
                          type: CharacterType.greeting,
                          size: CharacterSize.medium,
                          width: 64,
                          height: 64,
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      '수정한 정보는 구성원 모두에게 동일하게 반영돼요.',
                      style: AppTypography.descriptionMedium.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 24),
                    _buildNameField(),
                    const SizedBox(height: 16),
                    _buildDateField(),
                    const SizedBox(height: 16),
                    _buildMemberCountField(),
                    const SizedBox(height: 16),
                    _buildCompanionField(),
                    const SizedBox(height: 16),
                    _buildMethodField(),
                    const SizedBox(height: 16),
                    _buildRegionField(),
                    const SizedBox(height: 16),
                    _buildConditionsField(),
                    const SizedBox(height: 24),
                    GreenButton(
                      size: GreenButtonSize.long,
                      label: '무드 선택하러 가기',
                      onTap: _isSubmitting ? () {} : _handleSubmit,
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNameField() {
    return TripInfoAccordionField(
      label: '여행 이름',
      expanded: _expandedSection == _AccordionSection.name,
      onHeaderTap: () => _toggleSection(_AccordionSection.name),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          MoodChonTextField(
            size: MoodChonTextFieldSize.long,
            placeholder: '여행 이름을 입력해주세요.',
            controller: _nameController,
            maxLength: 20,
            hasError: _nameErrorMessage != null,
            onChanged: (_) {
              setState(() {
                _nameErrorMessage = null;
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildDateField() {
    return TripInfoAccordionField(
      label: '여행 날짜',
      expanded: _expandedSection == _AccordionSection.date,
      onHeaderTap: () => _toggleSection(_AccordionSection.date),
      child: CreateTripDatePicker(
        mode: _dateMode,
        visibleMonth: _visibleMonth,
        selectedNights: _selectedNights,
        startDate: _startDate,
        endDate: _endDate,
        onModeChanged: _changeDateMode,
        onDurationSelected: _selectDuration,
        onDateSelected: _selectDate,
        onMonthPickerTap: _showMonthPicker,
        onPreviousMonth: _goToPreviousMonth,
        onNextMonth: _goToNextMonth,
      ),
    );
  }

  Widget _buildMemberCountField() {
    return TripInfoAccordionField(
      label: '인원수',
      expanded: _expandedSection == _AccordionSection.memberCount,
      onHeaderTap: () => _toggleSection(_AccordionSection.memberCount),
      child: Wrap(
        spacing: 9,
        runSpacing: 10,
        children: List.generate(6, (index) => index + 1).map((count) {
          return MoodChoiceChip(
            label: '$count명',
            borderType: ChoiceChipBorderType.borderO,
            selected: count == _plannedMemberCount,
            onSelected: (_) {
              setState(() {
                _plannedMemberCount = count;
              });
            },
          );
        }).toList(),
      ),
    );
  }

  Widget _buildCompanionField() {
    return TripInfoAccordionField(
      label: '동행인 정보',
      expanded: _expandedSection == _AccordionSection.companion,
      onHeaderTap: () => _toggleSection(_AccordionSection.companion),
      isRequired: false,
      child: Wrap(
        spacing: 9,
        runSpacing: 10,
        children: CompanionType.values.map((type) {
          return MoodChoiceChip(
            label: type.label,
            borderType: ChoiceChipBorderType.borderO,
            selected: type == _companionType,
            onSelected: (_) {
              setState(() {
                _companionType = type;
              });
            },
          );
        }).toList(),
      ),
    );
  }

  Widget _buildMethodField() {
    return TripInfoAccordionField(
      label: '이동 방식',
      expanded: _expandedSection == _AccordionSection.method,
      onHeaderTap: () => _toggleSection(_AccordionSection.method),
      isRequired: false,
      child: Wrap(
        spacing: 9,
        runSpacing: 10,
        children: TravelMethod.values.map((method) {
          return MoodChoiceChip(
            label: method.label,
            borderType: ChoiceChipBorderType.borderO,
            selected: method == _travelMethod,
            onSelected: (_) {
              setState(() {
                _travelMethod = method;
              });
            },
          );
        }).toList(),
      ),
    );
  }

  Widget _buildRegionField() {
    return TripInfoAccordionField(
      label: '희망 지역',
      expanded: _expandedSection == _AccordionSection.region,
      onHeaderTap: () => _toggleSection(_AccordionSection.region),
      isRequired: false,
      child: Wrap(
        spacing: 9,
        runSpacing: 10,
        children: DesiredRegion.values.map((region) {
          return MoodChoiceChip(
            label: region.label,
            borderType: ChoiceChipBorderType.borderO,
            selected: region == _desiredRegion,
            onSelected: (_) {
              setState(() {
                _desiredRegion = region;
              });
            },
          );
        }).toList(),
      ),
    );
  }

  Widget _buildConditionsField() {
    return TripInfoAccordionField(
      label: '기타 숙소 조건',
      expanded: _expandedSection == _AccordionSection.conditions,
      onHeaderTap: () => _toggleSection(_AccordionSection.conditions),
      isRequired: false,
      child: Wrap(
        spacing: 9,
        runSpacing: 10,
        children: AccommodationCondition.values.map((condition) {
          final selected = _accommodationConditions.contains(condition);

          return MoodChoiceChip(
            label: condition.label,
            borderType: ChoiceChipBorderType.borderO,
            selected: selected,
            onSelected: (_) {
              setState(() {
                if (selected) {
                  _accommodationConditions.remove(condition);
                } else {
                  _accommodationConditions.add(condition);
                }
              });
            },
          );
        }).toList(),
      ),
    );
  }
}
