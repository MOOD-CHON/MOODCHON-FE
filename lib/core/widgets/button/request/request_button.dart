import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_interactions.dart';
import '../../../../app/theme/app_shadows.dart';
import '../../../../app/theme/app_typography.dart';

class RequestButton extends StatefulWidget {
  const RequestButton({super.key, required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  State<RequestButton> createState() => _RequestButtonState();
}

class _RequestButtonState extends State<RequestButton> {
  bool _pressed = false;

  void _setPressed(bool value) {
    if (_pressed == value) {
      return;
    }

    setState(() {
      _pressed = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: widget.label,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTapDown: (_) => _setPressed(true),
        onTapCancel: () => _setPressed(false),
        onTapUp: (_) {
          _setPressed(false);
          widget.onTap();
        },
        child: AnimatedScale(
          scale: _pressed ? AppInteractions.pressedScale : 1,
          duration: AppInteractions.pressedDuration,
          child: Container(
            width: 95,
            height: 29,
            decoration: BoxDecoration(
              color: AppColors.greenTab,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppColors.main, width: 0.4),
              boxShadow: AppShadows.base,
            ),
            child: Stack(
              fit: StackFit.expand,
              children: [
                Center(
                  child: Text(
                    widget.label,
                    textAlign: TextAlign.center,
                    style: AppTypography.tabLarge.copyWith(
                      color: AppColors.main,
                    ),
                  ),
                ),
                if (_pressed)
                  DecoratedBox(
                    decoration: BoxDecoration(
                      color: AppColors.backgroundWhite.withValues(alpha: 0.14),
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
