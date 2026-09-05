import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_interactions.dart';
import '../../../app/theme/app_shadows.dart';
import '../../../app/theme/app_typography.dart';

enum SocialLoginProvider { kakao, apple }

class SocialLoginButton extends StatefulWidget {
  const SocialLoginButton({
    super.key,
    required this.provider,
    required this.onTap,
  });

  final SocialLoginProvider provider;
  final VoidCallback onTap;

  @override
  State<SocialLoginButton> createState() => _SocialLoginButtonState();
}

class _SocialLoginButtonState extends State<SocialLoginButton> {
  bool _isPressed = false;

  bool get _isKakao => widget.provider == SocialLoginProvider.kakao;

  String get _label => _isKakao ? '카카오톡으로 계속하기' : 'Apple로 계속하기';

  Color get _backgroundColor => _isKakao ? AppColors.kakao : AppColors.black;

  Color get _foregroundColor =>
      _isKakao ? AppColors.black : AppColors.backgroundWhite;

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
      label: _label,
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
            width: double.infinity,
            height: 49,
            child: Stack(
              children: [
                Positioned.fill(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: _backgroundColor,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: AppShadows.base,
                    ),
                  ),
                ),
                Center(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _SocialLoginIcon(provider: widget.provider),
                      const SizedBox(width: 10),
                      ExcludeSemantics(
                        child: Text(
                          _label,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTypography.bodyExtraLarge.copyWith(
                            color: _foregroundColor,
                          ),
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
                          borderRadius: BorderRadius.circular(12),
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

class _SocialLoginIcon extends StatelessWidget {
  const _SocialLoginIcon({required this.provider});

  final SocialLoginProvider provider;

  @override
  Widget build(BuildContext context) {
    switch (provider) {
      case SocialLoginProvider.kakao:
        return SvgPicture.asset(
          'assets/icons/social/kakao_bubble.svg',
          width: 20,
          height: 18.34,
          excludeFromSemantics: true,
        );

      case SocialLoginProvider.apple:
        return const Icon(Icons.apple, color: AppColors.backgroundWhite);
    }
  }
}
