import 'package:flutter/material.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_interactions.dart';
import '../../../app/theme/app_typography.dart';

class MemberCountStepper extends StatelessWidget {
  const MemberCountStepper({
    super.key,
    required this.count,
    required this.onChanged,
    this.minCount = 1,
    this.maxCount = 6,
  });

  final int count;
  final int minCount;
  final int maxCount;
  final ValueChanged<int> onChanged;

  bool get _canDecrease => count > minCount;
  bool get _canIncrease => count < maxCount;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _StepButton(
          label: '−',
          enabled: _canDecrease,
          onTap: () => onChanged(count - 1),
        ),
        SizedBox(
          width: 56,
          child: Text(
            '$count명',
            textAlign: TextAlign.center,
            style: AppTypography.bodyExtraLarge.copyWith(
              color: AppColors.black,
            ),
          ),
        ),
        _StepButton(
          label: '+',
          enabled: _canIncrease,
          onTap: () => onChanged(count + 1),
        ),
      ],
    );
  }
}

class _StepButton extends StatefulWidget {
  const _StepButton({
    required this.label,
    required this.enabled,
    required this.onTap,
  });

  final String label;
  final bool enabled;
  final VoidCallback onTap;

  @override
  State<_StepButton> createState() => _StepButtonState();
}

class _StepButtonState extends State<_StepButton> {
  bool _isPressed = false;

  void _setPressed(bool value) {
    if (!widget.enabled || _isPressed == value) {
      return;
    }

    setState(() {
      _isPressed = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      enabled: widget.enabled,
      label: widget.label == '+' ? '인원 늘리기' : '인원 줄이기',
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: widget.enabled ? widget.onTap : null,
        onTapDown: (_) => _setPressed(true),
        onTapUp: (_) => _setPressed(false),
        onTapCancel: () => _setPressed(false),
        child: AnimatedScale(
          scale: _isPressed ? AppInteractions.pressedScale : 1,
          duration: AppInteractions.pressedDuration,
          child: Container(
            width: 32,
            height: 32,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: AppColors.backgroundWhite,
              shape: BoxShape.circle,
              border: Border.all(
                color: widget.enabled ? AppColors.main : AppColors.linePrimary,
                width: 1.2,
              ),
            ),
            child: ExcludeSemantics(
              child: Text(
                widget.label,
                style: AppTypography.titleMedium.copyWith(
                  color: widget.enabled
                      ? AppColors.main
                      : AppColors.graySecondary,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
