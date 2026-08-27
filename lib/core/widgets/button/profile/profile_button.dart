import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_interactions.dart';
import '../../../../app/theme/app_typography.dart';

class ProfileButton extends StatefulWidget {
  const ProfileButton({super.key, required this.text, required this.onTap});

  final String text;
  final VoidCallback onTap;

  @override
  State<ProfileButton> createState() => _ProfileButtonState();
}

class _ProfileButtonState extends State<ProfileButton> {
  bool _isPressed = false;

  void _setPressed(bool value) {
    if (_isPressed == value) {
      return;
    }

    setState(() {
      _isPressed = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: widget.onTap,
      onTapDown: (_) {
        _setPressed(true);
      },
      onTapUp: (_) {
        _setPressed(false);
      },
      onTapCancel: () {
        _setPressed(false);
      },
      child: AnimatedScale(
        scale: _isPressed ? AppInteractions.pressedScale : 1,
        duration: AppInteractions.pressedDuration,
        child: Stack(
          children: [
            Container(
              width: 107,
              height: 29,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: AppColors.backgroundWhite,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppColors.main, width: 1),
              ),
              child: Text(
                widget.text,
                style: AppTypography.bodyProfile.copyWith(
                  color: AppColors.main,
                ),
              ),
            ),
            if (_isPressed)
              Positioned.fill(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: AppColors.backgroundWhite.withValues(alpha: 0.14),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
