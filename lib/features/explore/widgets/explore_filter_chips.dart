import 'package:flutter/material.dart';

import '../../../core/widgets/choice_chip/choice_chip_border_type.dart';
import '../../../core/widgets/choice_chip/mood_choice_chip.dart';

class ExploreFilterChips extends StatelessWidget {
  const ExploreFilterChips({
    super.key,
    required this.selectedMood,
    required this.onSelected,
  });

  final String selectedMood;
  final ValueChanged<String> onSelected;

  static const List<String> moods = [
    '전체',
    '조용한 휴식',
    '아늑한 공간',
    '고즈넉한 감성',
    '여유로운 풍경',
    '활기있는 분위기',
    '빈티지 감성',
    '밤감성',
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          for (var index = 0; index < moods.length; index++) ...[
            MoodChoiceChip(
              label: moods[index],
              borderType: ChoiceChipBorderType.borderO,
              selected: selectedMood == moods[index],
              onSelected: (_) {
                onSelected(moods[index]);
              },
            ),
            if (index != moods.length - 1) const SizedBox(width: 6),
          ],
        ],
      ),
    );
  }
}
