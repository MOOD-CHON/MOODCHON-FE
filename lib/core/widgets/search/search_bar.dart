import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../app/theme/app_colors.dart';
import '../base/search_field/search_field_base.dart';
import '../inputs/search_text_field.dart';
import 'clear_button.dart';

class MoodChonSearchBar extends StatefulWidget {
  const MoodChonSearchBar({
    super.key,
    required this.placeholder,
    this.onChanged,
    this.onSubmitted,
  });

  final String placeholder;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;

  @override
  State<MoodChonSearchBar> createState() => _MoodChonSearchBarState();
}

class _MoodChonSearchBarState extends State<MoodChonSearchBar> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  bool get _hasText => _controller.text.isNotEmpty;

  @override
  void initState() {
    super.initState();

    _controller.addListener(_handleTextChanged);
    _focusNode.addListener(_handleFocusChanged);
  }

  void _handleTextChanged() {
    setState(() {});
  }

  void _handleFocusChanged() {
    setState(() {});
  }

  void _handleClear() {
    _controller.clear();
    widget.onChanged?.call('');
    _focusNode.requestFocus();
  }

  @override
  void dispose() {
    _controller
      ..removeListener(_handleTextChanged)
      ..dispose();

    _focusNode
      ..removeListener(_handleFocusChanged)
      ..dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SearchFieldBase(
      child: Row(
        children: [
          SvgPicture.asset(
            'assets/icons/search/search.svg',
            width: 45,
            height: 45,
            colorFilter: const ColorFilter.mode(
              AppColors.black,
              BlendMode.srcIn,
            ),
          ),
          Expanded(
            child: SearchTextField(
              controller: _controller,
              focusNode: _focusNode,
              placeholder: widget.placeholder,
              isFocused: _focusNode.hasFocus,
              onChanged: (value) {
                widget.onChanged?.call(value);
              },
              onSubmitted: widget.onSubmitted,
            ),
          ),
          if (_hasText) ...[
            const SizedBox(width: 8),
            ClearButton(onTap: _handleClear),
            const SizedBox(width: 14.5),
          ] else
            const SizedBox(width: 14.5),
        ],
      ),
    );
  }
}
