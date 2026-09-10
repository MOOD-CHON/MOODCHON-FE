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
import '../widgets/create_trip_intro_header.dart';
import 'create_trip_invite_page.dart';

class CreateTripMoodPage extends StatefulWidget {
  const CreateTripMoodPage({super.key});

  @override
  State<CreateTripMoodPage> createState() => _CreateTripMoodPageState();
}

class _CreateTripMoodPageState extends State<CreateTripMoodPage> {
  final Set<String> _selectedMoodIds = {};
  bool _submitted = false;

  static const List<SelectImageGridItem> _moodItems = [
    SelectImageGridItem(id: 'mood-1'),
    SelectImageGridItem(id: 'mood-2'),
    SelectImageGridItem(id: 'mood-3'),
    SelectImageGridItem(id: 'mood-4'),
    SelectImageGridItem(id: 'mood-5'),
    SelectImageGridItem(id: 'mood-6'),
    SelectImageGridItem(id: 'mood-7'),
    SelectImageGridItem(id: 'mood-8'),
    SelectImageGridItem(id: 'mood-9'),
    SelectImageGridItem(id: 'mood-10'),
    SelectImageGridItem(id: 'mood-11'),
    SelectImageGridItem(id: 'mood-12'),
    SelectImageGridItem(id: 'mood-13'),
    SelectImageGridItem(id: 'mood-14'),
    SelectImageGridItem(id: 'mood-15'),
    SelectImageGridItem(id: 'mood-16'),
  ];

  bool get _canGoNext => _selectedMoodIds.length == 3;
  bool get _hasMoodError => _submitted && !_canGoNext;

  void _handleMoodSelected(String id, bool selected) {
    setState(() {
      if (!selected) {
        _selectedMoodIds.remove(id);
        return;
      }

      if (_selectedMoodIds.length >= 3) {
        return;
      }

      _selectedMoodIds.add(id);
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
      MaterialPageRoute<void>(builder: (_) => const CreateTripInvitePage()),
    );
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
                    SelectImageGrid(
                      items: _moodItems,
                      mode: SelectImageMode.selectable,
                      selectedIds: _selectedMoodIds,
                      onSelected: _handleMoodSelected,
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
