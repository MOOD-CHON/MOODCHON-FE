import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_shadows.dart';
import '../../../app/theme/app_typography.dart';
import '../../../core/widgets/inputs/text_field/moodchon_text_field.dart';
import '../../../core/widgets/inputs/text_field/text_field_size.dart';
import '../../../core/widgets/text/warning_text.dart';
import '../models/create_trip_form_section.dart';

class CreateTripFormField extends StatelessWidget {
  const CreateTripFormField({
    super.key,
    required this.section,
    required this.expanded,
    required this.onTap,
    this.child,
    this.hasError = false,
    this.warningText,
  });

  final CreateTripFormSection section;
  final bool expanded;
  final VoidCallback onTap;
  final Widget? child;
  final bool hasError;
  final String? warningText;

  @override
  Widget build(BuildContext context) {
    final titleColor = expanded ? AppColors.textPrimary : AppColors.grayPrimary;

    return Semantics(
      button: true,
      expanded: expanded,
      label: section.label,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
          decoration: BoxDecoration(
            color: AppColors.backgroundWhite,
            borderRadius: BorderRadius.circular(16),
            border: hasError
                ? Border.all(color: AppColors.statusError, width: 1.2)
                : null,
            boxShadow: AppShadows.base,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _CreateTripFormHeader(
                label: section.label,
                required: section.required,
                expanded: expanded,
                color: titleColor,
              ),
              if (expanded && child != null) ...[
                const SizedBox(height: 13),
                child!,
              ],
              if (expanded && warningText != null) ...[
                const SizedBox(height: 13),
                WarningText(text: warningText!),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class CreateTripNameField extends StatelessWidget {
  const CreateTripNameField({
    super.key,
    required this.controller,
    this.hasError = false,
    this.onChanged,
  });

  final TextEditingController controller;
  final bool hasError;
  final ValueChanged<String>? onChanged;

  @override
  Widget build(BuildContext context) {
    return MoodChonTextField(
      size: MoodChonTextFieldSize.long,
      placeholder: '여행 이름을 20자 이내로 입력해주세요.',
      controller: controller,
      maxLength: 20,
      hasError: hasError,
      onChanged: onChanged,
    );
  }
}

class _CreateTripFormHeader extends StatelessWidget {
  const _CreateTripFormHeader({
    required this.label,
    required this.required,
    required this.expanded,
    required this.color,
  });

  final String label;
  final bool required;
  final bool expanded;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Flexible(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTypography.titleSmall.copyWith(
                    color: color,
                    height: 1,
                  ),
                ),
              ),
              if (required) ...[
                const SizedBox(width: 6),
                Text(
                  '*',
                  style: AppTypography.bodyMedium.copyWith(
                    color: AppColors.statusError,
                    height: 1,
                  ),
                ),
              ],
            ],
          ),
        ),
        Transform.rotate(
          angle: expanded ? 3.141592653589793 : 0,
          child: SvgPicture.asset(
            'assets/icons/filter/dropdown_down_black.svg',
            width: 12,
            height: 12,
            colorFilter: ColorFilter.mode(
              expanded ? AppColors.textPrimary : AppColors.grayPrimary,
              BlendMode.srcIn,
            ),
          ),
        ),
      ],
    );
  }
}
