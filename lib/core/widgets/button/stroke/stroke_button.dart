import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_interactions.dart';
import '../../../../app/theme/app_typography.dart';
import 'stroke_button_type.dart';

class StrokeButton extends StatefulWidget {
  const StrokeButton({
    super.key,
    required this.type,
    required this.text,
    required this.onTap,
  });

  final StrokeButtonType type;
  final String text;
  final VoidCallback onTap;

  @override
  State<StrokeButton> createState() => _StrokeButtonState();
}

class _StrokeButtonState extends State<StrokeButton> {
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
    switch (widget.type) {
      case StrokeButtonType.whiteSmall:
        return _buildWhiteSmall();
    }
  }

  Widget _buildWhiteSmall() {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTapDown: (_) => _setPressed(true),
      onTapUp: (_) => _setPressed(false),
      onTapCancel: () => _setPressed(false),
      onTap: widget.onTap,
      child: AnimatedScale(
        scale: _isPressed ? AppInteractions.pressedScale : 1,
        duration: AppInteractions.pressedDuration,
        child: Container(
          width: double.infinity,
          height: 29,
          decoration: BoxDecoration(
            color: AppColors.backgroundWhite,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: AppColors.main, width: 0.4),
          ),
          child: Stack(
            fit: StackFit.expand,
            children: [
              Center(
                child: Text(
                  widget.text,
                  style: AppTypography.tabLarge.copyWith(color: AppColors.main),
                ),
              ),
              if (_isPressed)
                DecoratedBox(
                  decoration: BoxDecoration(
                    color: AppColors.backgroundWhite.withValues(alpha: 0.14),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
