import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_typography.dart';
import '../../../core/widgets/banner/app_banner.dart';
import '../../../core/widgets/banner/banner_type.dart';
import '../../../core/widgets/button/alert_toggle/alert_toggle_button.dart';
import '../../../core/widgets/button/profile/profile_button.dart';
import '../../../core/widgets/modal/confirm/confirm_modal.dart';
import '../../../core/widgets/modal/confirm/confirm_modal_type.dart';
import '../../../core/widgets/navigation/top_bar.dart';
import '../widgets/profile_menu_card.dart';
import '../widgets/profile_menu_row.dart';
import 'nickname_edit_page.dart';
import 'pro_plan_page.dart';
import '../../notification/utils/open_notification_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final ImagePicker _imagePicker = ImagePicker();

  XFile? _profileImage;

  // TODO: 사용자 정보 API 연결 후 실제 닉네임으로 교체
  String _nickname = '홍길동';

  // TODO: 홈 화면에서 설정한 알림 동의 상태와 공통 상태로 연결
  bool _isAlertEnabled = false;

  void _onNotificationTap() {
    openNotificationPage(context);
  }

  Future<void> _pickProfileImage() async {
    final image = await _imagePicker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 90,
    );

    if (image == null || !mounted) {
      return;
    }

    setState(() {
      _profileImage = image;
    });

    // TODO: 프로필 이미지 수정 API 연결
  }

  void _onProTap() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) {
          return const ProPlanPage();
        },
      ),
    );
  }

  Future<void> _onNicknameTap() async {
    final nickname = await Navigator.of(context).push<String>(
      MaterialPageRoute(
        builder: (_) {
          return NicknameEditPage(initialNickname: _nickname);
        },
      ),
    );

    if (nickname == null || !mounted) {
      return;
    }

    setState(() {
      _nickname = nickname;
    });

    // TODO: 닉네임 수정 API 연결
  }

  void _onTermsTap() {
    // TODO: 서비스 이용약관 페이지 연결
  }

  void _onPrivacyTap() {
    // TODO: 개인정보 처리방침 외부 URL 연결
  }

  void _onLogoutTap() {
    // TODO: 로그아웃 처리 후 로그인 전 진입 화면 연결
  }

  Future<void> _onWithdrawTap() async {
    final confirmed = await ConfirmModal.show(
      context,
      type: ConfirmModalType.sbTwo,
      title: '정말 탈퇴하시겠어요?',
      description: '탈퇴하면 활동 내역을 다시 복구할 수 없어요.',
      confirmText: '탈퇴하기',
      top: 347,
    );

    if (confirmed != true || !mounted) {
      return;
    }

    // TODO: 회원 탈퇴 처리 후 로그인 전 진입 화면 연결
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundPrimary,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            TopBar(type: TopBarType.logo, onNotification: _onNotificationTap),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 24, 16, 110),
                child: Column(
                  children: [
                    Center(child: _buildProfileImage()),

                    const SizedBox(height: 14),

                    Center(
                      child: ProfileButton(
                        text: '프로필 사진 수정하기',
                        onTap: _pickProfileImage,
                      ),
                    ),

                    const SizedBox(height: 20),

                    AppBanner(
                      type: BannerType.button,
                      message: '무드촌을 더 편리하게 이용해보세요.',
                      buttonText: 'Pro 요금제 알아보기',
                      onButtonTap: _onProTap,
                    ),

                    const SizedBox(height: 20),

                    ProfileMenuCard(
                      height: 49,
                      child: ProfileMenuRow(
                        label: '닉네임 수정하기',
                        showArrow: true,
                        onTap: _onNicknameTap,
                      ),
                    ),

                    const SizedBox(height: 14),

                    _buildAlertCard(),

                    const SizedBox(height: 14),

                    ProfileMenuCard(
                      height: 84,
                      child: Column(
                        children: [
                          ProfileMenuRow(
                            label: '서비스 이용약관',
                            showArrow: true,
                            onTap: _onTermsTap,
                          ),
                          const SizedBox(height: 16),
                          ProfileMenuRow(
                            label: '개인정보 처리방침',
                            showArrow: true,
                            onTap: _onPrivacyTap,
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 14),

                    ProfileMenuCard(
                      height: 84,
                      child: Column(
                        children: [
                          ProfileMenuRow(
                            label: '로그아웃',
                            showArrow: true,
                            onTap: _onLogoutTap,
                          ),
                          const SizedBox(height: 16),
                          ProfileMenuRow(
                            label: '회원탈퇴',
                            showArrow: true,
                            onTap: _onWithdrawTap,
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 14),

                    _buildTeamCard(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileImage() {
    return ClipOval(
      child: SizedBox(
        width: 95,
        height: 95,
        child: _profileImage == null
            ? Image.asset(
                'assets/images/empty_state/empty_profile.png',
                fit: BoxFit.cover,
              )
            : Image.file(File(_profileImage!.path), fit: BoxFit.cover),
      ),
    );
  }

  Widget _buildAlertCard() {
    return ProfileMenuCard(
      height: 77,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ProfileMenuRow(
            label: '알림 받기',
            trailing: AlertToggleButton(
              value: _isAlertEnabled,
              onChanged: (value) {
                setState(() {
                  _isAlertEnabled = value;
                });

                // TODO: 홈 화면 알림 설정 상태와 공통 상태 연결
              },
            ),
          ),

          const SizedBox(height: 16),

          Text(
            '무드 선택 요청이 오면 알림을 보내드려요.',
            style: AppTypography.tabSmall.copyWith(
              color: AppColors.grayPrimary,
              height: 1.2,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTeamCard() {
    return ProfileMenuCard(
      height: 49,
      child: Row(
        children: [
          Expanded(
            child: Text(
              '개발팀',
              style: AppTypography.captionMedium.copyWith(
                color: AppColors.textPrimary,
              ),
            ),
          ),
          Text(
            'MOODI',
            style: AppTypography.captionMedium.copyWith(
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
