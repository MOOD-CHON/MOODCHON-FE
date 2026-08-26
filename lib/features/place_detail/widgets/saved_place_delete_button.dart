import 'package:flutter/material.dart';

import '../../../core/widgets/button/trash_background_button.dart';
import '../../../core/widgets/modal/confirm/confirm_modal.dart';
import '../../../core/widgets/modal/confirm/confirm_modal_type.dart';

class SavedPlaceDeleteButton extends StatelessWidget {
  const SavedPlaceDeleteButton({super.key, required this.onDeleted});

  final VoidCallback onDeleted;

  Future<void> _handleDelete(BuildContext context) async {
    final confirmed = await ConfirmModal.show(
      context,
      type: ConfirmModalType.sbTwo,
      title: '이 폴더에서 삭제할까요?',
      description: '장소는 탐색에서 다시 확인하고 저장할 수 있어요.',
      confirmText: '삭제하기',
    );

    if (confirmed != true || !context.mounted) {
      return;
    }

    onDeleted();
  }

  @override
  Widget build(BuildContext context) {
    return TrashBackgroundButton(
      onTap: () {
        _handleDelete(context);
      },
    );
  }
}
