import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../app/theme/app_colors.dart';
import '../tag/image_tag.dart';
import 'select_image_mode.dart';
import 'select_image_size.dart';

class SelectImage extends StatelessWidget {
  const SelectImage({
    super.key,
    required this.size,
    required this.mode,
    this.imageUrl,
    this.tag,
    this.selected = false,
    this.onSelected,
    this.onTap,
  }) : assert(
         mode != SelectImageMode.selectable || onSelected != null,
         'Selectable SelectImage에는 onSelected가 필요합니다.',
       ),
       assert(
         mode != SelectImageMode.explore || onTap != null,
         'Explore SelectImage에는 onTap이 필요합니다.',
       );

  final SelectImageSize size;
  final SelectImageMode mode;

  final String? imageUrl;
  final String? tag;

  final bool selected;
  final ValueChanged<bool>? onSelected;
  final VoidCallback? onTap;

  static const double _designWidth = 178;
  static const double _radius = 16;
  static const double _selectedBorderWidth = 2;

  static const double _selectIconInset = 10;
  static const double _tagInset = 7;

  double get _designHeight {
    switch (size) {
      case SelectImageSize.small:
        return 124;
      case SelectImageSize.medium:
        return 169;
      case SelectImageSize.large:
        return 186;
    }
  }

  bool get _isSelectable => mode == SelectImageMode.selectable;

  bool get _showSelectedState => _isSelectable && selected;

  VoidCallback get _handleTap {
    if (_isSelectable) {
      return () => onSelected!(!selected);
    }

    return onTap!;
  }

  Widget _buildImage() {
    if (imageUrl == null || imageUrl!.isEmpty) {
      return Container(color: AppColors.linePrimary);
    }

    return Image.network(
      imageUrl!,
      width: double.infinity,
      height: double.infinity,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) {
        return Container(color: AppColors.linePrimary);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final aspectRatio = _designWidth / _designHeight;

    return Semantics(
      button: true,
      selected: _isSelectable ? selected : null,
      label: _isSelectable
          ? selected
                ? '선택된 이미지'
                : '선택 가능한 이미지'
          : tag ?? '탐색 이미지',
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: _handleTap,
        child: AspectRatio(
          aspectRatio: aspectRatio,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(_radius),
            child: Stack(
              fit: StackFit.expand,
              children: [
                _buildImage(),

                if (_showSelectedState)
                  Container(color: AppColors.black.withValues(alpha: 0.3)),

                if (_showSelectedState)
                  Positioned.fill(
                    child: IgnorePointer(
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(_radius),
                          border: Border.all(
                            color: AppColors.greenIcon,
                            width: _selectedBorderWidth,
                          ),
                        ),
                      ),
                    ),
                  ),

                if (_showSelectedState)
                  Positioned(
                    right: _selectIconInset,
                    bottom: _selectIconInset,
                    child: ExcludeSemantics(
                      child: SvgPicture.asset('assets/icons/select/large.svg'),
                    ),
                  ),

                if (mode == SelectImageMode.explore && tag != null)
                  Positioned(
                    left: _tagInset,
                    right: _tagInset,
                    bottom: _tagInset,
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: ImageTag(label: tag!),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
