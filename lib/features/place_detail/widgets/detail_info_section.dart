import 'package:flutter/material.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_typography.dart';

class DetailInfoItem {
  const DetailInfoItem({
    required this.label,
    required this.value,
    this.isLink = false,
    this.onTap,
  });

  final String label;
  final String? value;
  final bool isLink;
  final VoidCallback? onTap;
}

class DetailInfoSection extends StatelessWidget {
  const DetailInfoSection({
    super.key,
    required this.title,
    required this.items,
  });

  final String title;
  final List<DetailInfoItem> items;

  bool _hasValue(String? value) {
    return value != null && value.trim().isNotEmpty;
  }

  double _calculateLabelWidth(
    BuildContext context,
    List<DetailInfoItem> items,
  ) {
    var maxWidth = 0.0;

    for (final item in items) {
      final painter = TextPainter(
        text: TextSpan(
          text: '${item.label}:',
          style: AppTypography.tabMedium.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
        textDirection: TextDirection.ltr,
        maxLines: 1,
      )..layout();

      if (painter.width > maxWidth) {
        maxWidth = painter.width;
      }
    }

    return maxWidth.ceilToDouble() + 1;
  }

  @override
  Widget build(BuildContext context) {
    final visibleItems = items.where((item) => _hasValue(item.value)).toList();

    if (visibleItems.isEmpty) {
      return const SizedBox.shrink();
    }

    final labelWidth = _calculateLabelWidth(context, visibleItems);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppTypography.titleMedium.copyWith(
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 12),
        ...List.generate(visibleItems.length, (index) {
          final item = visibleItems[index];

          return Padding(
            padding: EdgeInsets.only(
              bottom: index == visibleItems.length - 1 ? 0 : 4,
            ),
            child: _DetailInfoRow(item: item, labelWidth: labelWidth),
          );
        }),
      ],
    );
  }
}

class _DetailInfoRow extends StatelessWidget {
  const _DetailInfoRow({required this.item, required this.labelWidth});

  final DetailInfoItem item;
  final double labelWidth;

  @override
  Widget build(BuildContext context) {
    final valueText = Text(
      item.value!,
      style: AppTypography.tabMedium.copyWith(
        color: AppColors.textSecondary,
        decoration: item.isLink
            ? TextDecoration.underline
            : TextDecoration.none,
        decorationColor: item.isLink ? AppColors.textSecondary : null,
      ),
    );

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: labelWidth,
          child: Text(
            '${item.label}:',
            maxLines: 1,
            softWrap: false,
            overflow: TextOverflow.visible,
            style: AppTypography.tabMedium.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ),
        const SizedBox(width: 9),
        Expanded(
          child: item.onTap == null
              ? valueText
              : GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: item.onTap,
                  child: valueText,
                ),
        ),
      ],
    );
  }
}
