import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_interactions.dart';
import '../../../../app/theme/app_typography.dart';
import 'confirm_modal_button_type.dart';

class ConfirmModalButton extends StatefulWidget {
  const ConfirmModalButton({
    super.key,
    required this.type,
    required this.label,
    required this.onTap,
  });

  final ConfirmModalButtonType type;
  final String label;
  final VoidCallback onTap;

  @override
  State<ConfirmModalButton> createState() => _ConfirmModalButtonState();
}

class _ConfirmModalButtonState extends State<ConfirmModalButton> {
  bool _isPressed = false;

  void _setPressed(bool value) {
    if (_isPressed == value) return;

    setState(() {
      _isPressed = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isGray = widget.type == ConfirmModalButtonType.gray;
    final isLong = widget.type == ConfirmModalButtonType.long;

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
          width: isLong ? 283 : 135,
          height: 43,
          decoration: BoxDecoration(
            color: isGray ? AppColors.linePrimary : AppColors.main,
            borderRadius: BorderRadius.circular(30),
          ),
          child: Stack(
            fit: StackFit.expand,
            children: [
              Center(
                child: Text(
                  widget.label,
                  style: AppTypography.bodyExtraLarge.copyWith(
                    color: isGray
                        ? AppColors.black.withValues(alpha: 0.50)
                        : AppColors.backgroundIvory,
                  ),
                ),
              ),
              if (_isPressed)
                DecoratedBox(
                  decoration: BoxDecoration(
                    color: AppColors.backgroundWhite.withValues(alpha: 0.14),
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
