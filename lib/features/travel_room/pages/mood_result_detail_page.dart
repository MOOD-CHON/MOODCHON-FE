import 'dart:async';
import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:gal/gal.dart';

import '../../../app/theme/app_colors.dart';
import '../../../core/widgets/banner/toast_banner.dart';
import '../../../core/widgets/button/green/green_button.dart';
import '../../../core/widgets/button/green/green_button_size.dart';
import '../../../core/widgets/navigation/top_bar.dart';
import '../data/mood_result_mock_data.dart';
import '../models/mood_result.dart';
import '../widgets/mood_result/mood_result_card.dart';
import 'mood_accommodation_page.dart';

class MoodResultDetailPage extends StatefulWidget {
  const MoodResultDetailPage({
    super.key,
    this.result = moodResultMockData,
    this.showAccommodationButton = true,
  });

  final MoodResult result;
  final bool showAccommodationButton;

  @override
  State<MoodResultDetailPage> createState() => _MoodResultDetailPageState();
}

class _MoodResultDetailPageState extends State<MoodResultDetailPage> {
  final GlobalKey _captureKey = GlobalKey();
  final GlobalKey _accommodationButtonKey = GlobalKey();

  OverlayEntry? _toastOverlay;
  Timer? _toastTimer;

  bool _isSaving = false;

  @override
  void dispose() {
    _toastTimer?.cancel();

    _toastOverlay?.remove();
    _toastOverlay = null;

    super.dispose();
  }

  Future<void> _saveMoodResult() async {
    if (_isSaving) {
      return;
    }

    _isSaving = true;

    try {
      final boundary =
          _captureKey.currentContext?.findRenderObject()
              as RenderRepaintBoundary?;

      if (boundary == null) {
        if (mounted) {
          _showToast('갤러리 저장에 실패했어요.');
        }
        return;
      }

      final ui.Image image = await boundary.toImage(pixelRatio: 3);

      final byteData = await image.toByteData(format: ui.ImageByteFormat.png);

      if (byteData == null) {
        if (mounted) {
          _showToast('갤러리 저장에 실패했어요.');
        }
        return;
      }

      final bytes = byteData.buffer.asUint8List();

      final hasAccess = await Gal.hasAccess();

      if (!hasAccess) {
        final granted = await Gal.requestAccess();

        if (!granted) {
          if (mounted) {
            _showToast('사진 보관함 접근 권한이 필요해요.');
          }
          return;
        }
      }

      await Gal.putImageBytes(bytes, name: 'moodchon_mood_result');

      if (!mounted) {
        return;
      }

      _showToast('무드 결과가 갤러리에 저장되었어요.');
    } on GalException catch (_) {
      if (mounted) {
        _showToast('갤러리 저장에 실패했어요.');
      }
    } finally {
      _isSaving = false;
    }
  }

  void _showToast(String message) {
    _toastTimer?.cancel();

    _toastOverlay?.remove();
    _toastOverlay = null;

    const double toastHeight = 44;
    const double toastToButtonGap = 12;
    const double defaultToastTop = 775;
    const double minimumToastTop = 16;
    const double bottomMargin = 16;

    final overlay = Overlay.of(context);

    late final OverlayEntry overlayEntry;

    if (widget.showAccommodationButton) {
      final RenderBox? buttonRenderBox =
          _accommodationButtonKey.currentContext?.findRenderObject()
              as RenderBox?;

      if (buttonRenderBox == null) {
        return;
      }

      final Offset buttonPosition = buttonRenderBox.localToGlobal(Offset.zero);

      final double toastTop =
          buttonPosition.dy - toastHeight - toastToButtonGap;

      overlayEntry = OverlayEntry(
        builder: (context) {
          return Positioned(
            left: 16,
            right: 16,
            top: toastTop,
            child: Material(
              color: Colors.transparent,
              child: ToastBanner(message: message),
            ),
          );
        },
      );
    } else {
      final mediaQuery = MediaQuery.of(context);

      final double maximumToastTop =
          mediaQuery.size.height -
          mediaQuery.padding.bottom -
          toastHeight -
          bottomMargin;

      final double toastTop = math.max(
        minimumToastTop,
        math.min(defaultToastTop, maximumToastTop),
      );

      overlayEntry = OverlayEntry(
        builder: (context) {
          return Positioned(
            left: 16,
            right: 16,
            top: toastTop,
            child: Material(
              color: Colors.transparent,
              child: ToastBanner(message: message),
            ),
          );
        },
      );
    }

    _toastOverlay = overlayEntry;
    overlay.insert(overlayEntry);

    _toastTimer = Timer(const Duration(seconds: 2), () {
      _toastOverlay?.remove();
      _toastOverlay = null;
      _toastTimer = null;
    });
  }

  void _onAccommodationTap() {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (_) => const MoodAccommodationPage()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundSecondary,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            TopBar(
              type: TopBarType.title,
              title: '우리의 무드',
              onBack: () {
                Navigator.of(context).pop();
              },
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
                child: Column(
                  children: [
                    RepaintBoundary(
                      key: _captureKey,
                      child: MoodResultCard(
                        result: widget.result,
                        onDownload: _saveMoodResult,
                      ),
                    ),

                    if (widget.showAccommodationButton) ...[
                      const SizedBox(height: 17),
                      Container(
                        key: _accommodationButtonKey,
                        width: double.infinity,
                        child: GreenButton(
                          size: GreenButtonSize.long,
                          label: '무드 맞춤 숙소 보기',
                          onTap: _onAccommodationTap,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
