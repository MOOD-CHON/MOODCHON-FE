import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../../app/app.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_typography.dart';
import '../../../core/network/api_exception.dart';
import '../../../core/widgets/banner/app_banner.dart';
import '../../../core/widgets/banner/banner_type.dart';
import '../../../core/widgets/banner/toast_overlay.dart';
import '../../../core/widgets/button/alert_toggle/alert_toggle_button.dart';
import '../../../core/widgets/button/profile/profile_button.dart';
import '../../../core/widgets/modal/confirm/confirm_modal.dart';
import '../../../core/widgets/modal/confirm/confirm_modal_type.dart';
import '../../../core/widgets/navigation/top_bar.dart';
import '../../auth/data/auth_api.dart';
import '../../auth/pages/legal_document_page.dart';
import '../../auth/utils/legal_link_launcher.dart';
import '../../notification/utils/open_notification_page.dart';
import '../data/profile_api.dart';
import '../widgets/profile_menu_card.dart';
import '../widgets/profile_menu_row.dart';
import 'nickname_edit_page.dart';
import 'pro_plan_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final ImagePicker _imagePicker = ImagePicker();

  XFile? _pickedProfileImage;

  bool _isLoading = true;
  String _nickname = '';
  String? _profileImageUrl;
  bool _isAlertEnabled = false;

  @override
  void initState() {
    super.initState();

    _fetchProfile();
  }

  Future<void> _fetchProfile() async {
    try {
      final profile = await ProfileApi.getMyProfile();

      if (!mounted) {
        return;
      }

      setState(() {
        _nickname = profile.nickname;
        _profileImageUrl = profile.profileImageUrl;
        _isAlertEnabled = profile.notificationEnabled;
      });
    } on ApiException catch (error) {
      if (mounted) {
        ToastOverlay.show(context, message: error.message, bottom: 32);
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

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
      _pickedProfileImage = image;
    });

    // 현재 API 스펙(PATCH /api/users/me/profile-image)은 이미 업로드된
    // 이미지 URL 문자열만 받고, 이미지 파일을 업로드하는 엔드포인트가
    // 아직 없어서 로컬 미리보기까지만 반영됩니다.
    // 업로드 엔드포인트가 추가되면 여기서 업로드 후 반환된 URL로
    // ProfileApi.updateProfileImage를 호출해주세요.
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
  }

  void _onTermsTap() {
    Navigator.of(
      context,
    ).push(MaterialPageRoute<void>(builder: (_) => const TermsOfServicePage()));
  }

  Future<void> _onPrivacyTap() async {
    await LegalLinkLauncher.openPrivacyPolicy();
  }

  Future<void> _handleAlertChanged(bool value) async {
    final previous = _isAlertEnabled;

    setState(() {
      _isAlertEnabled = value;
    });

    try {
      await ProfileApi.updateNotificationPreference(value);
    } on ApiException catch (error) {
      if (!mounted) {
        return;
      }

      setState(() {
        _isAlertEnabled = previous;
      });

      ToastOverlay.show(context, message: error.message, bottom: 32);
    }
  }

  Future<void> _onLogoutTap() async {
    await AuthApi.instance.logout();

    if (!mounted) {
      return;
    }

    navigateToLogin();
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

    await AuthApi.instance.withdraw();

    if (!mounted) {
      return;
    }

    navigateToLogin();
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
              child: _isLoading
                  ? const Center(
                      child: CircularProgressIndicator(color: AppColors.main),
                    )
                  : _buildContent(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent() {
    return SingleChildScrollView(
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
    );
  }

  Widget _buildProfileImage() {
    return ClipOval(
      child: SizedBox(
        width: 95,
        height: 95,
        child: _buildProfileImageContent(),
      ),
    );
  }

  Widget _buildProfileImageContent() {
    if (_pickedProfileImage != null) {
      return Image.file(File(_pickedProfileImage!.path), fit: BoxFit.cover);
    }

    final imageUrl = _profileImageUrl;

    if (imageUrl != null && imageUrl.isNotEmpty) {
      return Image.network(
        imageUrl,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Image.asset(
            'assets/images/empty_state/empty_profile.png',
            fit: BoxFit.cover,
          );
        },
      );
    }

    return Image.asset(
      'assets/images/empty_state/empty_profile.png',
      fit: BoxFit.cover,
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
              onChanged: _handleAlertChanged,
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
