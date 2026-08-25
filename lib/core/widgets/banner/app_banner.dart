import 'package:flutter/material.dart';

import 'banner_type.dart';
import 'toast_banner.dart';

class AppBanner extends StatelessWidget {
  const AppBanner({super.key, required this.type, required this.message});

  final BannerType type;
  final String message;

  @override
  Widget build(BuildContext context) {
    switch (type) {
      case BannerType.toast:
        return ToastBanner(message: message);
    }
  }
}
