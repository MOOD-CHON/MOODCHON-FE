import 'package:flutter/material.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_typography.dart';

class SearchTextField extends StatelessWidget {
  const SearchTextField({
    super.key,
    required this.controller,
    required this.focusNode,
    required this.placeholder,
    required this.isFocused,
    required this.onChanged,
    this.onSubmitted,
  });

  final TextEditingController controller;
  final FocusNode focusNode;
  final String placeholder;
  final bool isFocused;
  final ValueChanged<String> onChanged;
  final ValueChanged<String>? onSubmitted;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      focusNode: focusNode,
      onChanged: onChanged,
      onSubmitted: onSubmitted,
      textInputAction: TextInputAction.search,
      maxLines: 1,

      cursorColor: AppColors.black,
      cursorHeight: 14,
      cursorWidth: 1.3,

      style: AppTypography.bodyExtraLarge.copyWith(color: AppColors.black),

      decoration: InputDecoration(
        isCollapsed: true,
        border: InputBorder.none,
        hintText: isFocused ? null : placeholder,
        hintStyle: AppTypography.bodyExtraLarge.copyWith(
          color: AppColors.black.withValues(alpha: 0.4),
        ),
      ),
    );
  }
}
