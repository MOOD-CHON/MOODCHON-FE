import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_typography.dart';
import '../../button/confirm_modal/confirm_modal_button.dart';
import '../../button/confirm_modal/confirm_modal_button_type.dart';
import 'confirm_modal_type.dart';

class ConfirmModal extends StatelessWidget {
  const ConfirmModal({
    super.key,
    required this.type,
    required this.title,
    required this.description,
    required this.confirmText,
    required this.onConfirm,
    this.cancelText = '취소',
    this.onCancel,
  });

  final ConfirmModalType type;
  final String title;
  final String description;
  final String confirmText;
  final String cancelText;

  final VoidCallback onConfirm;
  final VoidCallback? onCancel;

  bool get _isSmall =>
      type == ConfirmModalType.sbTwo || type == ConfirmModalType.sbOne;

  bool get _hasTwoButtons =>
      type == ConfirmModalType.sbTwo || type == ConfirmModalType.mdTwo;

  double get _height => _isSmall ? 158 : 160;

  static Future<bool?> show(
    BuildContext context, {
    required ConfirmModalType type,
    required String title,
    required String description,
    required String confirmText,
    String cancelText = '취소',
  }) {
    return showGeneralDialog<bool>(
      context: context,
      barrierDismissible: false,
      barrierLabel: 'Confirm',
      barrierColor: AppColors.black.withValues(alpha: 0.50),
      transitionDuration: const Duration(milliseconds: 100),
      pageBuilder: (context, _, __) {
        return Center(
          child: Transform.translate(
            offset: const Offset(0, -40),
            child: ConfirmModal(
              type: type,
              title: title,
              description: description,
              confirmText: confirmText,
              cancelText: cancelText,
              onCancel: () {
                Navigator.of(context).pop(false);
              },
              onConfirm: () {
                Navigator.of(context).pop(true);
              },
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Container(
        width: 329,
        height: _height,
        decoration: BoxDecoration(
          color: AppColors.backgroundWhite,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                title,
                textAlign: TextAlign.center,
                style:
                    (_isSmall
                            ? AppTypography.titleSmall
                            : AppTypography.titleMedium)
                        .copyWith(color: AppColors.textPrimary),
              ),
              const SizedBox(height: 6),
              Text(
                description,
                textAlign: TextAlign.center,
                style:
                    (_isSmall
                            ? AppTypography.titleSmall
                            : AppTypography.captionMedium)
                        .copyWith(
                          color: _isSmall
                              ? AppColors.textPrimary
                              : AppColors.textSecondary,
                        ),
              ),
              const SizedBox(height: 21),
              if (_hasTwoButtons)
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ConfirmModalButton(
                      type: ConfirmModalButtonType.gray,
                      label: cancelText,
                      onTap: onCancel ?? () {},
                    ),
                    const SizedBox(width: 13),
                    ConfirmModalButton(
                      type: ConfirmModalButtonType.green,
                      label: confirmText,
                      onTap: onConfirm,
                    ),
                  ],
                )
              else
                ConfirmModalButton(
                  type: ConfirmModalButtonType.long,
                  label: confirmText,
                  onTap: onConfirm,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
