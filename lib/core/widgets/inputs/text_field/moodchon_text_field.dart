import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_typography.dart';
import 'text_field_size.dart';

class MoodChonTextField extends StatefulWidget {
  const MoodChonTextField({
    super.key,
    required this.size,
    required this.placeholder,
    this.controller,
    this.onChanged,
    this.onSubmitted,
    this.hasError = false,
  });

  final MoodChonTextFieldSize size;
  final String placeholder;
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final bool hasError;

  @override
  State<MoodChonTextField> createState() => _MoodChonTextFieldState();
}

class _MoodChonTextFieldState extends State<MoodChonTextField> {
  late TextEditingController _controller;
  final FocusNode _focusNode = FocusNode();

  late bool _ownsController;

  bool get _isFocused => _focusNode.hasFocus;
  bool get _hasText => _controller.text.isNotEmpty;

  bool get _showError =>
      widget.size == MoodChonTextFieldSize.long && widget.hasError;

  @override
  void initState() {
    super.initState();

    _ownsController = widget.controller == null;
    _controller = widget.controller ?? TextEditingController();

    _controller.addListener(_handleTextChanged);
    _focusNode.addListener(_handleFocusChanged);
  }

  @override
  void didUpdateWidget(covariant MoodChonTextField oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.controller != widget.controller) {
      _controller.removeListener(_handleTextChanged);

      if (_ownsController) {
        _controller.dispose();
      }

      _ownsController = widget.controller == null;
      _controller = widget.controller ?? TextEditingController();

      _controller.addListener(_handleTextChanged);
    }
  }

  void _handleTextChanged() {
    setState(() {});
  }

  void _handleFocusChanged() {
    setState(() {});
  }

  @override
  void dispose() {
    _controller.removeListener(_handleTextChanged);
    _focusNode.removeListener(_handleFocusChanged);

    if (_ownsController) {
      _controller.dispose();
    }

    _focusNode.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final borderColor = _showError
        ? AppColors.statusError
        : AppColors.linePrimary;

    return Container(
      width: double.infinity,
      height: 47,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: AppColors.backgroundWhite,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: borderColor, width: 1.2),
      ),
      child: TextField(
        controller: _controller,
        focusNode: _focusNode,
        onChanged: widget.onChanged,
        onSubmitted: widget.onSubmitted,
        maxLines: 1,
        cursorColor: AppColors.black,
        cursorHeight: 16,
        cursorWidth: 1.5,
        style: AppTypography.bodyExtraLarge.copyWith(color: AppColors.black),
        decoration: InputDecoration(
          isCollapsed: true,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 15,
            vertical: 15,
          ),
          hintText: _isFocused || _hasText ? null : widget.placeholder,
          hintStyle: AppTypography.bodyExtraLarge.copyWith(
            color: AppColors.black.withValues(alpha: 0.4),
          ),
        ),
      ),
    );
  }
}
