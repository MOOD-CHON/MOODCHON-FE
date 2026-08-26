import 'package:flutter/material.dart';

import '../../../core/widgets/banner/toast_overlay.dart';
import '../../../core/widgets/button/green/green_button.dart';
import '../../../core/widgets/button/green/green_button_size.dart';
import 'place_save_bottom_sheet.dart';

class PlaceSaveButton extends StatefulWidget {
  const PlaceSaveButton({super.key, required this.toastBottom});

  final double toastBottom;

  @override
  State<PlaceSaveButton> createState() => _PlaceSaveButtonState();
}

class _PlaceSaveButtonState extends State<PlaceSaveButton> {
  Set<String> _savedFolderIds = {};

  Future<void> _handleSave() async {
    final selectedFolderIds = await PlaceSaveBottomSheet.show(
      context,
      initiallySelectedFolderIds: _savedFolderIds,
    );

    if (!mounted || selectedFolderIds == null) {
      return;
    }

    setState(() {
      _savedFolderIds = Set<String>.from(selectedFolderIds);
    });

    ToastOverlay.show(
      context,
      message: '장소를 폴더에 저장했어요',
      bottom: widget.toastBottom,
    );
  }

  @override
  Widget build(BuildContext context) {
    return GreenButton(
      size: GreenButtonSize.long,
      label: '장소 저장하기',
      onTap: _handleSave,
    );
  }
}
