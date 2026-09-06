import '../../../core/network/api_client.dart';
import '../../../core/network/token_storage.dart';

class AuthApi {
  AuthApi._();

  static final AuthApi instance = AuthApi._();

  Future<void> logout() async {
    final refreshToken = await TokenStorage.instance.getRefreshToken();
    if (refreshToken != null) {
      try {
        await ApiClient.instance.post(
          '/api/auth/logout',
          data: {'refreshToken': refreshToken},
        );
      } catch (_) {
        // 서버 호출이 실패해도 로컬 토큰은 지워서 로그아웃을 완료한다.
      }
    }

    await TokenStorage.instance.clearTokens();
  }

  Future<void> withdraw() async {
    await ApiClient.instance.delete('/api/users/me');
    await TokenStorage.instance.clearTokens();
  }
}
