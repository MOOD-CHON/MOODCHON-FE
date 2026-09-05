import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_interactions.dart';
import '../../../app/theme/app_typography.dart';

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
  static const double _exportOverflow = 15;

  bool _isPressed = false;

  bool get _isCreate => widget.type == HomeQuickActionType.create;

  String get _caption => _isCreate ? '우리의 무드로' : '초대코드로';

  String get _title => _isCreate ? '촌캉스 만들기' : '참여하기';

  Color get _textColor =>
      _isCreate ? AppColors.greenTab : AppColors.textPrimary;

  String get _assetPath => _isCreate
      ? 'assets/images/home/quick_action_create.svg'
      : 'assets/images/home/quick_action_join.svg';

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
                Positioned(
                  left: -_exportOverflow,
                  top: -_exportOverflow,
                  right: -_exportOverflow,
                  bottom: -_exportOverflow,
                  child: IgnorePointer(
                    child: SvgPicture.asset(_assetPath, fit: BoxFit.fill),
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
                          height: 1,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _title,
                        style: AppTypography.titleSmall.copyWith(
                          color: _textColor,
                          height: 1,
                        ),
                      ),
                    ],
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
