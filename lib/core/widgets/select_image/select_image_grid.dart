import 'package:flutter/material.dart';

import 'select_image.dart';
import 'select_image_mode.dart';
import 'select_image_size.dart';

class SelectImageGridItem {
  const SelectImageGridItem({required this.id, this.imageUrl, this.tag});

  final String id;
  final String? imageUrl;
  final String? tag;
}

class SelectImageGrid extends StatelessWidget {
  const SelectImageGrid({
    super.key,
    required this.items,
    required this.mode,
    this.selectedIds = const {},
    this.onSelected,
    this.onExploreTap,
  });

  final List<SelectImageGridItem> items;
  final SelectImageMode mode;

  final Set<String> selectedIds;

  final void Function(String id, bool selected)? onSelected;

  final ValueChanged<String>? onExploreTap;

  static const double _columnGap = 5;
  static const double _itemGap = 6;

  static const List<SelectImageSize> _leftPattern = [
    SelectImageSize.large,
    SelectImageSize.small,
    SelectImageSize.medium,
    SelectImageSize.small,
    SelectImageSize.small,
    SelectImageSize.medium,
    SelectImageSize.small,
    SelectImageSize.large,
  ];

  static const List<SelectImageSize> _rightPattern = [
    SelectImageSize.small,
    SelectImageSize.large,
    SelectImageSize.small,
    SelectImageSize.medium,
    SelectImageSize.medium,
    SelectImageSize.small,
    SelectImageSize.large,
    SelectImageSize.small,
  ];

  @override
  Widget build(BuildContext context) {
    final leftItems = <Widget>[];
    final rightItems = <Widget>[];

    for (var index = 0; index < items.length; index++) {
      final item = items[index];

      final isLeftColumn = index.isEven;
      final patternIndex = index ~/ 2;

      final size = isLeftColumn
          ? _leftPattern[patternIndex % _leftPattern.length]
          : _rightPattern[patternIndex % _rightPattern.length];

      final image = SelectImage(
        size: size,
        mode: mode,
        imageUrl: item.imageUrl,
        tag: item.tag,
        selected: selectedIds.contains(item.id),
        onSelected: mode == SelectImageMode.selectable
            ? (selected) {
                onSelected?.call(item.id, selected);
              }
            : null,
        onTap: mode == SelectImageMode.explore
            ? () {
                onExploreTap?.call(item.id);
              }
            : null,
      );

      if (isLeftColumn) {
        leftItems.add(image);
      } else {
        rightItems.add(image);
      }
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(child: Column(children: _withSpacing(leftItems))),
        const SizedBox(width: _columnGap),
        Expanded(child: Column(children: _withSpacing(rightItems))),
      ],
    );
  }

  List<Widget> _withSpacing(List<Widget> children) {
    if (children.isEmpty) {
      return const [];
    }

    return [
      for (var index = 0; index < children.length; index++) ...[
        children[index],
        if (index != children.length - 1) const SizedBox(height: _itemGap),
      ],
    ];
  }
}
