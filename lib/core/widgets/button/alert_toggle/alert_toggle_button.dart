import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_shadows.dart';

class AlertToggleButton extends StatelessWidget {
  const AlertToggleButton({
    super.key,
    required this.value,
    required this.onChanged,
  });

  final bool value;
  final ValueChanged<bool> onChanged;

  static const double _width = 48;
  static const double _height = 19;
  static const double _thumbWidth = 24;
  static const double _thumbHeight = 15;
  static const double _thumbPadding = 2;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      toggled: value,
      label: '알림 받기',
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          onChanged(!value);
        },
        child: Container(
          width: _width,
          height: _height,
          decoration: BoxDecoration(
            color: value ? AppColors.main : AppColors.linePrimary,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Stack(
            children: [
              AnimatedPositioned(
                duration: const Duration(milliseconds: 180),
                curve: Curves.easeOut,
                left: value ? 22 : _thumbPadding,
                top: _thumbPadding,
                child: Container(
                  width: _thumbWidth,
                  height: _thumbHeight,
                  decoration: BoxDecoration(
                    color: AppColors.backgroundWhite,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: AppShadows.base,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
