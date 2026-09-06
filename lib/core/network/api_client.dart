import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'token_storage.dart';

class ApiClient {
  ApiClient._();

  static final Dio instance = _create();

  // 리프레시 토큰까지 만료/폐기되어 재발급이 실패했을 때 호출된다.
  // 로그인 화면으로 돌려보내는 실제 네비게이션은 app.dart 쪽에서 등록한다.
  static void Function()? onSessionExpired;

  static Dio _create() {
    final dio = Dio(
      BaseOptions(
        baseUrl: dotenv.env['API_BASE_URL'] ?? '',
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
      ),
    );

    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final accessToken = await TokenStorage.instance.getAccessToken();
          if (accessToken != null) {
            options.headers['Authorization'] = 'Bearer $accessToken';
          }
          handler.next(options);
        },
        onError: (error, handler) async {
          final isUnauthorized = error.response?.statusCode == 401;
          final alreadyRetried = error.requestOptions.extra['retried'] == true;

          if (!isUnauthorized || alreadyRetried) {
            handler.next(error);
            return;
          }

          final newAccessToken = await _refreshAccessToken();
          if (newAccessToken == null) {
            await TokenStorage.instance.clearTokens();
            onSessionExpired?.call();
            handler.next(error);
            return;
          }

          try {
            final retryOptions = error.requestOptions;
            retryOptions.extra['retried'] = true;
            retryOptions.headers['Authorization'] = 'Bearer $newAccessToken';

            final response = await dio.fetch(retryOptions);
            handler.resolve(response);
          } catch (_) {
            handler.next(error);
          }
        },
      ),
    );

    return dio;
  }

  // 액세스 토큰 갱신 요청은 별도의 Dio 인스턴스로 보낸다. instance로 보내면
  // 이 요청 자체도 위 인터셉터를 다시 타면서 무한 재시도로 이어질 수 있다.
  static Future<String?> _refreshAccessToken() async {
    final refreshToken = await TokenStorage.instance.getRefreshToken();
    if (refreshToken == null) {
      return null;
    }

    try {
      final response = await Dio(
        BaseOptions(baseUrl: dotenv.env['API_BASE_URL'] ?? ''),
      ).post('/api/auth/refresh', data: {'refreshToken': refreshToken});

      final data = response.data['data'] as Map<String, dynamic>;
      final newAccessToken = data['accessToken'] as String;

      await TokenStorage.instance.saveTokens(
        accessToken: newAccessToken,
        refreshToken: data['refreshToken'] as String,
      );

      return newAccessToken;
    } catch (_) {
      return null;
    }
  }
}
