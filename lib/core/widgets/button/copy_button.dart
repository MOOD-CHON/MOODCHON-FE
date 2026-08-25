import 'package:flutter/material.dart';

import '../../../app/theme/app_interactions.dart';
import '../base/circle_button_background/circle_button_background_small.dart';
import '../icon/copy_icon.dart';

class CopyButton extends StatefulWidget {
  const CopyButton({super.key, required this.onTap});

  final VoidCallback onTap;

  @override
  State<CopyButton> createState() => _CopyButtonState();
}

class _CopyButtonState extends State<CopyButton> {
  bool _isPressed = false;

  void _setPressed(bool value) {
    if (_isPressed == value) return;

    setState(() {
      _isPressed = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTapDown: (_) => _setPressed(true),
      onTapUp: (_) => _setPressed(false),
      onTapCancel: () => _setPressed(false),
      onTap: widget.onTap,
      child: AnimatedScale(
        scale: _isPressed ? AppInteractions.pressedScale : 1.0,
        duration: AppInteractions.pressedDuration,
        child: const CircleButtonBackgroundSmall(child: CopyIcon()),
      ),
    );
  }
}
