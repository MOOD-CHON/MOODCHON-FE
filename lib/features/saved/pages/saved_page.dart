import 'package:flutter/material.dart';

import '../../../app/theme/app_colors.dart';
import '../../../core/widgets/banner/app_banner.dart';
import '../../../core/widgets/banner/banner_type.dart';
import '../../../core/widgets/empty_state/character/empty_state_character_medium.dart';
import '../../../core/widgets/navigation/top_bar.dart';
import '../../place_save/data/place_folder_mock_data.dart';
import '../../place_save/models/place_folder.dart';
import '../../place_save/widgets/create_place_folder_bottom_sheet.dart';
import '../widgets/mood_folder_grid.dart';

class SavedPage extends StatefulWidget {
  const SavedPage({super.key});

  @override
  State<SavedPage> createState() => _SavedPageState();
}

class _SavedPageState extends State<SavedPage> {
  late final List<PlaceFolder> _folders;

  @override
  void initState() {
    super.initState();

    _folders = List<PlaceFolder>.from(placeFolderMockData);
  }

  Future<void> _showCreateFolderBottomSheet() async {
    final newFolder = await CreatePlaceFolderBottomSheet.show(
      context,
      currentFolderCount: _folders.length,
    );

    if (newFolder == null || !mounted) {
      return;
    }

    setState(() {
      _folders.add(newFolder);
    });
  }

  void _onNotificationTap() {
    // TODO: 알림 페이지 연결
  }

  void _onFolderTap(PlaceFolder folder) {
    // TODO: 무드 폴더 상세 페이지 연결
  }

  Widget _buildBanner() {
    final canCreateFolder =
        _folders.length < CreatePlaceFolderBottomSheet.maxFolderCount;

    if (canCreateFolder) {
      return AppBanner(
        type: BannerType.button,
        message: '새로운 무드 폴더를 만들어볼까요?',
        buttonText: '새 폴더 만들기',
        onButtonTap: _showCreateFolderBottomSheet,
      );
    }

    return const AppBanner(
      type: BannerType.info,
      message: '무드 폴더는 최대 6개까지 만들 수 있어요.',
    );
  }

  Widget _buildEmptyContent() {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 26, 16, 110),
      child: Column(
        children: [
          const EmptyStateCharacterMedium(
            title: '아직 무드 폴더가 없어요.',
            description: '새 폴더를 만들거나 탐색 탭에서 장소를 저장해주세요.',
          ),
          const SizedBox(height: 55),
          _buildBanner(),
        ],
      ),
    );
  }

  Widget _buildFolderContent() {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 110),
      child: Column(
        children: [
          MoodFolderGrid(folders: _folders, onFolderTap: _onFolderTap),
          const SizedBox(height: 32),
          _buildBanner(),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final hasFolders = _folders.isNotEmpty;

    return Scaffold(
      backgroundColor: AppColors.backgroundPrimary,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            TopBar(type: TopBarType.logo, onNotification: _onNotificationTap),
            Expanded(
              child: hasFolders ? _buildFolderContent() : _buildEmptyContent(),
            ),
          ],
        ),
      ),
    );
  }
}
