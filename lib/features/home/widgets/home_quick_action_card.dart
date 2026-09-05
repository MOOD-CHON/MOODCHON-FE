import 'package:flutter/material.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_interactions.dart';
import '../../../app/theme/app_shadows.dart';
import '../../../app/theme/app_typography.dart';
import '../../../core/widgets/border/wiggly_border.dart';
import '../../../core/widgets/character/character.dart';
import '../../../core/widgets/character/character_size.dart';
import '../../../core/widgets/character/character_type.dart';

enum HomeQuickActionType { create, join }

class HomeQuickActionCard extends StatefulWidget {
  const HomeQuickActionCard({
    super.key,
    required this.type,
    required this.onTap,
  });

  final HomeQuickActionType type;
  final VoidCallback onTap;

  @override
  State<HomeQuickActionCard> createState() => _HomeQuickActionCardState();
}

class _HomeQuickActionCardState extends State<HomeQuickActionCard> {
  static const double _height = 110;
  static const double _radius = 20;

  bool _isPressed = false;

  bool get _isCreate => widget.type == HomeQuickActionType.create;

  String get _caption => _isCreate ? '우리의 무드로' : '초대코드로';

  String get _title => _isCreate ? '촌캉스 만들기' : '참여하기';

  Color get _backgroundColor => _isCreate ? AppColors.main : AppColors.greenTab;

  Color get _borderColor => _isCreate ? AppColors.greenTab : AppColors.main;

  Color get _textColor =>
      _isCreate ? AppColors.greenTab : AppColors.textPrimary;

  CharacterType get _characterType =>
      _isCreate ? CharacterType.greeting : CharacterType.letter;

  double get _characterLeft => _isCreate ? 80.5 : 72.5;

  double get _characterTop => _isCreate ? 32.5 : 25.5;

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
    return Semantics(
      button: true,
      label: _title,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: widget.onTap,
        onTapDown: (_) => _setPressed(true),
        onTapUp: (_) => _setPressed(false),
        onTapCancel: () => _setPressed(false),
        child: AnimatedScale(
          scale: _isPressed ? AppInteractions.pressedScale : 1,
          duration: AppInteractions.pressedDuration,
          child: SizedBox(
            height: _height,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Positioned.fill(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: _backgroundColor,
                      borderRadius: BorderRadius.circular(_radius),
                      border: Border.all(color: _borderColor),
                      boxShadow: AppShadows.base,
                    ),
                  ),
                ),
                Positioned.fill(
                  child: IgnorePointer(
                    child: CustomPaint(
                      foregroundPainter: WigglyBorderPainter(
                        color: _borderColor,
                        radius: _radius,
                        strokeWidth: 1,
                        amplitude: 0.7,
                        drawOutside: true,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  left: 18,
                  top: 18,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _caption,
                        style: AppTypography.tabSmall.copyWith(
                          color: _textColor,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _title,
                        style: AppTypography.titleSmall.copyWith(
                          color: _textColor,
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  left: _characterLeft,
                  top: _characterTop,
                  child: Character(
                    type: _characterType,
                    size: CharacterSize.medium,
                    width: 108,
                    height: 108,
                  ),
                ),
                if (_isPressed)
                  Positioned.fill(
                    child: IgnorePointer(
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          color: AppColors.backgroundWhite.withValues(
                            alpha: 0.14,
                          ),
                          borderRadius: BorderRadius.circular(_radius),
                        ),
                      ),
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
