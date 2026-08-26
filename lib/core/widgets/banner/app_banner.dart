import 'package:flutter/material.dart';

import 'banner_type.dart';
import 'button_banner.dart';
import 'info_banner.dart';
import 'toast_banner.dart';

class AppBanner extends StatelessWidget {
  const AppBanner({
    super.key,
    required this.type,
    required this.message,
    this.buttonText,
    this.onButtonTap,
  });

  final BannerType type;
  final String message;
  final String? buttonText;
  final VoidCallback? onButtonTap;

  @override
  Widget build(BuildContext context) {
    switch (type) {
      case BannerType.toast:
        return ToastBanner(message: message);

      case BannerType.info:
        return InfoBanner(message: message);

      case BannerType.button:
        return ButtonBanner(
          message: message,
          buttonText: buttonText ?? '',
          onButtonTap: onButtonTap ?? () {},
        );
    }
  }
}
