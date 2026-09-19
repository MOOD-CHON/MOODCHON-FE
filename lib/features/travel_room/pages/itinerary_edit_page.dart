import 'package:flutter/material.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_shadows.dart';
import '../../../app/theme/app_typography.dart';
import '../../../core/network/api_exception.dart';
import '../../../core/widgets/banner/toast_overlay.dart';
import '../../../core/widgets/button/green/green_button.dart';
import '../../../core/widgets/button/green/green_button_size.dart';
import '../../../core/widgets/button/stroke/white_medium_stroke_button.dart';
import '../../../core/widgets/choice_chip/day_choice_chip.dart';
import '../../../core/widgets/map/map_pin.dart';
import '../../../core/widgets/modal/confirm/confirm_modal.dart';
import '../../../core/widgets/modal/confirm/confirm_modal_type.dart';
import '../../../core/widgets/navigation/top_bar.dart';
import '../../../core/widgets/tag/map_tag.dart';
import '../data/itinerary_api.dart';
import '../models/recommended_itinerary.dart';
import '../models/recommended_itinerary_mapper.dart';
import 'add_itinerary_item_page.dart';

/// 9.2 일정 수정하기 — 일차별 항목 순서 변경 / 삭제 / 추가.
class ItineraryEditPage extends StatefulWidget {
  const ItineraryEditPage({
    super.key,
    required this.chonkangId,
    required this.initialDayNumber,
  });

  final int chonkangId;
  final int initialDayNumber;

  @override
  State<ItineraryEditPage> createState() => _ItineraryEditPageState();
}

class _ItineraryEditPageState extends State<ItineraryEditPage> {
  bool _isLoading = true;
  bool _isSaving = false;
  String? _errorMessage;

  /// 일차 번호 → 작업 중인 항목 목록.
  final Map<int, List<ItineraryItem>> _workingDays = {};

  /// 일차 번호 → 서버 기준 원본 itemId 순서.
  final Map<int, List<int>> _originalOrder = {};

  List<int> _dayNumbers = [];
  int _selectedDay = 1;

  /// 저장 후 호출자에게 "바뀐 게 있다"고 알릴지 여부.
  bool _committedAnyChange = false;

  bool get _isDirty {
    for (final dayNumber in _dayNumbers) {
      final current = _workingDays[dayNumber]
          ?.map((item) => item.itemId)
          .toList();
      if (current == null) {
        continue;
      }
      if (!_listEquals(current, _originalOrder[dayNumber] ?? const [])) {
        return true;
      }
    }
    return false;
  }

  bool _listEquals(List<int> a, List<int> b) {
    if (a.length != b.length) {
      return false;
    }
    for (var i = 0; i < a.length; i++) {
      if (a[i] != b[i]) {
        return false;
      }
    }
    return true;
  }

  @override
  void initState() {
    super.initState();

    _selectedDay = widget.initialDayNumber;
    _fetch();
  }

  Future<void> _fetch() async {
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
        _workingDays
          ..clear()
          ..addEntries(
            itinerary.days.map(
              (day) => MapEntry(day.dayNumber, List<ItineraryItem>.from(day.items)),
            ),
          );
        _originalOrder
          ..clear()
          ..addEntries(
            itinerary.days.map(
              (day) => MapEntry(
                day.dayNumber,
                day.items.map((item) => item.itemId).toList(),
              ),
            ),
          );
        _dayNumbers = itinerary.days.map((day) => day.dayNumber).toList();
        if (!_dayNumbers.contains(_selectedDay) && _dayNumbers.isNotEmpty) {
          _selectedDay = _dayNumbers.first;
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

  Future<void> _flushPendingOrder() async {
    for (final dayNumber in _dayNumbers) {
      final current =
          _workingDays[dayNumber]?.map((item) => item.itemId).toList() ??
          const [];
      if (current.isEmpty) {
        continue;
      }
      if (_listEquals(current, _originalOrder[dayNumber] ?? const [])) {
        continue;
      }

      await ItineraryApi.reorderDay(
        widget.chonkangId,
        dayNumber: dayNumber,
        itemIds: current,
      );
      _originalOrder[dayNumber] = current;
      _committedAnyChange = true;
    }
  }

  void _onReorderItem(int oldIndex, int newIndex) {
    setState(() {
      final items = _workingDays[_selectedDay]!;
      final moved = items.removeAt(oldIndex);
      items.insert(newIndex, moved);
    });
  }

  Future<void> _handleDelete(ItineraryItem item) async {
    final confirmed = await ConfirmModal.show(
      context,
      type: ConfirmModalType.sbTwo,
      title: '정말 일정을 삭제할까요?',
      description: '삭제한 일정은 되돌릴 수 없어요.',
      confirmText: '삭제하기',
    );

    if (confirmed != true || !mounted) {
      return;
    }

    try {
      await ItineraryApi.deleteItem(widget.chonkangId, item.itemId);

      if (!mounted) {
        return;
      }

      setState(() {
        _workingDays[_selectedDay]!
            .removeWhere((entry) => entry.itemId == item.itemId);
        _originalOrder[_selectedDay] =
            _workingDays[_selectedDay]!.map((entry) => entry.itemId).toList();
        _committedAnyChange = true;
      });
    } on ApiException catch (error) {
      if (mounted) {
        ToastOverlay.show(context, message: error.message, bottom: 40);
      }
    }
  }

  Future<void> _handleAdd() async {
    try {
      await _flushPendingOrder();
    } on ApiException catch (error) {
      if (mounted) {
        ToastOverlay.show(context, message: error.message, bottom: 40);
      }
      return;
    }

    if (!mounted) {
      return;
    }

    final added = await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (_) => AddItineraryItemPage(
          chonkangId: widget.chonkangId,
          dayNumber: _selectedDay,
        ),
      ),
    );

    if (added == true) {
      _committedAnyChange = true;
      await _fetch();
    }
  }

  Future<void> _handleSave() async {
    if (_isSaving) {
      return;
    }

    setState(() {
      _isSaving = true;
    });

    try {
      await _flushPendingOrder();

      if (mounted) {
        Navigator.of(context).pop(_committedAnyChange);
      }
    } on ApiException catch (error) {
      if (mounted) {
        ToastOverlay.show(context, message: error.message, bottom: 40);
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

  Future<void> _handleBack() async {
    Navigator.of(context).pop(_committedAnyChange);
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) {
          _handleBack();
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.backgroundPrimary,
        body: SafeArea(
          bottom: false,
          child: Column(
            children: [
              TopBar(
                type: TopBarType.title,
                title: '일정 수정하기',
                onBack: _handleBack,
              ),
              Expanded(child: _buildBody()),
              _buildBottomBar(),
            ],
          ),
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

    if (_errorMessage != null) {
      return Center(
        child: Text(
          _errorMessage!,
          style: AppTypography.bodyExtraLarge.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
      );
    }

    final items = _workingDays[_selectedDay] ?? const [];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Wrap(
            spacing: 3.83,
            runSpacing: 10,
            children: _dayNumbers.map((dayNumber) {
              return DayChoiceChip(
                label: '$dayNumber일차',
                selected: dayNumber == _selectedDay,
                onTap: () {
                  setState(() {
                    _selectedDay = dayNumber;
                  });
                },
              );
            }).toList(),
          ),
        ),
        const SizedBox(height: 18),
        Expanded(
          child: items.isEmpty
              ? _buildEmpty()
              : ReorderableListView.builder(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                  buildDefaultDragHandles: false,
                  itemCount: items.length,
                  onReorderItem: _onReorderItem,
                  itemBuilder: (context, index) {
                    final item = items[index];

                    return Padding(
                      key: ValueKey(item.itemId),
                      padding: const EdgeInsets.only(bottom: 11),
                      child: _EditableItemRow(
                        index: index,
                        order: index + 1,
                        item: item,
                        onDelete: () => _handleDelete(item),
                      ),
                    );
                  },
                ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
          child: WhiteMediumStrokeButton(
            label: '일정 추가하기',
            onTap: _handleAdd,
          ),
        ),
      ],
    );
  }

  Widget _buildEmpty() {
    return Center(
      child: Text(
        '이 날에는 아직 담긴 일정이 없어요.\n아래에서 일정을 추가해보세요.',
        textAlign: TextAlign.center,
        style: AppTypography.captionMedium.copyWith(
          color: AppColors.grayPrimary,
        ),
      ),
    );
  }

  Widget _buildBottomBar() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
      decoration: const BoxDecoration(
        color: AppColors.backgroundPrimary,
        boxShadow: AppShadows.tab,
      ),
      child: GreenButton(
        size: GreenButtonSize.long,
        label: '저장하기',
        disabled: !_isDirty || _isSaving,
        onTap: _handleSave,
      ),
    );
  }
}

class _EditableItemRow extends StatelessWidget {
  const _EditableItemRow({
    required this.index,
    required this.order,
    required this.item,
    required this.onDelete,
  });

  final int index;
  final int order;
  final ItineraryItem item;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final planItem = item.toPlanItem();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.backgroundWhite,
        borderRadius: BorderRadius.circular(16),
        boxShadow: AppShadows.card,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          MapPin(number: order, color: planItem.displayPinColor),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  item.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTypography.tabLarge.copyWith(
                    color: AppColors.textPrimary,
                  ),
                ),
                if (item.place != null && planItem.displayTagLabel.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: MapTag(
                      label: planItem.displayTagLabel,
                      color: planItem.displayTagColor,
                      size: MapTagSize.small,
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: onDelete,
            child: const Padding(
              padding: EdgeInsets.all(4),
              child: Icon(
                Icons.delete_outline,
                size: 20,
                color: AppColors.grayPrimary,
              ),
            ),
          ),
          ReorderableDragStartListener(
            index: index,
            child: const Padding(
              padding: EdgeInsets.only(left: 4),
              child: Icon(
                Icons.drag_handle,
                size: 22,
                color: AppColors.grayPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
