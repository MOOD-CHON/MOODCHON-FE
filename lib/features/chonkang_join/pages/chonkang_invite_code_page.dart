import 'package:flutter/material.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_typography.dart';
import '../../../core/network/api_exception.dart';
import '../../../core/widgets/button/green/green_button.dart';
import '../../../core/widgets/button/green/green_button_size.dart';
import '../../../core/widgets/inputs/text_field/moodchon_text_field.dart';
import '../../../core/widgets/inputs/text_field/text_field_size.dart';
import '../../../core/widgets/modal/confirm/confirm_modal.dart';
import '../../../core/widgets/modal/confirm/confirm_modal_type.dart';
import '../../../core/widgets/navigation/top_bar.dart';
import '../../../core/widgets/text/warning_text.dart';
import '../../main/pages/main_page.dart';
import '../data/chonkang_join_api.dart';
import 'chonkang_trip_info_confirm_page.dart';

class ChonkangInviteCodePage extends StatefulWidget {
  const ChonkangInviteCodePage({super.key});

  @override
  State<ChonkangInviteCodePage> createState() =>
      _ChonkangInviteCodePageState();
}

class _ChonkangInviteCodePageState extends State<ChonkangInviteCodePage> {
  final TextEditingController _codeController = TextEditingController();

  String? _errorMessage;
  bool _isSubmitting = false;

  @override
  void dispose() {
    _codeController.dispose();

    super.dispose();
  }

  void _handleChanged(String _) {
    if (_errorMessage != null) {
      setState(() {
        _errorMessage = null;
      });
    }
  }

  Future<void> _handleSubmit() async {
    final inviteCode = _codeController.text.trim();

    if (inviteCode.isEmpty) {
      setState(() {
        _errorMessage = '초대 코드를 입력해주세요.';
      });

      return;
    }

    setState(() {
      _isSubmitting = true;
      _errorMessage = null;
    });

    try {
      final tripInfo = await ChonkangJoinApi.getTripInfo(inviteCode);

      if (!mounted) {
        return;
      }

      if (tripInfo.isFull) {
        await ConfirmModal.show(
          context,
          type: ConfirmModalType.mdOne,
          title: '해당 촌캉스는 참여 인원이 모두 찼어요.',
          description:
              '촌캉스는 최대 6명까지 함께할 수 있어요.\n다른 촌캉스에 참여하거나 새 촌캉스를 만들어주세요.',
          confirmText: '확인',
        );

        return;
      }

      if (!mounted) {
        return;
      }

      if (tripInfo.moodDecided) {
        await _joinAlreadyPlannedRoom(inviteCode);

        return;
      }

      await Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => ChonkangTripInfoConfirmPage(
            inviteCode: inviteCode,
            tripInfo: tripInfo,
          ),
        ),
      );
    } on ApiException catch (error) {
      setState(() {
        _errorMessage = error.message;
      });
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }

  Future<void> _joinAlreadyPlannedRoom(String inviteCode) async {
    final confirmed = await ConfirmModal.show(
      context,
      type: ConfirmModalType.mdTwo,
      title: '기존 여행 계획을 유지한 채 참여해요.',
      description:
          '기존 무드와 숙소, 일정은 유지돼요.\n내 무드를 반영하고 싶다면 입장 후 무드를 다시 선택할 수 있어요.',
      confirmText: '참여하기',
    );

    if (confirmed != true || !mounted) {
      return;
    }

    // 이미 무드가 정해진 방이라 새로 들어오는 사람은 무드 검사를 보지
    // 않지만, 참여 API가 무드 카드 3개 선택을 요구하고 있어서
    // 화면에 보여주지 않고 무작위로 3개를 채워 함께 보냅니다.
    // 이후 필요하면 방 안에서 '무드 다시 선택하기'로 바꿀 수 있어요.
    try {
      final moodCards = await ChonkangJoinApi.getRandomMoodCards();
      final fillerMoodCardIds = moodCards
          .take(3)
          .map((card) => card.id)
          .toSet();

      await ChonkangJoinApi.join(
        inviteCode,
        selectedMoodCardIds: fillerMoodCardIds,
      );

      if (!mounted) {
        return;
      }

      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const MainPage()),
        (route) => false,
      );
    } on ApiException catch (error) {
      if (mounted) {
        setState(() {
          _errorMessage = error.message;
        });
      }
    }
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
              title: '촌캉스 참여하기',
              onBack: () {
                Navigator.of(context).pop();
              },
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 20, 16, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RichText(
                      text: TextSpan(
                        style: AppTypography.titleSmall.copyWith(
                          color: AppColors.black,
                        ),
                        children: [
                          const TextSpan(text: '공유받은 초대 코드를 입력해주세요.'),
                          TextSpan(
                            text: ' *',
                            style: TextStyle(color: AppColors.statusError),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    MoodChonTextField(
                      size: MoodChonTextFieldSize.long,
                      placeholder: '코드를 입력해주세요.',
                      controller: _codeController,
                      onChanged: _handleChanged,
                      onSubmitted: (_) => _handleSubmit(),
                      hasError: _errorMessage != null,
                    ),
                    if (_errorMessage != null) ...[
                      const SizedBox(height: 8),
                      WarningText(text: _errorMessage!),
                    ],
                    const SizedBox(height: 24),
                    GreenButton(
                      size: GreenButtonSize.long,
                      label: '초대받은 촌캉스 확인하기',
                      onTap: _isSubmitting ? () {} : _handleSubmit,
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
