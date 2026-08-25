import 'package:flutter/material.dart';

import '../../../app/theme/app_colors.dart';
import '../../../core/widgets/image_count/image_count_badge.dart';

class PlaceImageCarousel extends StatefulWidget {
  const PlaceImageCarousel({super.key, required this.imagePaths});

  final List<String> imagePaths;

  @override
  State<PlaceImageCarousel> createState() => _PlaceImageCarouselState();
}

class _PlaceImageCarouselState extends State<PlaceImageCarousel> {
  final PageController _pageController = PageController();

  int _currentIndex = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.imagePaths.isEmpty) {
      return const SizedBox(
        width: double.infinity,
        height: 387,
        child: ColoredBox(color: AppColors.linePrimary),
      );
    }

    return SizedBox(
      width: double.infinity,
      height: 387,
      child: Stack(
        children: [
          Positioned.fill(
            child: PageView.builder(
              controller: _pageController,
              itemCount: widget.imagePaths.length,
              onPageChanged: (index) {
                setState(() {
                  _currentIndex = index;
                });
              },
              itemBuilder: (context, index) {
                final imagePath = widget.imagePaths[index];

                if (imagePath.trim().isEmpty) {
                  return const ColoredBox(color: AppColors.linePrimary);
                }

                return Image.asset(imagePath, fit: BoxFit.cover);
              },
            ),
          ),

          Positioned(
            right: 16,

            // 상세 흰색 영역 시작점 기준 16px 위
            bottom: 55,

            child: ImageCountBadge(
              current: _currentIndex + 1,
              total: widget.imagePaths.length,
            ),
          ),
        ],
      ),
    );
  }
}
