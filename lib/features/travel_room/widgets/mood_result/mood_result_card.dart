import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_shadows.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../core/widgets/navigation/navigation_down_button.dart';
import '../../models/mood_result.dart';
import 'mood_image_collage.dart';
import 'mood_vote_result_item.dart';

class MoodResultCard extends StatelessWidget {
  const MoodResultCard({
    super.key,
    required this.result,
    required this.onDownload,
  });

  final MoodResult result;
  final VoidCallback onDownload;

  static const double _cardRadius = 30;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(_cardRadius),
        boxShadow: AppShadows.card,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(_cardRadius),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              color: AppColors.backgroundWhiteIvory,
              child: _buildMoodSection(),
            ),
            const _TicketDivider(),
            Container(
              width: double.infinity,
              color: AppColors.backgroundWhiteIvory,
              child: _buildVoteSection(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMoodSection() {
    return Padding(
      padding: const EdgeInsets.only(top: 18),
      child: Column(
        children: [
          Stack(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 7, left: 60, right: 60),
                child: SizedBox(
                  width: double.infinity,
                  child: Column(
                    children: [
                      Text(
                        '우리의 공통 무드는',
                        textAlign: TextAlign.center,
                        style: AppTypography.titleSmall.copyWith(
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 9),
                      Text(
                        result.moodName,
                        textAlign: TextAlign.center,
                        style: AppTypography.titleMood.copyWith(
                          color: AppColors.main,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                right: 15,
                top: 0,
                child: NavigationDownButton(onTap: onDownload),
              ),
            ],
          ),

          const SizedBox(height: 18),

          MoodImageCollage(imageUrls: result.imageUrls),

          // 하단 Tape 끝 기준 약 9.97
          const SizedBox(height: 9.97),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 43),
            child: Text(
              result.description,
              textAlign: TextAlign.center,
              style: AppTypography.bodyLarge.copyWith(
                color: AppColors.textPrimary,
              ),
            ),
          ),

          const SizedBox(height: 1.5),
        ],
      ),
    );
  }

  Widget _buildVoteSection() {
    final textStyle = AppTypography.bodyMedium.copyWith(
      color: AppColors.textPrimary,
    );

    double maxLabelWidth = 0;

    for (final voteResult in result.voteResults) {
      final textPainter = TextPainter(
        text: TextSpan(text: voteResult.tag, style: textStyle),
        textDirection: TextDirection.ltr,
        maxLines: 1,
      )..layout();

      if (textPainter.width > maxLabelWidth) {
        maxLabelWidth = textPainter.width;
      }
    }

    // 렌더링 잘림 방지를 위한 약간의 여유
    maxLabelWidth += 2;

    return Padding(
      padding: const EdgeInsets.only(top: 1.5, bottom: 24),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Text(
              '우리의 무드가 이렇게 만들어졌어요',
              textAlign: TextAlign.center,
              style: AppTypography.titleSmall.copyWith(
                color: AppColors.textPrimary,
              ),
            ),
          ),

          const SizedBox(height: 23),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Column(
              children: List.generate(result.voteResults.length, (index) {
                return Padding(
                  padding: EdgeInsets.only(
                    bottom: index == result.voteResults.length - 1 ? 0 : 10,
                  ),
                  child: MoodVoteResultItem(
                    result: result.voteResults[index],
                    memberCount: result.memberCount,
                    labelWidth: maxLabelWidth,
                  ),
                );
              }),
            ),
          ),

          const SizedBox(height: 23),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 22),
            child: Text(
              result.reason,
              textAlign: TextAlign.center,
              style: AppTypography.bodySmall.copyWith(
                color: AppColors.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TicketDivider extends StatelessWidget {
  const _TicketDivider();

  static const double _height = 52;
  static const double _notchSize = 49;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: _height,
      child: ClipPath(
        clipper: const _TicketDividerClipper(notchSize: _notchSize),
        child: Container(
          color: AppColors.backgroundWhiteIvory,
          child: Center(
            child: Padding(
              // 이전 43보다 훨씬 바깥까지 뻗도록 조정
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: SizedBox(
                width: double.infinity,
                height: 2,
                child: CustomPaint(
                  painter: _DashedLinePainter(
                    color: AppColors.linePrimary.withValues(alpha: 0.7),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _TicketDividerClipper extends CustomClipper<Path> {
  const _TicketDividerClipper({required this.notchSize});

  final double notchSize;

  @override
  Path getClip(Size size) {
    final double radius = notchSize / 2;
    final double centerY = size.height / 2;

    final Path cardPath = Path()
      ..addRect(Rect.fromLTWH(0, 0, size.width, size.height));

    final Path leftNotch = Path()
      ..addOval(Rect.fromCircle(center: Offset(0, centerY), radius: radius));

    final Path rightNotch = Path()
      ..addOval(
        Rect.fromCircle(center: Offset(size.width, centerY), radius: radius),
      );

    final Path notches = Path.combine(
      PathOperation.union,
      leftNotch,
      rightNotch,
    );

    return Path.combine(PathOperation.difference, cardPath, notches);
  }

  @override
  bool shouldReclip(covariant _TicketDividerClipper oldClipper) {
    return oldClipper.notchSize != notchSize;
  }
}

class _DashedLinePainter extends CustomPainter {
  const _DashedLinePainter({required this.color});

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    const double dashWidth = 6;
    const double dashGap = 6;

    final paint = Paint()
      ..color = color
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.butt;

    double currentX = 0;

    while (currentX < size.width) {
      final double endX = (currentX + dashWidth)
          .clamp(0.0, size.width)
          .toDouble();

      canvas.drawLine(
        Offset(currentX, size.height / 2),
        Offset(endX, size.height / 2),
        paint,
      );

      currentX += dashWidth + dashGap;
    }
  }

  @override
  bool shouldRepaint(covariant _DashedLinePainter oldDelegate) {
    return oldDelegate.color != color;
  }
}
