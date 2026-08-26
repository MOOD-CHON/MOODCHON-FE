import 'package:flutter/material.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_typography.dart';
import '../../../core/widgets/button/half/half_button.dart';
import '../../../core/widgets/button/half/half_button_type.dart';
import '../data/place_folder_mock_data.dart';
import '../models/place_folder.dart';
import 'place_folder_select_item.dart';

class PlaceSaveBottomSheet extends StatefulWidget {
  const PlaceSaveBottomSheet({
    super.key,
    required this.folders,
    required this.initiallySelectedFolderIds,
  });

  final List<PlaceFolder> folders;
  final Set<String> initiallySelectedFolderIds;

  static Future<Set<String>?> show(
    BuildContext context, {
    Set<String> initiallySelectedFolderIds = const {},
  }) {
    return showModalBottomSheet<Set<String>>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      useSafeArea: false,
      builder: (_) {
        return PlaceSaveBottomSheet(
          folders: placeFolderMockData,
          initiallySelectedFolderIds: initiallySelectedFolderIds,
        );
      },
    );
  }

  @override
  State<PlaceSaveBottomSheet> createState() => _PlaceSaveBottomSheetState();
}

class _PlaceSaveBottomSheetState extends State<PlaceSaveBottomSheet> {
  late Set<String> _selectedFolderIds;

  bool get _hasSelection => _selectedFolderIds.isNotEmpty;

  @override
  void initState() {
    super.initState();

    _selectedFolderIds = Set<String>.from(widget.initiallySelectedFolderIds);
  }

  void _toggleFolder(String folderId) {
    setState(() {
      if (_selectedFolderIds.contains(folderId)) {
        _selectedFolderIds.remove(folderId);
      } else {
        _selectedFolderIds.add(folderId);
      }
    });
  }

  void _handleCancel() {
    Navigator.of(context).pop();
  }

  void _handleSave() {
    if (!_hasSelection) {
      return;
    }

    Navigator.of(context).pop(Set<String>.from(_selectedFolderIds));
  }

  void _handleCreateFolder() {
    // TODO: 새 폴더 만들기 바텀시트 구현 후 연결
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: AppColors.backgroundWhite,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
      ),
      child: SafeArea(
        top: false,
        minimum: const EdgeInsets.only(bottom: 33),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 7),

            Container(
              width: 57,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.linePrimary,
                borderRadius: BorderRadius.circular(30),
              ),
            ),

            const SizedBox(height: 29),

            Text(
              '저장할 폴더를 선택해주세요',
              textAlign: TextAlign.center,
              style: AppTypography.titleMedium.copyWith(
                color: AppColors.textPrimary,
              ),
            ),

            const SizedBox(height: 30),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 28),
              child: Column(
                children: [
                  for (
                    var index = 0;
                    index < widget.folders.length;
                    index++
                  ) ...[
                    PlaceFolderSelectItem(
                      folder: widget.folders[index],
                      selected: _selectedFolderIds.contains(
                        widget.folders[index].id,
                      ),
                      onTap: () {
                        _toggleFolder(widget.folders[index].id);
                      },
                    ),

                    if (index < widget.folders.length - 1)
                      const SizedBox(height: 20),
                  ],
                ],
              ),
            ),

            const SizedBox(height: 20),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 28),
              child: Align(
                alignment: Alignment.centerLeft,
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: _handleCreateFolder,
                  child: Text(
                    '+ 새 폴더 만들기',
                    style: AppTypography.bodyExtraLarge.copyWith(
                      color: AppColors.graySecondary,
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Expanded(
                    child: HalfButton(
                      type: HalfButtonType.stroke,
                      label: '취소',
                      onTap: _handleCancel,
                    ),
                  ),

                  const SizedBox(width: 13),

                  Expanded(
                    child: HalfButton(
                      type: HalfButtonType.full,
                      label: '저장하기',
                      disabled: !_hasSelection,
                      onTap: _handleSave,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
