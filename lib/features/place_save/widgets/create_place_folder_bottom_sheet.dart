import 'package:flutter/material.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_typography.dart';
import '../../../core/widgets/button/half/half_button.dart';
import '../../../core/widgets/button/half/half_button_type.dart';
import '../../../core/widgets/inputs/text_field/moodchon_text_field.dart';
import '../../../core/widgets/inputs/text_field/text_field_size.dart';
import '../../../core/widgets/text/warning_text.dart';
import '../models/place_folder.dart';

class CreatePlaceFolderBottomSheet extends StatefulWidget {
  const CreatePlaceFolderBottomSheet({
    super.key,
    required this.currentFolderCount,
  });

  final int currentFolderCount;

  static const int maxFolderCount = 6;
  static const int maxFolderNameLength = 12;

  static Future<PlaceFolder?> show(
    BuildContext context, {
    required int currentFolderCount,
  }) {
    return showModalBottomSheet<PlaceFolder>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      useSafeArea: false,
      builder: (_) {
        return CreatePlaceFolderBottomSheet(
          currentFolderCount: currentFolderCount,
        );
      },
    );
  }

  @override
  State<CreatePlaceFolderBottomSheet> createState() =>
      _CreatePlaceFolderBottomSheetState();
}

class _CreatePlaceFolderBottomSheetState
    extends State<CreatePlaceFolderBottomSheet> {
  final TextEditingController _folderNameController = TextEditingController();

  String? _errorMessage;

  bool get _hasError => _errorMessage != null;

  @override
  void dispose() {
    _folderNameController.dispose();
    super.dispose();
  }

  void _handleFolderNameChanged(String value) {
    if (_errorMessage == null) {
      return;
    }

    setState(() {
      _errorMessage = null;
    });
  }

  void _handleCancel() {
    FocusScope.of(context).unfocus();
    Navigator.of(context).pop();
  }

  void _handleCreate() {
    FocusScope.of(context).unfocus();

    final folderName = _folderNameController.text.trim();

    if (folderName.isEmpty) {
      setState(() {
        _errorMessage = '폴더 이름을 입력해주세요.';
      });
      return;
    }

    if (widget.currentFolderCount >=
        CreatePlaceFolderBottomSheet.maxFolderCount) {
      setState(() {
        _errorMessage = '무드 폴더는 최대 6개까지 만들 수 있어요.';
      });
      return;
    }

    final newFolder = PlaceFolder(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      name: folderName,
      placeCount: 0,
    );

    Navigator.of(context).pop(newFolder);
  }

  @override
  Widget build(BuildContext context) {
    final keyboardBottom = MediaQuery.viewInsetsOf(context).bottom;

    return AnimatedPadding(
      duration: const Duration(milliseconds: 150),
      curve: Curves.easeOut,
      padding: EdgeInsets.only(bottom: keyboardBottom),
      child: Container(
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

              const SizedBox(height: 19),

              Text(
                '새 폴더 만들기',
                textAlign: TextAlign.center,
                style: AppTypography.titleMedium.copyWith(
                  color: AppColors.textPrimary,
                ),
              ),

              const SizedBox(height: 50),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          '폴더 이름',
                          style: AppTypography.titleMedium.copyWith(
                            color: AppColors.textPrimary,
                          ),
                        ),

                        const SizedBox(width: 6),

                        Text(
                          '*',
                          style: AppTypography.bodyMedium.copyWith(
                            color: AppColors.statusError,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 13),

                    MoodChonTextField(
                      size: MoodChonTextFieldSize.long,
                      placeholder: '폴더 이름을 12자 이내로 입력해주세요.',
                      controller: _folderNameController,
                      maxLength:
                          CreatePlaceFolderBottomSheet.maxFolderNameLength,
                      hasError: _hasError,
                      onChanged: _handleFolderNameChanged,
                      onSubmitted: (_) {
                        _handleCreate();
                      },
                    ),

                    if (_errorMessage != null) ...[
                      const SizedBox(height: 13),

                      WarningText(text: _errorMessage!),
                    ],
                  ],
                ),
              ),

              const SizedBox(height: 50),

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
                        label: '만들기',
                        onTap: _handleCreate,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
