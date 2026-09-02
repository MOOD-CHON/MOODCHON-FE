import 'package:flutter/material.dart';

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

      home: const MainPage(),
    );
  }
}
