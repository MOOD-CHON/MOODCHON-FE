import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_shadows.dart';
import '../../../app/theme/app_typography.dart';
import '../../../core/widgets/banner/toast_overlay.dart';
import '../../../core/widgets/button/green/green_button.dart';
import '../../../core/widgets/button/green/green_button_size.dart';
import '../../../core/widgets/character/character.dart';
import '../../../core/widgets/character/character_size.dart';
import '../../../core/widgets/character/character_type.dart';
import '../../../core/widgets/navigation/navigation_share_button.dart';
import '../../../core/widgets/navigation/top_bar.dart';
import '../widgets/create_trip_intro_header.dart';

class CreateTripInvitePage extends StatelessWidget {
  const CreateTripInvitePage({super.key});

  static const String _inviteCode = 'C3H4O5N6';

  Future<void> _shareInviteCode(BuildContext context) async {
    final box = context.findRenderObject() as RenderBox?;
    final origin = box == null
        ? null
        : box.localToGlobal(Offset.zero) & box.size;

    try {
      await SharePlus.instance.share(
        ShareParams(
          text: '촌캉스에 초대할게요. 초대 코드: $_inviteCode',
          subject: '촌캉스 초대 코드',
          sharePositionOrigin: origin,
        ),
      );
    } on MissingPluginException {
      if (!context.mounted) {
        return;
      }

      await _copyInviteCode(context);
    }
  }

  Future<void> _copyInviteCode(BuildContext context) async {
    await Clipboard.setData(const ClipboardData(text: _inviteCode));

    if (!context.mounted) {
      return;
    }

    ToastOverlay.show(context, message: '초대 코드를 복사했어요.', bottom: 33);
  }

  void _goToTravelRoom() {
    // TODO: navigate to travel room after create-trip API is connected.
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundSecondary,
      body: SafeArea(
        bottom: false,
        child: Stack(
          fit: StackFit.expand,
          children: [
            Positioned(
              left: 0,
              top: 0,
              right: 0,
              child: TopBar(
                type: TopBarType.title,
                title: '촌캉스 만들기',
                onBack: () => Navigator.of(context).pop(),
              ),
            ),
            Positioned.fill(
              top: 72,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: double.infinity,
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          const CreateTripIntroHeader(
                            eyebrow: '구성원 초대',
                            title: '함께 떠날 구성원을 초대해볼까요?',
                            description: '초대 코드를 공유해 구성원을 초대해주세요.',
                          ),
                          Positioned(
                            right: -14,
                            top: -7,
                            child: IgnorePointer(
                              child: Character(
                                type: CharacterType.notebook,
                                size: CharacterSize.medium,
                                width: 89,
                                height: 89,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 28),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        const Expanded(child: _InviteCodeField()),
                        const SizedBox(width: 7),
                        Builder(
                          builder: (context) => NavigationShareButton(
                            onTap: () => _shareInviteCode(context),
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 33),
                      child: GreenButton(
                        size: GreenButtonSize.long,
                        label: '촌캉스 방으로 이동',
                        onTap: _goToTravelRoom,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InviteCodeField extends StatelessWidget {
  const _InviteCodeField();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 47,
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: AppColors.backgroundWhite,
        borderRadius: BorderRadius.circular(30),
        boxShadow: AppShadows.base,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '초대 코드',
            style: AppTypography.titleSmall.copyWith(
              color: AppColors.textPrimary,
              height: 1,
            ),
          ),
          const SizedBox(width: 13),
          Text(
            CreateTripInvitePage._inviteCode,
            style: AppTypography.titleSmall.copyWith(
              color: AppColors.textPrimary,
              height: 1,
            ),
          ),
        ],
      ),
    );
  }
}
