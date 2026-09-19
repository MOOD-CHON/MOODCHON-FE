import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';

import 'app/app.dart';
import 'core/network/api_client.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load();
  // 웹은 네이티브 키가 아니라 JavaScript 키를 쓴다.
  await KakaoSdk.init(
    nativeAppKey: dotenv.env['KAKAO_NATIVE_APP_KEY']!,
    javaScriptAppKey: dotenv.env['KAKAO_JS_APP_KEY'],
  );
  ApiClient.onSessionExpired = navigateToLogin;

  // 웹 카카오 로그인 복귀 처리는 AppEntryPoint에서 한다.
  // 여기서 네트워크를 기다리면 실패했을 때 흰 화면으로 끝나버린다.
  runApp(const MoodChonApp());
}
