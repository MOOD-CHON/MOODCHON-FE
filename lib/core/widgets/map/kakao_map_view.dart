import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_typography.dart';
import 'map_pin.dart';

/// 카카오 지도에 찍을 번호 핀 하나.
class KakaoMapMarker {
  const KakaoMapMarker({
    required this.latitude,
    required this.longitude,
    required this.number,
    required this.color,
  });

  final double latitude;
  final double longitude;
  final int number;
  final MapPinColor color;

  String get _colorHex {
    switch (color) {
      case MapPinColor.blue:
        return '#3493EA';
      case MapPinColor.red:
        return '#F27A70';
      case MapPinColor.purple:
        return '#956BE0';
      case MapPinColor.green:
        return '#5F8D29';
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'lat': latitude,
      'lng': longitude,
      'number': number,
      'color': _colorHex,
    };
  }
}

/// 카카오 지도 JavaScript SDK를 WebView 안에서 띄워 번호 핀을 표시합니다.
///
/// 카카오 개발자 콘솔에서 아래 두 가지가 준비되어 있어야 지도가 보입니다.
///   1. 앱 > 제품 설정 > 카카오맵 활성화
///   2. 앱 > 플랫폼 > Web > 사이트 도메인에 `https://localhost` 등록
/// (WebView가 로컬 HTML을 이 도메인 기준으로 로드하므로 도메인 심사를 통과해야 합니다.)
class KakaoMapView extends StatefulWidget {
  const KakaoMapView({
    super.key,
    required this.markers,
    this.height = 220,
  });

  final List<KakaoMapMarker> markers;
  final double height;

  /// WebView 로드 기준이 되는 가상 도메인. 카카오 콘솔에 이 값을 등록해야 합니다.
  static const String webDomain = 'https://localhost';

  @override
  State<KakaoMapView> createState() => _KakaoMapViewState();
}

class _KakaoMapViewState extends State<KakaoMapView> {
  WebViewController? _controller;
  bool _failed = false;

  String get _jsKey => dotenv.env['KAKAO_JS_APP_KEY'] ?? '';

  bool get _hasKey => _jsKey.isNotEmpty;

  @override
  void initState() {
    super.initState();

    if (_hasKey) {
      _controller = WebViewController()
        ..setJavaScriptMode(JavaScriptMode.unrestricted)
        ..setBackgroundColor(AppColors.backgroundGray)
        ..setNavigationDelegate(
          NavigationDelegate(
            onWebResourceError: (_) {
              if (mounted) {
                setState(() {
                  _failed = true;
                });
              }
            },
          ),
        )
        ..loadHtmlString(_buildHtml(), baseUrl: KakaoMapView.webDomain);
    }
  }

  @override
  void didUpdateWidget(covariant KakaoMapView oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (_hasKey && !_sameMarkers(oldWidget.markers, widget.markers)) {
      _failed = false;
      _controller?.loadHtmlString(
        _buildHtml(),
        baseUrl: KakaoMapView.webDomain,
      );
    }
  }

  bool _sameMarkers(List<KakaoMapMarker> a, List<KakaoMapMarker> b) {
    if (a.length != b.length) {
      return false;
    }

    for (var i = 0; i < a.length; i++) {
      if (a[i].latitude != b[i].latitude ||
          a[i].longitude != b[i].longitude ||
          a[i].number != b[i].number) {
        return false;
      }
    }

    return true;
  }

  String _buildHtml() {
    final markersJson = jsonEncode(
      widget.markers.map((marker) => marker.toJson()).toList(),
    );

    return '''
<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8" />
<meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no" />
<style>
  html, body, #map { margin: 0; padding: 0; width: 100%; height: 100%; overflow: hidden; background: #F4F4F1; }
  .moodchon-pin {
    display: flex; align-items: center; justify-content: center;
    width: 22px; height: 22px; border-radius: 50%;
    color: #fff; border: 2px solid #fff;
    font-family: -apple-system, BlinkMacSystemFont, 'Apple SD Gothic Neo', 'Malgun Gothic', sans-serif;
    font-size: 12px; font-weight: 700; line-height: 1;
    box-shadow: 0 1px 4px rgba(0, 0, 0, 0.3);
  }
  #moodchon-error {
    position: absolute; inset: 0; display: none;
    align-items: center; justify-content: center;
    color: #89898E; font-size: 13px;
    font-family: -apple-system, BlinkMacSystemFont, 'Apple SD Gothic Neo', sans-serif;
  }
</style>
</head>
<body>
<div id="map"></div>
<div id="moodchon-error">지도를 불러오지 못했어요.</div>
<script>
  var MARKERS = $markersJson;
  function showError() { document.getElementById('moodchon-error').style.display = 'flex'; }
  var script = document.createElement('script');
  script.onerror = showError;
  script.src = 'https://dapi.kakao.com/v2/maps/sdk.js?appkey=$_jsKey&autoload=false';
  script.onload = function () {
    if (!window.kakao || !window.kakao.maps) { showError(); return; }
    kakao.maps.load(function () {
      try {
        var container = document.getElementById('map');
        var fallbackCenter = new kakao.maps.LatLng(36.5, 127.8);
        var center = MARKERS.length
          ? new kakao.maps.LatLng(MARKERS[0].lat, MARKERS[0].lng)
          : fallbackCenter;
        var map = new kakao.maps.Map(container, { center: center, level: MARKERS.length ? 5 : 12 });
        map.setDraggable(true);

        if (MARKERS.length) {
          var bounds = new kakao.maps.LatLngBounds();
          MARKERS.forEach(function (m) {
            var position = new kakao.maps.LatLng(m.lat, m.lng);
            bounds.extend(position);
            var el = document.createElement('div');
            el.className = 'moodchon-pin';
            el.style.background = m.color;
            el.textContent = m.number;
            new kakao.maps.CustomOverlay({
              position: position, content: el, xAnchor: 0.5, yAnchor: 0.5, map: map
            });
          });
          if (MARKERS.length > 1) {
            map.setBounds(bounds, 48, 48, 48, 48);
          } else {
            map.setLevel(4);
            map.setCenter(center);
          }
        }
      } catch (e) {
        showError();
      }
    });
  };
  document.head.appendChild(script);
</script>
</body>
</html>
''';
  }

  @override
  Widget build(BuildContext context) {
    if (!_hasKey || _failed || _controller == null) {
      return _KakaoMapFallback(
        height: widget.height,
        markers: widget.markers,
      );
    }

    return SizedBox(
      width: double.infinity,
      height: widget.height,
      child: WebViewWidget(controller: _controller!),
    );
  }
}

/// JS 키가 없거나 지도 로드에 실패했을 때 보여주는 대체 화면.
class _KakaoMapFallback extends StatelessWidget {
  const _KakaoMapFallback({required this.height, required this.markers});

  final double height;
  final List<KakaoMapMarker> markers;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: height,
      color: AppColors.backgroundGray,
      alignment: Alignment.center,
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (markers.isNotEmpty)
            Wrap(
              alignment: WrapAlignment.center,
              spacing: 8,
              runSpacing: 8,
              children: markers
                  .map(
                    (marker) => MapPin(
                      number: marker.number,
                      color: marker.color,
                    ),
                  )
                  .toList(),
            ),
          if (markers.isNotEmpty) const SizedBox(height: 12),
          Text(
            '지도를 불러오지 못했어요.',
            style: AppTypography.captionMedium.copyWith(
              color: AppColors.grayPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
