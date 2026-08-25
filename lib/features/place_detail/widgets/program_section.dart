import 'package:flutter/material.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_typography.dart';

class ProgramSection extends StatelessWidget {
  const ProgramSection({super.key, required this.programs});

  final List<String> programs;

  bool _hasValue(String value) {
    return value.trim().isNotEmpty;
  }

  bool _hasNumberPrefix(String value) {
    return RegExp(r'^\s*\d+\.\s*').hasMatch(value);
  }

  String _formatProgram({required String program, required int index}) {
    final trimmed = program.trim();

    if (_hasNumberPrefix(trimmed)) {
      return trimmed;
    }

    return '${index + 1}. $trimmed';
  }

  @override
  Widget build(BuildContext context) {
    final visiblePrograms = programs.where(_hasValue).toList();

    if (visiblePrograms.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '프로그램',
          style: AppTypography.titleMedium.copyWith(
            color: AppColors.textPrimary,
          ),
        ),

        const SizedBox(height: 12),

        for (var index = 0; index < visiblePrograms.length; index++) ...[
          Text(
            _formatProgram(program: visiblePrograms[index], index: index),
            style: AppTypography.tabMedium.copyWith(
              color: AppColors.textSecondary,
            ),
          ),

          if (index < visiblePrograms.length - 1) const SizedBox(height: 8),
        ],
      ],
    );
  }
}
