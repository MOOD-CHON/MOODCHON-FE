import 'package:flutter/material.dart';

import '../core/network/token_storage.dart';
import '../features/auth/data/social_auth_service.dart';
import '../features/auth/pages/login_entry_page.dart';
import '../features/main/pages/main_page.dart';
import 'theme/app_colors.dart';
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

      home: FutureBuilder<bool>(
        future: TokenStorage.instance.hasAccessToken(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Scaffold(backgroundColor: AppColors.black);
          }

          if (snapshot.data!) {
            return const MainPage();
          }

          return Builder(
            builder: (context) {
              return LoginEntryPage(
                onKakaoLogin: () => _handleKakaoLogin(context),
                onAppleLogin: () => _handleAppleLogin(context),
              );
            },
          );
        },
      ),
    );
  }

  Future<void> _handleKakaoLogin(BuildContext context) async {
    final result = await SocialAuthService.instance.loginWithKakao();
    if (!context.mounted) return;

    if (result.success) {
      _openMain(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(result.errorMessage ?? '카카오 로그인에 실패했어요.')),
      );
    }
  }

  Future<void> _handleAppleLogin(BuildContext context) async {
    final result = await SocialAuthService.instance.loginWithApple();
    if (!context.mounted) return;

    if (result.success) {
      _openMain(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(result.errorMessage ?? 'Apple 로그인에 실패했어요.')),
      );
    }
  }

  void _openMain(BuildContext context) {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute<void>(builder: (_) => const MainPage()),
    );
  }
}
