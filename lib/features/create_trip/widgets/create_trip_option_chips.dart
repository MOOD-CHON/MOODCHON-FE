import 'package:flutter/material.dart';

import '../../../core/widgets/choice_chip/choice_chip_border_type.dart';
import '../../../core/widgets/choice_chip/mood_choice_chip.dart';

class CreateTripOptionChips extends StatelessWidget {
  const CreateTripOptionChips({
    super.key,
    required this.options,
    required this.isSelected,
    required this.onSelected,
  });

  final List<String> options;
  final bool Function(String option) isSelected;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Wrap(
        spacing: 9,
        runSpacing: 10,
        children: [
          for (final option in options)
            MoodChoiceChip(
              label: option,
              borderType: ChoiceChipBorderType.borderO,
              selected: isSelected(option),
              onSelected: (_) => onSelected(option),
            ),
        ],
      ),
    );
  }
}
