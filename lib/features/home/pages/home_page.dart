// 테스트를 쉽게 하기 위해 임의로 만든 홈화면입니다. 이후 홈 구현시 해당 파일은 삭제해주세요.

import 'package:flutter/material.dart';

import '../../../app/theme/app_colors.dart';
import '../../../core/widgets/bottom_tab/bottom_tab_type.dart';
import '../../../core/widgets/navigation/bottom_tab_bar.dart';
import '../../explore/pages/explore_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  void _handleBottomTabChanged(BuildContext context, BottomTabType tab) {
    if (tab == BottomTabType.home) {
      return;
    }

    if (tab == BottomTabType.explore) {
      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          pageBuilder: (_, __, ___) => const ExplorePage(),
          transitionDuration: Duration.zero,
          reverseTransitionDuration: Duration.zero,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundPrimary,
      body: SafeArea(
        bottom: false,
        child: Stack(
          children: [
            const Center(child: Text('홈 테스트 화면')),
            Positioned(
              left: 0,
              right: 0,
              bottom: 22,
              child: NavigationBottomTabBar(
                selectedTab: BottomTabType.home,
                onTabChanged: (tab) {
                  _handleBottomTabChanged(context, tab);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
