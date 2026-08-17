import 'package:flutter/material.dart';

import '../base/bottom_tab_field/bottom_tab_field.dart';
import '../base/bottom_tab_selected_background/bottom_tab_selected_background.dart';
import '../bottom_tab/bottom_tab_type.dart';
import 'bottom_tab_item.dart';

class NavigationBottomTabBar extends StatelessWidget {
  const NavigationBottomTabBar({
    super.key,
    required this.selectedTab,
    required this.onTabChanged,
  });

  final BottomTabType selectedTab;
  final ValueChanged<BottomTabType> onTabChanged;

  int get _selectedIndex {
    switch (selectedTab) {
      case BottomTabType.home:
        return 0;
      case BottomTabType.explore:
        return 1;
      case BottomTabType.saved:
        return 2;
      case BottomTabType.my:
        return 3;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: BottomTabField(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
          child: LayoutBuilder(
            builder: (context, constraints) {
              const gap = 1.0;
              const gapCount = 3;

              final tabWidth = (constraints.maxWidth - (gap * gapCount)) / 4;

              final selectedLeft = _selectedIndex * (tabWidth + gap);

              return Stack(
                children: [
                  AnimatedPositioned(
                    left: selectedLeft,
                    top: 0,
                    width: tabWidth,
                    height: 54,
                    duration: const Duration(milliseconds: 220),
                    curve: Curves.easeOutCubic,
                    child: const Center(child: BottomTabSelectedBackground()),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: NavigationBottomTabItem(
                          type: BottomTabType.home,
                          label: '촌캉스',
                          isSelected: selectedTab == BottomTabType.home,
                          onTap: () {
                            onTabChanged(BottomTabType.home);
                          },
                        ),
                      ),
                      const SizedBox(width: 1),
                      Expanded(
                        child: NavigationBottomTabItem(
                          type: BottomTabType.explore,
                          label: '탐색',
                          isSelected: selectedTab == BottomTabType.explore,
                          onTap: () {
                            onTabChanged(BottomTabType.explore);
                          },
                        ),
                      ),
                      const SizedBox(width: 1),
                      Expanded(
                        child: NavigationBottomTabItem(
                          type: BottomTabType.saved,
                          label: '저장',
                          isSelected: selectedTab == BottomTabType.saved,
                          onTap: () {
                            onTabChanged(BottomTabType.saved);
                          },
                        ),
                      ),
                      const SizedBox(width: 1),
                      Expanded(
                        child: NavigationBottomTabItem(
                          type: BottomTabType.my,
                          label: '프로필',
                          isSelected: selectedTab == BottomTabType.my,
                          onTap: () {
                            onTabChanged(BottomTabType.my);
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
