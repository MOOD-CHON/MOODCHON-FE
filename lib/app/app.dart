import 'package:flutter/material.dart';

import '../features/auth/pages/login_entry_page.dart';
import '../features/main/pages/main_page.dart';
import 'theme/app_theme.dart';

class MoodChonApp extends StatelessWidget {
  const MoodChonApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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

      home: Builder(
        builder: (context) {
          return LoginEntryPage(
            onKakaoLogin: () => _openMain(context),
            onAppleLogin: () => _openMain(context),
          );
        },
      ),
    );
  }

  void _openMain(BuildContext context) {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute<void>(builder: (_) => const MainPage()),
    );
  }
}
