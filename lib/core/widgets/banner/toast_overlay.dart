import 'dart:async';

import 'package:flutter/material.dart';

import 'app_banner.dart';
import 'banner_type.dart';

class ToastOverlay {
  ToastOverlay._();

  static OverlayEntry? _currentEntry;
  static Timer? _timer;

  static void show(
    BuildContext context, {
    required String message,
    required double bottom,
  }) {
    _hideCurrent();

    final overlay = Overlay.of(context);

    final entry = OverlayEntry(
      builder: (context) {
        return Positioned(
          left: 16,
          right: 16,
          bottom: bottom,
          child: Material(
            type: MaterialType.transparency,
            child: AppBanner(type: BannerType.toast, message: message),
          ),
        );
      },
    );

    _currentEntry = entry;
    overlay.insert(entry);

    _timer = Timer(const Duration(seconds: 3), _hideCurrent);
  }

  static void _hideCurrent() {
    _timer?.cancel();
    _timer = null;

    _currentEntry?.remove();
    _currentEntry = null;
  }
}
