import 'package:flutter/widgets.dart';

/// TourAPI 이미지는 http로 내려오고 CORS 헤더(Access-Control-Allow-Origin)가 없다.
/// 앱에서는 문제가 없지만 웹에서는 두 가지가 걸린다.
///
/// 1. https로 배포한 사이트에서 http 이미지는 mixed content로 차단된다.
///    → [secureImageUrl]로 https로 올린다. TourAPI는 https도 동일하게 제공한다.
/// 2. Flutter 웹 기본 렌더러(CanvasKit)는 이미지를 캔버스에 그려서 CORS 헤더를 요구한다.
///    → [kRemoteImageStrategy]로 <img> 엘리먼트를 쓰게 하면 CORS 없이 표시된다.
String secureImageUrl(String url) {
  final trimmed = url.trim();
  return trimmed.startsWith('http://')
      ? trimmed.replaceFirst('http://', 'https://')
      : trimmed;
}

const WebHtmlElementStrategy kRemoteImageStrategy =
    WebHtmlElementStrategy.prefer;
