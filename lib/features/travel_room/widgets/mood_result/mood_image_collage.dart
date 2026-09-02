import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../app/theme/app_colors.dart';

class MoodImageCollage extends StatelessWidget {
  const MoodImageCollage({super.key, required this.imageUrls});

  final List<String> imageUrls;

  static const double _imageWidth = 112.78;
  static const double _shortHeight = 75.66;
  static const double _longHeight = 127.06;
  static const double _gap = 4.28;
  static const double _radius = 6;

  static const double _collageWidth = 286;
  static const double _collageHeight = 235;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: _collageWidth,
      height: _collageHeight,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            left: 28,
            top: 0,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  children: [
                    _MoodImage(
                      imageUrl: _imageAt(0),
                      width: _imageWidth,
                      height: _shortHeight,
                    ),
                    const SizedBox(height: _gap),
                    _MoodImage(
                      imageUrl: _imageAt(2),
                      width: _imageWidth,
                      height: _longHeight,
                    ),
                  ],
                ),
                const SizedBox(width: _gap),
                Column(
                  children: [
                    _MoodImage(
                      imageUrl: _imageAt(1),
                      width: _imageWidth,
                      height: _longHeight,
                    ),
                    const SizedBox(height: _gap),
                    _MoodImage(
                      imageUrl: _imageAt(3),
                      width: _imageWidth,
                      height: _shortHeight,
                    ),
                  ],
                ),
              ],
            ),
          ),

          // 오른쪽 위 Tape
          Positioned(
            left: 220,
            top: -8,
            child: Transform.rotate(
              angle: _toRadians(25.54),
              alignment: Alignment.center,
              child: Opacity(
                opacity: 0.9,
                child: SvgPicture.asset(
                  'assets/icons/doodle/medium/active/tape.svg',
                ),
              ),
            ),
          ),

          // 왼쪽 Squiggle
          Positioned(
            left: 0,
            top: 61,
            child: SvgPicture.asset(
              'assets/icons/doodle/medium/active/squiggle_2.svg',
            ),
          ),

          // 왼쪽 아래 Tape
          Positioned(
            left: 0,
            top: 196,
            child: Transform.rotate(
              angle: _toRadians(25.54),
              alignment: Alignment.center,
              child: Opacity(
                opacity: 0.9,
                child: SvgPicture.asset(
                  'assets/icons/doodle/medium/active/tape.svg',
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String? _imageAt(int index) {
    if (index >= imageUrls.length) {
      return null;
    }

    final imageUrl = imageUrls[index];

    if (imageUrl.isEmpty) {
      return null;
    }

    return imageUrl;
  }

  double _toRadians(double degree) {
    return degree * math.pi / 180;
  }
}

class _MoodImage extends StatelessWidget {
  const _MoodImage({
    required this.imageUrl,
    required this.width,
    required this.height,
  });

  final String? imageUrl;
  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(MoodImageCollage._radius),
      child: SizedBox(
        width: width,
        height: height,
        child: imageUrl == null
            ? Container(color: AppColors.linePrimary)
            : Image.network(
                imageUrl!,
                width: width,
                height: height,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) {
                  return Container(color: AppColors.linePrimary);
                },
              ),
      ),
    );
  }
}
