import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_interactions.dart';
import '../../../../app/theme/app_shadows.dart';
import '../../../../app/theme/app_typography.dart';
import 'half_button_type.dart';

class HalfButton extends StatefulWidget {
  const HalfButton({
    super.key,
    required this.type,
    required this.label,
    required this.onTap,
    this.disabled = false,
  });

  final HalfButtonType type;
  final String label;
  final VoidCallback onTap;
  final bool disabled;

  @override
  State<HalfButton> createState() => _HalfButtonState();
}

class _HalfButtonState extends State<HalfButton> {
  bool _pressed = false;

  bool get _isFull => widget.type == HalfButtonType.full;

  double get _height {
    if (widget.disabled) {
      return 49;
    }

    return _isFull ? 48 : 49;
  }

  void _updatePressed(bool value) {
    if (widget.disabled) {
      return;
    }

    setState(() {
      _pressed = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    final backgroundColor = widget.disabled
        ? AppColors.buttonPrimary
        : _isFull
        ? AppColors.main
        : AppColors.backgroundWhite;

    final textColor = widget.disabled
        ? AppColors.graySecondary
        : _isFull
        ? AppColors.backgroundIvory
        : AppColors.main;

    final borderColor = widget.disabled
        ? AppColors.graySecondary
        : _isFull
        ? Colors.transparent
        : AppColors.main;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTapDown: widget.disabled
          ? null
          : (_) {
              _updatePressed(true);
            },
      onTapUp: widget.disabled
          ? null
          : (_) {
              _updatePressed(false);
              widget.onTap();
            },
      onTapCancel: widget.disabled
          ? null
          : () {
              _updatePressed(false);
            },
      child: AnimatedScale(
        scale: _pressed ? AppInteractions.pressedScale : 1,
        duration: AppInteractions.pressedDuration,
        child: SizedBox(
          width: double.infinity,
          height: _height,
          child: Stack(
            fit: StackFit.expand,
            children: [
              DecoratedBox(
                decoration: BoxDecoration(
                  color: backgroundColor,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: borderColor,
                    width: widget.disabled || !_isFull ? 1 : 0,
                  ),
                  boxShadow: AppShadows.base,
                ),
                child: Center(
                  child: Text(
                    widget.label,
                    style: AppTypography.bodyExtraLarge.copyWith(
                      color: textColor,
                    ),
                  ),
                ),
              ),

              if (_pressed)
                DecoratedBox(
                  decoration: BoxDecoration(
                    color: AppColors.backgroundWhite.withValues(alpha: 0.14),
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
