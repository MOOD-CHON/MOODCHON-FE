import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../app/theme/app_colors.dart';
import '../base/circle_button_background/circle_button_background_large.dart';

class NavigationIconButton extends StatefulWidget {
  const NavigationIconButton({
    super.key,
    required this.iconPath,
    required this.onTap,
  });

  final String iconPath;
  final VoidCallback onTap;

  @override
  State<NavigationIconButton> createState() => _NavigationIconButtonState();
}

class _NavigationIconButtonState extends State<NavigationIconButton> {
  static const double _pressedScale = 1.04;
  static const Duration _animationDuration = Duration(milliseconds: 100);

  bool _isPressed = false;

  void _setPressed(bool value) {
    setState(() {
      _isPressed = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      onTapDown: (_) => _setPressed(true),
      onTapUp: (_) => _setPressed(false),
      onTapCancel: () => _setPressed(false),
      child: AnimatedScale(
        scale: _isPressed ? _pressedScale : 1.0,
        duration: _animationDuration,
        child: CircleButtonBackgroundLarge(
          child: SvgPicture.asset(
            widget.iconPath,
            width: 45,
            height: 45,
            colorFilter: const ColorFilter.mode(
              AppColors.black,
              BlendMode.srcIn,
            ),
          ),
        ),
      ),
    );
  }
}
