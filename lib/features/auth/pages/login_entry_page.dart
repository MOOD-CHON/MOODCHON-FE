import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_typography.dart';
import '../../../core/widgets/character/character.dart';
import '../../../core/widgets/character/character_size.dart';
import '../../../core/widgets/character/character_type.dart';
import 'legal_document_page.dart';
import '../widgets/social_login_button.dart';

class LoginEntryPage extends StatelessWidget {
  const LoginEntryPage({
    super.key,
    this.onKakaoLogin,
    this.onAppleLogin,
    this.onTermsTap,
    this.onPrivacyTap,
  });

  final VoidCallback? onKakaoLogin;
  final VoidCallback? onAppleLogin;
  final VoidCallback? onTermsTap;
  final VoidCallback? onPrivacyTap;

  static const double _designWidth = 393;
  static const double _designHeight = 852;
  static const double _loginButtonHeight = 49;
  static const double _loginButtonGap = 15;

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        backgroundColor: AppColors.black,
        body: LayoutBuilder(
          builder: (context, constraints) {
            final width = constraints.maxWidth;
            final height = constraints.maxHeight;
            final horizontalPadding = _scaled(width, 24, _designWidth);
            final buttonWidth = (width - horizontalPadding * 2)
                .clamp(0.0, 345.0)
                .toDouble();
            final contentLeft = (width - buttonWidth) / 2;

            return Stack(
              fit: StackFit.expand,
              children: [
                const _LoginBackground(),
                Positioned(
                  top: _scaled(height, 217, _designHeight),
                  left: 0,
                  right: 0,
                  child: const _LoginBranding(),
                ),
                Positioned(
                  left: contentLeft,
                  right: contentLeft,
                  bottom: _scaled(height, 151, _designHeight),
                  child: SizedBox(
                    height: _loginButtonHeight * 2 + _loginButtonGap,
                    child: Column(
                      children: [
                        SizedBox(
                          height: _loginButtonHeight,
                          child: Stack(
                            clipBehavior: Clip.none,
                            children: [
                              Positioned(
                                right: -4,
                                bottom: 13,
                                child: const Character(
                                  type: CharacterType.excited,
                                  size: CharacterSize.small,
                                  width: 98,
                                  height: 98,
                                ),
                              ),
                              SocialLoginButton(
                                provider: SocialLoginProvider.kakao,
                                onTap: onKakaoLogin ?? () {},
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: _loginButtonGap),
                        SocialLoginButton(
                          provider: SocialLoginProvider.apple,
                          onTap: onAppleLogin ?? () {},
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  left: 24,
                  right: 24,
                  bottom: _scaled(height, 116, _designHeight),
                  child: _AgreementText(
                    onTermsTap: onTermsTap ?? () => _openTerms(context),
                    onPrivacyTap: onPrivacyTap ?? () => _openPrivacy(context),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  static double _scaled(double actual, double value, double design) {
    return actual * value / design;
  }

  static void _openTerms(BuildContext context) {
    Navigator.of(
      context,
    ).push(MaterialPageRoute<void>(builder: (_) => const TermsOfServicePage()));
  }

  static void _openPrivacy(BuildContext context) {
    Navigator.of(
      context,
    ).push(MaterialPageRoute<void>(builder: (_) => const PrivacyPolicyPage()));
  }
}

class _LoginBackground extends StatelessWidget {
  const _LoginBackground();

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Image.asset(
          'assets/images/auth/login_background.jpg',
          alignment: const Alignment(-0.12, 0),
          fit: BoxFit.cover,
        ),
        const DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0x57000000), Color(0xA8000000)],
            ),
          ),
        ),
      ],
    );
  }
}

class _LoginBranding extends StatelessWidget {
  const _LoginBranding();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text.rich(
          TextSpan(
            children: [
              const TextSpan(text: '우리의 무드로 완성되는 '),
              TextSpan(
                text: '촌캉스',
                style: AppTypography.captionOnboarding.copyWith(
                  color: AppColors.logo,
                ),
              ),
            ],
          ),
          textAlign: TextAlign.center,
          style: AppTypography.captionOnboarding.copyWith(
            color: AppColors.backgroundWhite,
          ),
        ),
        const SizedBox(height: 10),
        SvgPicture.asset(
          'assets/icons/logo/moodchon_wordmark_large.svg',
          width: 92,
          height: 66,
        ),
      ],
    );
  }
}

class _AgreementText extends StatefulWidget {
  const _AgreementText({this.onTermsTap, this.onPrivacyTap});

  final VoidCallback? onTermsTap;
  final VoidCallback? onPrivacyTap;

  @override
  State<_AgreementText> createState() => _AgreementTextState();
}

class _AgreementTextState extends State<_AgreementText> {
  late final TapGestureRecognizer _termsRecognizer;
  late final TapGestureRecognizer _privacyRecognizer;

  @override
  void initState() {
    super.initState();

    _termsRecognizer = TapGestureRecognizer()..onTap = widget.onTermsTap;
    _privacyRecognizer = TapGestureRecognizer()..onTap = widget.onPrivacyTap;
  }

  @override
  void didUpdateWidget(covariant _AgreementText oldWidget) {
    super.didUpdateWidget(oldWidget);

    _termsRecognizer.onTap = widget.onTermsTap;
    _privacyRecognizer.onTap = widget.onPrivacyTap;
  }

  @override
  void dispose() {
    _termsRecognizer.dispose();
    _privacyRecognizer.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final baseStyle = AppTypography.captionExtraSmall.copyWith(
      color: AppColors.backgroundWhite,
    );
    final linkStyle = baseStyle.copyWith(
      decoration: TextDecoration.underline,
      decorationColor: AppColors.backgroundWhite,
    );

    return Text.rich(
      TextSpan(
        children: [
          const TextSpan(text: '로그인을 계속하면 '),
          TextSpan(
            text: '이용약관',
            style: linkStyle,
            recognizer: _termsRecognizer,
          ),
          const TextSpan(text: ' 및 '),
          TextSpan(
            text: '개인정보 수집·이용',
            style: linkStyle,
            recognizer: _privacyRecognizer,
          ),
          const TextSpan(text: '에 동의하게 됩니다.'),
        ],
      ),
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
      textAlign: TextAlign.center,
      style: baseStyle,
    );
  }
}
