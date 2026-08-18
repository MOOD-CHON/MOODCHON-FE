import 'package:flutter/material.dart';

import '../../../core/widgets/empty_state/character/empty_state_character_medium.dart';

class ExploreSearchEmpty extends StatelessWidget {
  const ExploreSearchEmpty({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: EmptyStateCharacterMedium(
        title: '검색 결과가 없어요.',
        description: '다른 검색어로 다시 찾아보세요.',
      ),
    );
  }
}
