import 'package:flutter/material.dart';

import '../../../app/theme/app_colors.dart';
import '../../../core/widgets/button/green/green_button.dart';
import '../../../core/widgets/button/green/green_button_size.dart';
import '../../../core/widgets/character/character.dart';
import '../../../core/widgets/character/character_size.dart';
import '../../../core/widgets/character/character_type.dart';
import '../../../core/widgets/navigation/top_bar.dart';
import '../../../core/widgets/select_image/select_image_grid.dart';
import '../../../core/widgets/select_image/select_image_mode.dart';
import '../../../core/widgets/text/warning_text.dart';
import '../data/create_trip_api.dart';
import '../models/create_trip_draft.dart';
import '../models/create_trip_mood_card.dart';
import '../widgets/create_trip_intro_header.dart';
import 'create_trip_invite_page.dart';

class CreateTripMoodPage extends StatefulWidget {
  const CreateTripMoodPage({super.key, required this.draft});

  final CreateTripDraft draft;

  @override
  State<CreateTripMoodPage> createState() => _CreateTripMoodPageState();
}

class _CreateTripMoodPageState extends State<CreateTripMoodPage> {
  final Set<int> _selectedMoodCardIds = {};
  bool _submitted = false;
  late Future<List<CreateTripMoodCard>> _moodCardsFuture;

  @override
  void initState() {
    super.initState();
    _moodCardsFuture = CreateTripApi.instance.fetchRandomMoodCards();
  }

  bool get _canGoNext => _selectedMoodCardIds.length == 3;
  bool get _hasMoodError => _submitted && !_canGoNext;

  void _handleMoodSelected(String id, bool selected) {
    setState(() {
      if (!selected) {
        _selectedMoodCardIds.remove(int.parse(id));
        return;
      }

      if (_selectedMoodCardIds.length >= 3) {
        return;
      }

      _selectedMoodCardIds.add(int.parse(id));
    });
  }

  void _goToInviteStep() {
    setState(() {
      _submitted = true;
    });

    if (!_canGoNext) {
      return;
    }

    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => CreateTripInvitePage(
          draft: widget.draft,
          selectedMoodCardIds: _selectedMoodCardIds,
        ),
      ),
    );
  }

  void _retryFetchMoodCards() {
    setState(() {
      _moodCardsFuture = CreateTripApi.instance.fetchRandomMoodCards();
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
                padding: const EdgeInsets.fromLTRB(10, 0, 10, 47),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 6),
                      child: CreateTripIntroHeader(
                        eyebrow: '무드 선택',
                        title: '이번 촌캉스는 어떤 분위기일까요?',
                        description: '마음에 드는 무드 이미지를 3개 선택해주세요.',
                      ),
                    ),
                    const SizedBox(height: 28),
                    FutureBuilder<List<CreateTripMoodCard>>(
                      future: _moodCardsFuture,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState !=
                            ConnectionState.done) {
                          return const Padding(
                            padding: EdgeInsets.symmetric(vertical: 80),
                            child: Center(child: CircularProgressIndicator()),
                          );
                        }

                        if (snapshot.hasError) {
                          return _MoodCardsErrorState(
                            onRetry: _retryFetchMoodCards,
                          );
                        }

                        final moodCards = snapshot.data ?? [];

                        return SelectImageGrid(
                          items: moodCards
                              .map(
                                (card) => SelectImageGridItem(
                                  id: card.id.toString(),
                                  imageUrl: card.imageUrl,
                                  tag: card.placeCategoryLabel,
                                ),
                              )
                              .toList(),
                          mode: SelectImageMode.selectable,
                          selectedIds: _selectedMoodCardIds
                              .map((id) => id.toString())
                              .toSet(),
                          onSelected: _handleMoodSelected,
                        );
                      },
                    ),
                    if (_hasMoodError) ...[
                      const SizedBox(height: 13),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 6),
                        child: WarningText(text: '무드 이미지를 3개 선택해주세요.'),
                      ),
                    ],
                    const SizedBox(height: 34),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 6),
                      child: GreenButton(
                        size: GreenButtonSize.long,
                        label: '다음',
                        onTap: _goToInviteStep,
                      ),
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

class _MoodCardsErrorState extends StatelessWidget {
  const _MoodCardsErrorState({required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 60, horizontal: 6),
      child: Column(
        children: [
          const Text('무드 카드를 불러오지 못했어요.'),
          const SizedBox(height: 12),
          TextButton(onPressed: onRetry, child: const Text('다시 시도')),
        ],
      ),
    );
  }
}
