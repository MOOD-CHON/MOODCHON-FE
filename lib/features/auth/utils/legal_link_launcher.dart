import 'package:url_launcher/url_launcher.dart';

abstract final class LegalLinkLauncher {
  static final Uri privacyPolicyUri = Uri.parse(
    'https://stitch-risk-47e.notion.site/3d3d7663959380c2ad38c9d951c9c9c6?source=copy_link',
  );

  static Future<void> openPrivacyPolicy() async {
    final launched = await launchUrl(
      privacyPolicyUri,
      mode: LaunchMode.externalApplication,
    );

    if (!launched) {
      throw Exception('개인정보 처리방침 페이지를 열 수 없습니다.');
    }
  }
}
