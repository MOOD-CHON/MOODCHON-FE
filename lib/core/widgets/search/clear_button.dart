import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ClearButton extends StatefulWidget {
  const ClearButton({super.key, required this.onTap});

  final VoidCallback onTap;

  @override
  State<ClearButton> createState() => _ClearButtonState();
}

class _ClearButtonState extends State<ClearButton> {
  bool _isPressed = false;

  void _setPressed(bool value) {
    setState(() {
      _isPressed = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: '검색어 지우기',
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTapDown: (_) => _setPressed(true),
        onTapUp: (_) => _setPressed(false),
        onTapCancel: () => _setPressed(false),
        onTap: widget.onTap,
        child: SizedBox(
          width: 17,
          height: 17,
          child: SvgPicture.asset(
            _isPressed
                ? 'assets/icons/search/clear_click.svg'
                : 'assets/icons/search/clear_default.svg',
          ),
        ),
      ),
    );
  }
}
