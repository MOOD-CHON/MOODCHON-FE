import 'package:flutter/material.dart';

import 'app_entry_point.dart';
import 'theme/app_theme.dart';

final GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>();

class MoodChonApp extends StatelessWidget {
  const MoodChonApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: rootNavigatorKey,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,

      builder: (context, child) {
        return GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () {
            FocusManager.instance.primaryFocus?.unfocus();
          },
          child: child,
        );
      },

      home: const AppEntryPoint(),
    );
  }
}

// 로그아웃/탈퇴/세션 만료 시 지금까지 쌓인 화면 스택을 전부 걷어내고
// 로그인 여부를 다시 판단하는 진입 지점으로 되돌아간다.
void navigateToLogin() {
  rootNavigatorKey.currentState?.pushAndRemoveUntil(
    MaterialPageRoute<void>(builder: (_) => const AppEntryPoint()),
    (route) => false,
  );
}
