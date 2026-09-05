import 'package:flutter/services.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

import '../../../core/network/api_client.dart';
import '../../../core/network/token_storage.dart';

class AuthResult {
  const AuthResult.success() : success = true, errorMessage = null;

  const AuthResult.failure(this.errorMessage) : success = false;

  final bool success;
  final String? errorMessage;
}

class SocialAuthService {
  SocialAuthService._();

  static final SocialAuthService instance = SocialAuthService._();

  Future<AuthResult> loginWithKakao() async {
    try {
      final kakaoToken = await _obtainKakaoToken();
      await _loginToBackend('/api/auth/kakao', {
        'accessToken': kakaoToken.accessToken,
      });
      return const AuthResult.success();
    } catch (e) {
      return AuthResult.failure(e.toString());
    }
  }

  Future<AuthResult> loginWithApple() async {
    try {
      final credential = await SignInWithApple.getAppleIDCredential(
        scopes: [AppleIDAuthorizationScopes.email],
      );
      final identityToken = credential.identityToken;
      if (identityToken == null) {
        return const AuthResult.failure('애플 로그인에 실패했어요.');
      }

      await _loginToBackend('/api/auth/apple', {
        'identityToken': identityToken,
      });
      return const AuthResult.success();
    } catch (e) {
      return AuthResult.failure(e.toString());
    }
  }

  Future<OAuthToken> _obtainKakaoToken() async {
    if (await isKakaoTalkInstalled()) {
      try {
        return await UserApi.instance.loginWithKakaoTalk();
      } on PlatformException catch (error) {
        if (error.code == 'CANCELED') {
          rethrow;
        }
        return await UserApi.instance.loginWithKakaoAccount();
      }
    }
    return await UserApi.instance.loginWithKakaoAccount();
  }

  Future<void> _loginToBackend(
    String path,
    Map<String, dynamic> body,
  ) async {
    final response = await ApiClient.instance.post(path, data: body);
    final data = response.data['data'] as Map<String, dynamic>;

    await TokenStorage.instance.saveTokens(
      accessToken: data['accessToken'] as String,
      refreshToken: data['refreshToken'] as String,
    );
  }
}
