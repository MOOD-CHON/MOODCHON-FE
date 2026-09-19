import 'package:flutter/material.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_typography.dart';
import '../../../core/network/api_exception.dart';
import '../../../core/widgets/banner/toast_overlay.dart';
import '../../../core/widgets/button/green/green_button.dart';
import '../../../core/widgets/button/green/green_button_size.dart';
import '../../../core/widgets/button/stroke/stroke_button.dart';
import '../../../core/widgets/button/stroke/stroke_button_type.dart';
import '../../../core/widgets/choice_chip/choice_chip_border_type.dart';
import '../../../core/widgets/choice_chip/mood_choice_chip.dart';
import '../../../core/widgets/inputs/text_field/moodchon_text_field.dart';
import '../../../core/widgets/inputs/text_field/text_field_size.dart';
import '../../../core/widgets/modal/confirm/confirm_modal.dart';
import '../../../core/widgets/modal/confirm/confirm_modal_type.dart';
import '../../../core/widgets/navigation/top_bar.dart';
import '../../chonkang_join/models/accommodation_condition.dart';
import '../../create_trip/models/create_trip_date_mode.dart';
import '../../create_trip/widgets/create_trip_date_picker.dart';
import '../../create_trip/widgets/create_trip_month_picker_sheet.dart';
import '../../chonkang_join/models/chonkang_trip_info.dart';
import '../../chonkang_join/models/companion_type.dart';
import '../../chonkang_join/models/desired_region.dart';
import '../../chonkang_join/models/travel_method.dart';
import '../../chonkang_join/widgets/trip_info_accordion_field.dart';
import '../data/travel_room_settings_api.dart';
import 'mood_reselect_page.dart';

enum _AccordionSection {
  name,
  date,
  memberCount,
  companion,
  method,
  region,
  conditions,
}

class EditTripInfoPage extends StatefulWidget {
  const EditTripInfoPage({super.key, required this.chonkangId});

  final int chonkangId;

  @override
  State<EditTripInfoPage> createState() => _EditTripInfoPageState();
}

class _EditTripInfoPageState extends State<EditTripInfoPage> {
  bool _isLoading = true;
  String? _loadErrorMessage;
  bool _isSubmitting = false;

  ChonkangTripInfo? _original;
  String? _moodName;

  late final TextEditingController _nameController = TextEditingController();

  CreateTripDateMode _dateMode = CreateTripDateMode.date;
  DateTime _visibleMonth = DateTime.now();
  int? _selectedNights;
  DateTime? _startDate;
  DateTime? _endDate;
  int _plannedMemberCount = 1;
  CompanionType _companionType = CompanionType.friend;
  TravelMethod _travelMethod = TravelMethod.car;
  DesiredRegion _desiredRegion = DesiredRegion.seoul;
  Set<AccommodationCondition> _accommodationConditions = {};

  bool _retakeMoodRequested = false;
  _AccordionSection? _expandedSection;
  String? _nameErrorMessage;

  @override
  void initState() {
    super.initState();

    _fetchData();
  }

  @override
  void dispose() {
    _nameController.dispose();

    super.dispose();
  }

  Future<void> _fetchData() async {
    setState(() {
      _isLoading = true;
      _loadErrorMessage = null;
    });

    try {
      final results = await Future.wait([
        TravelRoomSettingsApi.getTripInfo(widget.chonkangId),
        TravelRoomSettingsApi.getCurrentMoodName(widget.chonkangId),
      ]);

      if (!mounted) {
        return;
      }

      final tripInfo = results[0] as ChonkangTripInfo;
      final moodName = results[1] as String?;

      setState(() {
        _original = tripInfo;
        _moodName = moodName;
        _nameController.text = tripInfo.name;
        _visibleMonth = DateTime(
          tripInfo.startDate.year,
          tripInfo.startDate.month,
        );
        _startDate = tripInfo.startDate;
        _endDate = tripInfo.endDate;
        _plannedMemberCount = tripInfo.plannedMemberCount;
        _companionType = tripInfo.companionType;
        _travelMethod = tripInfo.travelMethod;
        _desiredRegion = tripInfo.desiredRegion;
        _accommodationConditions = {...tripInfo.accommodationConditions};
      });
    } on ApiException catch (error) {
      setState(() {
        _loadErrorMessage = error.message;
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _toggleSection(_AccordionSection section) {
    setState(() {
      _expandedSection = _expandedSection == section ? null : section;
    });
  }

  bool get _hasNameChange {
    final original = _original;
    if (original == null) return false;

    return _nameController.text.trim() != original.name;
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

  bool get _hasNonNameChanges {
    final original = _original;
    if (original == null) return false;

    final (resolvedStart, resolvedEnd) = _hasValidDate
        ? _resolvedDateRange
        : (original.startDate, original.endDate);

    return resolvedStart != original.startDate ||
        resolvedEnd != original.endDate ||
        _plannedMemberCount != original.plannedMemberCount ||
        _companionType != original.companionType ||
        _travelMethod != original.travelMethod ||
        _desiredRegion != original.desiredRegion ||
        !_setEquals(_accommodationConditions, original.accommodationConditions);
  }

  bool get _canSave =>
      _hasNameChange || _hasNonNameChanges || _retakeMoodRequested;

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

  Future<void> _handleRetakeMoodTap() async {
    if (!_hasNonNameChanges) {
      final confirmed = await ConfirmModal.show(
        context,
        type: ConfirmModalType.mdTwo,
        title: '정말로 무드를 다시 선택할까요?',
        description: '기존 무드 결과, 숙소 추천, 일정이 모두 초기화돼요.',
        confirmText: '수정하기',
        cancelText: '취소',
      );

      if (confirmed != true || !mounted) {
        return;
      }

      await _submitUpdate(retakeMood: true, goToMoodReselect: true);

      return;
    }

    setState(() {
      _retakeMoodRequested = !_retakeMoodRequested;
    });
  }

  Future<void> _handleSaveTap() async {
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

    if (_retakeMoodRequested) {
      final confirmed = await ConfirmModal.show(
        context,
        type: ConfirmModalType.mdTwo,
        title: '변경한 정보와 무드를 다시 반영할까요?',
        description: '기존 무드 결과, 숙소 추천, 일정이 초기화돼요.',
        confirmText: '수정하기',
        cancelText: '취소',
      );

      if (confirmed != true || !mounted) {
        return;
      }

      await _submitUpdate(retakeMood: true, goToMoodReselect: true);

      return;
    }

    if (_hasNonNameChanges) {
      final confirmed = await ConfirmModal.show(
        context,
        type: ConfirmModalType.mdTwo,
        title: '정말로 정보를 수정할까요?',
        description: '기존의 숙소 추천, 일정이 모두 초기화돼요.',
        confirmText: '수정하기',
        cancelText: '취소',
      );

      if (confirmed != true || !mounted) {
        return;
      }

      await _submitUpdate(retakeMood: false, goToMoodReselect: false);

      return;
    }

    // 이름만 바뀐 경우: 숙소 재추천이 없어서 별도 경고 모달 없이 바로 저장.
    await _submitUpdate(retakeMood: false, goToMoodReselect: false);
  }

  Future<void> _submitUpdate({
    required bool retakeMood,
    required bool goToMoodReselect,
  }) async {
    setState(() {
      _isSubmitting = true;
    });

    final (resolvedStart, resolvedEnd) = _resolvedDateRange;

    try {
      final result = await TravelRoomSettingsApi.updateInfo(
        widget.chonkangId,
        name: _nameController.text.trim(),
        startDate: resolvedStart,
        endDate: resolvedEnd,
        plannedMemberCount: _plannedMemberCount,
        companionType: _companionType,
        travelMethod: _travelMethod,
        desiredRegion: _desiredRegion,
        accommodationConditions: _accommodationConditions,
        retakeMood: retakeMood,
      );

      if (!mounted) {
        return;
      }

      if (goToMoodReselect && result.needsMoodReselect) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (_) => MoodReselectPage(chonkangId: widget.chonkangId),
          ),
        );

        return;
      }

      Navigator.of(context).pop();
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
              title: '정보 수정',
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

    if (_loadErrorMessage != null || _original == null) {
      return Center(
        child: Text(
          _loadErrorMessage ?? '정보를 불러오지 못했어요.',
          style: AppTypography.bodyExtraLarge.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '여행 계획이 달라졌나요?',
            style: AppTypography.captionLarge.copyWith(color: AppColors.main),
          ),
          const SizedBox(height: 8),
          Text(
            '변경된 정보를 수정해주세요.',
            style: AppTypography.titleMood.copyWith(color: AppColors.black),
          ),
          const SizedBox(height: 6),
          Text(
            '여행 이름을 제외한 정보를 변경하면 숙소 추천이 다시 진행돼요.',
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
          const SizedBox(height: 16),
          _buildMoodField(),
          const SizedBox(height: 24),
          GreenButton(
            size: GreenButtonSize.long,
            label: '변경사항 저장하기',
            disabled: !_canSave,
            onTap: (!_canSave || _isSubmitting) ? () {} : _handleSaveTap,
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildNameField() {
    return TripInfoAccordionField(
      label: '여행 이름',
      expanded: _expandedSection == _AccordionSection.name,
      onHeaderTap: () => _toggleSection(_AccordionSection.name),
      child: MoodChonTextField(
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

  String get _moodFieldText {
    if (_retakeMoodRequested) {
      return '다시 선택한 무드가 반영될 예정이에요.';
    }

    return _moodName ?? '아직 무드가 정해지지 않았어요.';
  }

  Widget _buildMoodField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            style: AppTypography.titleSmall.copyWith(color: AppColors.black),
            children: [
              const TextSpan(text: '우리의 무드'),
              TextSpan(
                text: ' *',
                style: TextStyle(color: AppColors.statusError),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: AppColors.backgroundWhite,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: AppColors.linePrimary, width: 1.2),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _moodFieldText,
                style: AppTypography.bodyExtraLarge.copyWith(
                  color: AppColors.black,
                ),
              ),
              const SizedBox(height: 12),
              StrokeButton(
                type: StrokeButtonType.whiteSmall,
                text: _retakeMoodRequested ? '다시 선택 취소하기' : '무드 다시 선택하기',
                onTap: _handleRetakeMoodTap,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
