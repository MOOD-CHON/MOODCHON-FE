import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_typography.dart';

enum AccommodationMatchSectionType { good, regret }

class AccommodationMatchSection extends StatelessWidget {
  const AccommodationMatchSection({
    super.key,
    required this.type,
    required this.reasons,
  });

  final AccommodationMatchSectionType type;
  final List<String> reasons;

  bool get _isGood => type == AccommodationMatchSectionType.good;

  String get _title => _isGood ? '이런 점이 우리 무드랑 잘 맞아요.' : '이런 점이 우리 무드와 아쉬워요.';

  String get _iconPath => _isGood
      ? 'assets/icons/select/large.svg'
      : 'assets/icons/nonselect/large.svg';

  Color get _backgroundColor =>
      _isGood ? AppColors.greenTab : AppColors.backgroundRed;

  String _normalizeReason(String reason) {
    final trimmed = reason.trim();

    if (trimmed.startsWith('-')) {
      return trimmed;
    }

    return '- $trimmed';
  }

  @override
  Widget build(BuildContext context) {
    final visibleReasons = reasons
        .map((reason) => reason.trim())
        .where((reason) => reason.isNotEmpty)
        .toList();

    if (visibleReasons.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SvgPicture.asset(_iconPath),

            const SizedBox(width: 4),

            Expanded(
              child: Text(
                _title,
                style: AppTypography.titleMedium.copyWith(
                  color: AppColors.textPrimary,
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 7),

        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: _backgroundColor,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: List.generate(visibleReasons.length, (index) {
              return Padding(
                padding: EdgeInsets.only(
                  bottom: index == visibleReasons.length - 1 ? 0 : 6,
                ),
                child: Text(
                  _normalizeReason(visibleReasons[index]),
                  style: AppTypography.captionExtraSmall.copyWith(
                    color: AppColors.textPrimary,
                    fontSize: 11,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              );
            }),
          ),
        ),
      ],
    );
  }
}
