import 'package:flutter/material.dart';

import '../../../app/theme/app_colors.dart';
import '../../../core/widgets/bottom_tab/bottom_tab_type.dart';
import '../../../core/widgets/navigation/bottom_tab_bar.dart';
import '../../explore/pages/explore_page.dart';
import '../../home/pages/home_page.dart';
import '../../profile/pages/profile_page.dart';
import '../../saved/pages/saved_page.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  BottomTabType _selectedTab = BottomTabType.home;

  int get _selectedIndex {
    switch (_selectedTab) {
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

  void _handleTabChanged(BottomTabType tab) {
    if (_selectedTab == tab) {
      return;
    }

    setState(() {
      _selectedTab = tab;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isKeyboardVisible = MediaQuery.viewInsetsOf(context).bottom > 0;

    return Scaffold(
      backgroundColor: AppColors.backgroundPrimary,
      body: Stack(
        children: [
          IndexedStack(
            index: _selectedIndex,
            children: const [
              HomePage(),
              ExplorePage(),
              SavedPage(),
              ProfilePage(),
            ],
          ),

          if (!isKeyboardVisible)
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: NavigationBottomTabBar(
                selectedTab: _selectedTab,
                onTabChanged: _handleTabChanged,
              ),
            ),
        ],
      ),
    );
  }
}
