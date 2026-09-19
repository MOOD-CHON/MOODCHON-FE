import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:share_plus/share_plus.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_interactions.dart';
import '../../../app/theme/app_typography.dart';
import '../../../core/network/api_exception.dart';
import '../../../core/widgets/banner/toast_overlay.dart';
import '../../../core/widgets/button/copy_button.dart';
import '../../../core/widgets/navigation/top_bar.dart';
import '../data/travel_room_settings_api.dart';

class TravelRoomInvitePage extends StatefulWidget {
  const TravelRoomInvitePage({super.key, required this.chonkangId, required this.roomName});

  final int chonkangId;
  final String roomName;

  @override
  State<TravelRoomInvitePage> createState() => _TravelRoomInvitePageState();
}

class _TravelRoomInvitePageState extends State<TravelRoomInvitePage> {
  bool _isLoading = true;
  String? _errorMessage;
  String? _inviteCode;

  @override
  void initState() {
    super.initState();

    _fetchInviteCode();
  }

  Future<void> _fetchInviteCode() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final code = await TravelRoomSettingsApi.getInviteCode(
        widget.chonkangId,
      );

      if (!mounted) {
        return;
      }

      setState(() {
        _inviteCode = code;
      });
    } on ApiException catch (error) {
      setState(() {
        _errorMessage = error.message;
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _handleCopy() async {
    final code = _inviteCode;
    if (code == null) return;

    await Clipboard.setData(ClipboardData(text: code));

    if (!mounted) return;

    ToastOverlay.show(context, message: '초대 코드를 복사했어요.', bottom: 32);
  }

  Future<void> _handleShare() async {
    final code = _inviteCode;
    if (code == null) return;

    await SharePlus.instance.share(
      ShareParams(
        text: '${widget.roomName} 촌캉스에 초대할게요! 무드촌 앱에서 초대 코드 "$code"를 입력해주세요.',
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundPrimary,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            TopBar(
              type: TopBarType.title,
              title: '${widget.roomName} 초대',
              onBack: () {
                Navigator.of(context).pop();
              },
            ),
            Expanded(child: _buildBody()),
          ],
        ),
      ),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(color: AppColors.main),
      );
    }

    if (_errorMessage != null || _inviteCode == null) {
      return Center(
        child: Text(
          _errorMessage ?? '초대 코드를 불러오지 못했어요.',
          style: AppTypography.bodyExtraLarge.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '함께 떠날 구성원을 초대해볼까요?',
            style: AppTypography.titleMood.copyWith(color: AppColors.black),
          ),
          const SizedBox(height: 8),
          Text(
            '초대 코드를 공유해 구성원을 초대해주세요.',
            style: AppTypography.titleSmall.copyWith(
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            '새로운 구성원은 무드 검사 없이 기존 계획을 그대로 확인하고\n함께 수정할 수 있어요.',
            style: AppTypography.descriptionMedium.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 24),
          Container(
            width: double.infinity,
            height: 47,
            padding: const EdgeInsets.symmetric(horizontal: 15),
            decoration: BoxDecoration(
              color: AppColors.backgroundWhite,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: AppColors.linePrimary, width: 1.2),
            ),
            child: Row(
              children: [
                Text(
                  '초대 코드',
                  style: AppTypography.bodyExtraLarge.copyWith(
                    color: AppColors.grayPrimary,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    _inviteCode!,
                    style: AppTypography.bodyExtraLarge.copyWith(
                      color: AppColors.black,
                    ),
                  ),
                ),
                CopyButton(onTap: _handleCopy),
                const SizedBox(width: 12),
                _ShareIconButton(onTap: _handleShare),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ShareIconButton extends StatefulWidget {
  const _ShareIconButton({required this.onTap});

  final VoidCallback onTap;

  @override
  State<_ShareIconButton> createState() => _ShareIconButtonState();
}

class _ShareIconButtonState extends State<_ShareIconButton> {
  bool _isPressed = false;

  void _setPressed(bool value) {
    if (_isPressed == value) return;

    setState(() {
      _isPressed = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTapDown: (_) => _setPressed(true),
      onTapUp: (_) => _setPressed(false),
      onTapCancel: () => _setPressed(false),
      onTap: widget.onTap,
      child: AnimatedScale(
        scale: _isPressed ? AppInteractions.pressedScale : 1.0,
        duration: AppInteractions.pressedDuration,
        child: SvgPicture.asset(
          'assets/icons/navigation/share.svg',
          width: 20,
          height: 20,
        ),
      ),
    );
  }
}
