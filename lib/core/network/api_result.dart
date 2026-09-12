import 'package:dio/dio.dart';

import 'api_exception.dart';

/// 서버 공통 응답 형태 `{ success, message, data }`를 처리하는 헬퍼입니다.
class ApiResult {
  const ApiResult._();

  /// 요청을 보내고 data만 돌려줍니다.
  /// success가 false거나 요청이 실패하면 서버가 내려준 message를 담아
  /// [ApiException]을 던집니다.
  static Future<T> unwrap<T>(
    Future<Response<dynamic>> Function() request,
    T Function(dynamic data) parse,
  ) async {
    try {
      final response = await request();

      final body = response.data;

      if (body is! Map<String, dynamic>) {
        throw const ApiException('알 수 없는 오류가 발생했어요. 다시 시도해주세요.');
      }

      if (body['success'] != true) {
        throw ApiException(_extractMessage(body));
      }

      return parse(body['data']);
    } on DioException catch (error) {
      final body = error.response?.data;

      if (body is Map<String, dynamic>) {
        throw ApiException(_extractMessage(body));
      }

      throw const ApiException('네트워크 연결을 확인해주세요.');
    }
  }

  static String _extractMessage(Map<String, dynamic> body) {
    final message = body['message'];

    if (message is String && message.isNotEmpty) {
      return message;
    }

    return '알 수 없는 오류가 발생했어요. 다시 시도해주세요.';
  }
}
