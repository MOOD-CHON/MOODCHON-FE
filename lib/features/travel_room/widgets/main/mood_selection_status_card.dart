import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_shadows.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../core/widgets/border/wiggly_border.dart';
import '../../../../core/widgets/button/request/request_button.dart';
import '../../../../core/widgets/character/mood_select.dart';
import '../../../../core/widgets/divider/dashed_divider.dart';
import '../../../../core/widgets/progress/mood_selection_progress_bar.dart';
import '../../models/travel_room_member.dart';

class MoodSelectionStatusCard extends StatelessWidget {
  const MoodSelectionStatusCard({
    super.key,
    required this.members,
    required this.onRequestTap,
  });

  final List<TravelRoomMember> members;
  final VoidCallback onRequestTap;

  static const double _radius = 20;

  int get _completedCount {
    return members.where((member) => member.moodCompleted).length;
  }

  @override
  Widget build(BuildContext context) {
    final totalCount = members.length;

    final progress = totalCount == 0 ? 0.0 : _completedCount / totalCount;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.backgroundWhite,
        borderRadius: BorderRadius.circular(_radius),
        boxShadow: AppShadows.base,
      ),
      clipBehavior: Clip.antiAlias,
      child: CustomPaint(
        foregroundPainter: const WigglyBorderPainter(
          color: AppColors.linePrimary,
          radius: _radius,
          strokeWidth: 1,
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 20, 16, 20),
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Text(
                      '실시간 무드 선택 현황',
                      style: AppTypography.titleMedium.copyWith(
                        color: AppColors.black,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '$_completedCount/$totalCount 완료',
                    style: AppTypography.tabLarge.copyWith(
                      color: AppColors.grayPrimary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 18),
              MoodSelectionProgressBar(value: progress),
              const SizedBox(height: 24),
              _MemberGrid(members: members),
              const SizedBox(height: 26),
              RequestButton(label: '다시 요청 보내기', onTap: onRequestTap),
            ],
          ),
        ),
      ),
    );
  }
}

class _MemberGrid extends StatelessWidget {
  const _MemberGrid({required this.members});

  final List<TravelRoomMember> members;

  @override
  Widget build(BuildContext context) {
    final firstRowCount = members.length == 4 ? 2 : math.min(3, members.length);

    final firstRow = members.take(firstRowCount).toList();

    final secondRow = members.skip(firstRowCount).take(3).toList();

    return Column(
      children: [
        _MemberRow(members: firstRow),
        if (secondRow.isNotEmpty) ...[
          const SizedBox(height: 26),
          const DashedDivider(
            direction: DashedDividerDirection.horizontal,
            length: 304.03,
          ),
          const SizedBox(height: 26),
          _MemberRow(members: secondRow),
        ],
      ],
    );
  }
}

class _MemberRow extends StatelessWidget {
  const _MemberRow({required this.members});

  final List<TravelRoomMember> members;

  @override
  Widget build(BuildContext context) {
    if (members.isEmpty) {
      return const SizedBox.shrink();
    }

    final children = <Widget>[];

    for (var index = 0; index < members.length; index++) {
      final member = members[index];

      children.add(
        MoodSelect(completed: member.moodCompleted, name: member.name),
      );

      if (index != members.length - 1) {
        children.add(const SizedBox(width: 16));
        children.add(
          const DashedDivider(
            direction: DashedDividerDirection.vertical,
            length: 65,
          ),
        );
        children.add(const SizedBox(width: 16));
      }
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: children,
    );
  }
}
