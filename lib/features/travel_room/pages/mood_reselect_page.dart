import 'package:flutter/material.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_typography.dart';
import '../../../core/network/api_exception.dart';
import '../../../core/widgets/banner/toast_overlay.dart';
import '../../../core/widgets/button/green/green_button.dart';
import '../../../core/widgets/button/green/green_button_size.dart';
import '../../../core/widgets/empty_state/character/empty_state_character_medium.dart';
import '../../../core/widgets/navigation/top_bar.dart';
import '../../../core/widgets/select_image/select_image_grid.dart';
import '../../../core/widgets/select_image/select_image_mode.dart';
import '../../chonkang_join/models/mood_card.dart';
import '../../main/pages/main_page.dart';
import '../data/travel_room_settings_api.dart';
import 'travel_room_main_page.dart';

const int _kRequiredMoodCardCount = 3;

class MoodReselectPage extends StatefulWidget {
  const MoodReselectPage({super.key, required this.chonkangId});

  final int chonkangId;

  @override
  State<MoodReselectPage> createState() => _MoodReselectPageState();
}

class _MoodReselectPageState extends State<MoodReselectPage> {
  List<MoodCard> _moodCards = const [];
  final Set<int> _selectedIds = {};

  bool _isLoading = true;
  bool _isSubmitting = false;
  String? _loadErrorMessage;

  @override
  void initState() {
    super.initState();

    _fetchMoodCards();
  }

  Future<void> _fetchMoodCards() async {
    setState(() {
      _isLoading = true;
      _loadErrorMessage = null;
    });

    try {
      final cards = await TravelRoomSettingsApi.getRandomMoodCards();

      if (!mounted) {
        return;
      }

      setState(() {
        _moodCards = cards;
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

  void _handleSelected(String id, bool selected) {
    final cardId = int.parse(id);

    if (selected) {
      if (_selectedIds.length >= _kRequiredMoodCardCount) {
        ToastOverlay.show(
          context,
          message: '무드 이미지는 최대 $_kRequiredMoodCardCount개까지 선택할 수 있어요.',
          bottom: 96,
        );

        return;
      }

      setState(() {
        _selectedIds.add(cardId);
      });
    } else {
      setState(() {
        _selectedIds.remove(cardId);
      });
    }
  }

  Future<void> _handleSubmit() async {
    if (_selectedIds.length != _kRequiredMoodCardCount) {
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    try {
      await TravelRoomSettingsApi.submitMoodSelection(
        widget.chonkangId,
        selectedMoodCardIds: _selectedIds,
      );

      if (!mounted) {
        return;
      }

      await _goToTravelRoom();
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

  Future<void> _goToTravelRoom() async {
    try {
      final data = await TravelRoomSettingsApi.getMainData(widget.chonkangId);

      if (!mounted) {
        return;
      }

      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => TravelRoomMainPage(data: data)),
        (route) => false,
      );
    } on ApiException catch (_) {
      if (!mounted) {
        return;
      }

      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const MainPage()),
        (route) => false,
      );
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
              title: '무드 선택하기',
              onBack: () {
                Navigator.of(context).pop();
              },
            ),
            Expanded(child: _buildBody()),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
              child: GreenButton(
                size: GreenButtonSize.long,
                label: '촌캉스 방으로 이동',
                disabled: _selectedIds.length != _kRequiredMoodCardCount,
                onTap: _isSubmitting ? () {} : _handleSubmit,
              ),
            ),
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

    if (_loadErrorMessage != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              EmptyStateCharacterMedium(
                title: '무드 이미지를 불러오지 못했어요.',
                description: _loadErrorMessage!,
              ),
              const SizedBox(height: 20),
              GreenButton(
                size: GreenButtonSize.small,
                label: '다시 시도하기',
                onTap: _fetchMoodCards,
              ),
            ],
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
            '무드 선택',
            style: AppTypography.captionLarge.copyWith(color: AppColors.main),
          ),
          const SizedBox(height: 8),
          Text(
            '이번 촌캉스는 어떤 분위기일까요?',
            style: AppTypography.titleMood.copyWith(color: AppColors.black),
          ),
          const SizedBox(height: 6),
          Text(
            '마음에 드는 무드 이미지를 $_kRequiredMoodCardCount개 선택해주세요.',
            style: AppTypography.descriptionMedium.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 20),
          SelectImageGrid(
            items: _moodCards
                .map(
                  (card) => SelectImageGridItem(
                    id: card.id.toString(),
                    imageUrl: card.imageUrl,
                    tag: card.accommodationTypeName,
                  ),
                )
                .toList(),
            mode: SelectImageMode.selectable,
            selectedIds: _selectedIds.map((id) => id.toString()).toSet(),
            onSelected: _handleSelected,
          ),
        ],
      ),
    );
  }
}
