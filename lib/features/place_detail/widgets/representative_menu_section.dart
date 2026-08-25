import 'package:flutter/material.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_typography.dart';

class RepresentativeMenuSection extends StatelessWidget {
  const RepresentativeMenuSection({
    super.key,
    this.representativeMenu,
    this.handledMenus = const [],
  });

  final String? representativeMenu;
  final List<String> handledMenus;

  bool _hasValue(String? value) {
    return value != null && value.trim().isNotEmpty;
  }

  String? get _menuText {
    final menus = <String>[
      if (_hasValue(representativeMenu)) representativeMenu!.trim(),
      ...handledMenus
          .where((menu) => menu.trim().isNotEmpty)
          .map((menu) => menu.trim()),
    ];

    if (menus.isEmpty) {
      return null;
    }

    return menus.join(', ');
  }

  @override
  Widget build(BuildContext context) {
    final menuText = _menuText;

    if (menuText == null) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '대표 메뉴',
          style: AppTypography.titleMedium.copyWith(
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          menuText,
          style: AppTypography.tabMedium.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }
}
