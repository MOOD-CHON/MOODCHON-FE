import 'package:flutter/material.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_typography.dart';
import '../../../core/widgets/button/floating/explore_floating_button.dart';
import '../../../core/widgets/empty_state/character/empty_state_character_medium.dart';
import '../../../core/widgets/navigation/top_bar.dart';
import '../widgets/home_quick_action_card.dart';

class HomePage extends StatelessWidget {
  const HomePage({
    super.key,
    this.onCreateTrip,
    this.onJoinTrip,
    this.onExploreMoods,
    this.onNotification,
  });

  final VoidCallback? onCreateTrip;
  final VoidCallback? onJoinTrip;
  final VoidCallback? onExploreMoods;
  final VoidCallback? onNotification;

  static const double _designSafeHeight = 792;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundPrimary,
      body: SafeArea(
        bottom: false,
        child: LayoutBuilder(
          builder: (context, constraints) {
            final contentWidth = constraints.maxWidth
                .clamp(0.0, 361.0)
                .toDouble();
            final horizontalInset = (constraints.maxWidth - contentWidth) / 2;
            final height = constraints.maxHeight;

            return Stack(
              children: [
                TopBar(
                  type: TopBarType.logo,
                  onNotification: onNotification ?? () {},
                ),
                Positioned(
                  left: horizontalInset,
                  right: horizontalInset,
                  top: _scaledTop(height, 73),
                  child: Row(
                    children: [
                      Expanded(
                        child: HomeQuickActionCard(
                          type: HomeQuickActionType.create,
                          onTap: onCreateTrip ?? () {},
                        ),
                      ),
                      const SizedBox(width: 11),
                      Expanded(
                        child: HomeQuickActionCard(
                          type: HomeQuickActionType.join,
                          onTap: onJoinTrip ?? () {},
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  left: horizontalInset,
                  top: _scaledTop(height, 218),
                  child: Text(
                    '나의 촌캉스 기록',
                    style: AppTypography.titleMedium.copyWith(
                      color: AppColors.black,
                    ),
                  ),
                ),
                Positioned(
                  left: 0,
                  right: 0,
                  top: _scaledTop(height, 315),
                  child: const EmptyStateCharacterMedium(
                    title: '아직 진행 중인 촌캉스가 없어요.',
                    description: '새로 만들거나 초대받은 여행에 참여해보세요.',
                  ),
                ),
                Positioned(
                  left: horizontalInset,
                  right: horizontalInset,
                  bottom: _scaledBottom(height, 108),
                  child: ExploreFloatingButton(onTap: onExploreMoods ?? () {}),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  static double _scaledTop(double height, double designTop) {
    return height * designTop / _designSafeHeight;
  }

  static double _scaledBottom(double height, double designBottom) {
    return height * designBottom / _designSafeHeight;
  }
}
