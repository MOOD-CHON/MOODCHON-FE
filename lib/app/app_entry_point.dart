import 'package:flutter/material.dart';

import '../core/network/token_storage.dart';
import '../features/auth/data/social_auth_service.dart';
import '../features/auth/pages/login_entry_page.dart';
import '../features/main/pages/main_page.dart';
import 'theme/app_colors.dart';

// 로그인 여부에 따라 로그인 화면/메인 화면으로 갈리는 진입 지점.
// 앱 최초 실행 시 home으로 쓰이는 것 외에, 로그아웃·탈퇴·세션 만료 시에도
// 이 위젯으로 다시 이동시켜서 토큰 유무를 새로 확인하게 한다.
class AppEntryPoint extends StatelessWidget {
  const AppEntryPoint({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: _resolveSignedIn(),
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
            );
          },
        );
      },
    );
  }

  // 웹은 카카오 로그인 후 ?code= 를 달고 이 화면으로 되돌아온다.
  // 그 코드를 먼저 처리한 뒤 로그인 여부를 판단한다. 앱에서는 첫 줄이 바로 false를 반환한다.
  Future<bool> _resolveSignedIn() async {
    await SocialAuthService.instance.completeWebLoginIfNeeded();
    return TokenStorage.instance.hasAccessToken();
  }

  Future<void> _handleKakaoLogin(BuildContext context) async {
    final result = await SocialAuthService.instance.loginWithKakao();
    if (!context.mounted || result.canceled) return;

    if (result.success) {
      _openMain(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(result.errorMessage ?? '카카오 로그인에 실패했어요.')),
      );
    }
  }

  void _openMain(BuildContext context) {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute<void>(builder: (_) => const MainPage()),
    );
  }
}
