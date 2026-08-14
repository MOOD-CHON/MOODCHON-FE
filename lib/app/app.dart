import 'package:flutter/material.dart';

import 'theme/app_theme.dart';

class MoodChonApp extends StatelessWidget {
  const MoodChonApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      home: const Scaffold(),
    );
  }
}
