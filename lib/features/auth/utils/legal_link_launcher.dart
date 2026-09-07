import 'package:url_launcher/url_launcher.dart';

abstract final class LegalLinkLauncher {
  static final Uri privacyPolicyUri = Uri.parse(
    'https://stitch-risk-47e.notion.site/3d3d7663959380c2ad38c9d951c9c9c6?source=copy_link',
  );

  static Future<bool> openPrivacyPolicy() async {
    try {
      return await launchUrl(
        privacyPolicyUri,
        mode: LaunchMode.externalApplication,
      );
    } catch (_) {
      return false;
    }
  }
}
