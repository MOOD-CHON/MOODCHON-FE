import 'package:flutter/material.dart';

import '../../../app/theme/app_colors.dart';
import '../../../core/widgets/banner/app_banner.dart';
import '../../../core/widgets/banner/banner_type.dart';
import '../../../core/widgets/banner/toast_overlay.dart';
import '../../../core/widgets/empty_state/character/empty_state_character_medium.dart';
import '../../../core/widgets/navigation/top_bar.dart';
import '../../place_save/data/place_folder_mock_data.dart';
import '../../place_save/models/place_folder.dart';
import '../../place_save/widgets/create_place_folder_bottom_sheet.dart';
import '../models/saved_folder_detail_result.dart';
import '../widgets/mood_folder_grid.dart';
import 'saved_folder_detail_page.dart';

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

  Future<void> _onFolderTap(PlaceFolder folder) async {
    final result = await Navigator.of(context).push<SavedFolderDetailResult>(
      MaterialPageRoute(
        builder: (_) {
          return SavedFolderDetailPage(folder: folder);
        },
      ),
    );

    if (result == null || !mounted) {
      return;
    }

    final index = _folders.indexWhere((item) => item.id == folder.id);

    if (index == -1) {
      return;
    }

    if (result.folderDeleted) {
      setState(() {
        _folders.removeAt(index);
      });

      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) {
          return;
        }

        final safeBottom = MediaQuery.paddingOf(context).bottom;
        final bottomTabPadding = safeBottom < 22 ? 22.0 : safeBottom;

        ToastOverlay.show(
          context,
          message: '폴더를 삭제했어요',
          bottom: bottomTabPadding + 64 + 8,
        );
      });

      return;
    }

    setState(() {
      _folders[index] = _folders[index].copyWith(
        placeCount: result.placeCount,
        coverImageUrl: result.coverImageUrl,
        clearCoverImageUrl: result.coverImageUrl == null,
      );
    });
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
