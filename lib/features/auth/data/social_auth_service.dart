import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';

import '../../../core/network/api_client.dart';
import '../../../core/network/token_storage.dart';

class AuthResult {
  const AuthResult.success()
    : success = true,
      canceled = false,
      errorMessage = null;

  const AuthResult.canceled()
    : success = false,
      canceled = true,
      errorMessage = null;

  const AuthResult.failure(this.errorMessage) : success = false, canceled = false;

  final bool success;
  final bool canceled;
  final String? errorMessage;
}

class SocialAuthService {
  SocialAuthService._();

  static final SocialAuthService instance = SocialAuthService._();

  /// 웹 로그인은 카카오가 이 주소로 인가 코드를 돌려준다.
  /// 카카오 디벨로퍼스에 등록된 Redirect URI와 정확히 같아야 한다.
  static String get webRedirectUri => Uri.base.origin;

  Future<AuthResult> loginWithKakao() async {
    if (kIsWeb) {
      return _startWebKakaoLogin();
    }

    try {
      final kakaoToken = await _obtainKakaoToken();
      await _loginToBackend('/api/auth/kakao', {
        'accessToken': kakaoToken.accessToken,
      });
      return const AuthResult.success();
    } on PlatformException catch (error) {
      if (error.code == 'CANCELED') {
        return const AuthResult.canceled();
      }
      return AuthResult.failure(error.toString());
    } catch (e) {
      return AuthResult.failure(e.toString());
    }
  }

  /// 웹은 팝업이 아니라 페이지 전체가 카카오 로그인 화면으로 이동한다.
  /// 이 호출 이후 코드는 실행되지 않고, 돌아온 뒤 [completeWebLoginIfNeeded]가 이어받는다.
  Future<AuthResult> _startWebKakaoLogin() async {
    try {
      await AuthCodeClient.instance.authorize(redirectUri: webRedirectUri);
      return const AuthResult.canceled();
    } catch (e) {
      return AuthResult.failure(e.toString());
    }
  }

  /// 카카오 로그인 후 되돌아왔을 때 주소창의 ?code= 를 백엔드로 넘겨 로그인을 마친다.
  /// 웹에서는 SDK가 브라우저의 토큰 발급을 막아둬서, 코드→토큰 교환은 서버가 한다.
  /// 인가 코드는 일회용이라 한 번 쓰면 재사용할 수 없다.
  /// 화면이 다시 그려질 때마다 같은 코드로 재시도하면 무한 루프가 된다.
  bool _webLoginAttempted = false;

  Future<bool> completeWebLoginIfNeeded() async {
    if (!kIsWeb || _webLoginAttempted) {
      return false;
    }

    final code = Uri.base.queryParameters['code'];
    if (code == null || code.isEmpty) {
      return false;
    }

    _webLoginAttempted = true;

    try {
      await _loginToBackend('/api/auth/kakao/web', {
        'code': code,
        'redirectUri': webRedirectUri,
      });
      return true;
    } catch (e) {
      // 여기서 실패하면 화면은 그냥 로그인 창으로 돌아가 버려서 원인을 알 수 없다.
      // 최소한 콘솔에는 남긴다.
      debugPrint('[웹 카카오 로그인] 인가 코드 교환 실패: $e');
      return false;
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
