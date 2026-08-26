// 테스트를 쉽게 하기 위해 임의로 만든 홈화면입니다.
// 이후 홈 구현 시 해당 파일은 삭제해주세요.

import 'package:flutter/material.dart';

import '../../../app/theme/app_colors.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundPrimary,
      body: const SafeArea(
        bottom: false,
        child: Center(child: Text('홈 테스트 화면')),
      ),
    );
  }
}
