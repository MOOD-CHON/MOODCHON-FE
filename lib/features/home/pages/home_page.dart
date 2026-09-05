import 'package:flutter/material.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_typography.dart';
import '../../../core/widgets/button/floating/explore_floating_button.dart';
import '../../../core/widgets/empty_state/character/empty_state_character_medium.dart';
import '../../../core/widgets/navigation/top_bar.dart';
import '../data/home_mock_data.dart';
import '../models/home_trip.dart';
import '../widgets/home_continue_trip_button.dart';
import '../widgets/home_filter_dropdown.dart';
import '../widgets/home_plan_card.dart';
import '../widgets/home_quick_action_card.dart';

class HomePage extends StatefulWidget {
  const HomePage({
    super.key,
    this.trips,
    this.onCreateTrip,
    this.onJoinTrip,
    this.onExploreMoods,
    this.onNotification,
    this.onContinueTrip,
    this.onTripTap,
  });

  final List<HomeTrip>? trips;
  final VoidCallback? onCreateTrip;
  final VoidCallback? onJoinTrip;
  final VoidCallback? onExploreMoods;
  final VoidCallback? onNotification;
  final ValueChanged<HomeTrip>? onContinueTrip;
  final ValueChanged<HomeTrip>? onTripTap;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  HomeTripFilter _selectedFilter = HomeTripFilter.all;

  static const double _designSafeHeight = 792;

  List<HomeTrip> get _trips => widget.trips ?? HomeMockData.trips;

  List<HomeTrip> get _filteredTrips {
    switch (_selectedFilter) {
      case HomeTripFilter.all:
        return _trips;
      case HomeTripFilter.inProgress:
        return _trips.where((trip) => trip.isInProgress).toList();
      case HomeTripFilter.completed:
        return _trips.where((trip) => !trip.isInProgress).toList();
    }
  }

  HomeTrip? get _upcomingTrip {
    for (final trip in _trips) {
      if (trip.isInProgress) {
        return trip;
      }
    }

    return _trips.firstOrNull;
  }

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
            final hasTrips = _trips.isNotEmpty;

            return Stack(
              children: [
                TopBar(
                  type: TopBarType.logo,
                  onNotification: widget.onNotification ?? () {},
                ),
                Positioned(
                  left: horizontalInset,
                  right: horizontalInset,
                  top: _scaledTop(height, 73),
                  child: _QuickActionRow(
                    onCreateTrip: widget.onCreateTrip,
                    onJoinTrip: widget.onJoinTrip,
                  ),
                ),
                if (hasTrips) ...[
                  if (_upcomingTrip case final upcomingTrip?)
                    Positioned(
                      left: horizontalInset,
                      right: horizontalInset,
                      top: _scaledTop(height, 215),
                      child: HomeContinueTripButton(
                        trip: upcomingTrip,
                        onTap: () => widget.onContinueTrip?.call(upcomingTrip),
                      ),
                    ),
                  Positioned(
                    left: horizontalInset,
                    right: horizontalInset,
                    top: _scaledTop(height, 306),
                    bottom: 102,
                    child: _TripRecordSection(
                      selectedFilter: _selectedFilter,
                      trips: _filteredTrips,
                      onFilterChanged: (filter) {
                        setState(() {
                          _selectedFilter = filter;
                        });
                      },
                      onTripTap: widget.onTripTap,
                    ),
                  ),
                ] else ...[
                  Positioned(
                    left: horizontalInset,
                    top: _scaledTop(height, 218),
                    child: const _TripRecordTitle(),
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
                    child: ExploreFloatingButton(
                      onTap: widget.onExploreMoods ?? () {},
                    ),
                  ),
                ],
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

class _QuickActionRow extends StatelessWidget {
  const _QuickActionRow({this.onCreateTrip, this.onJoinTrip});

  final VoidCallback? onCreateTrip;
  final VoidCallback? onJoinTrip;

  @override
  Widget build(BuildContext context) {
    return Row(
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
    );
  }
}

class _TripRecordSection extends StatelessWidget {
  const _TripRecordSection({
    required this.selectedFilter,
    required this.trips,
    required this.onFilterChanged,
    this.onTripTap,
  });

  final HomeTripFilter selectedFilter;
  final List<HomeTrip> trips;
  final ValueChanged<HomeTripFilter> onFilterChanged;
  final ValueChanged<HomeTrip>? onTripTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Expanded(child: _TripRecordTitle()),
            HomeFilterDropdown(
              selectedFilter: selectedFilter,
              onChanged: onFilterChanged,
            ),
          ],
        ),
        const SizedBox(height: 18),
        Expanded(
          child: trips.isEmpty
              ? const Center(
                  child: EmptyStateCharacterMedium(
                    title: '조건에 맞는 촌캉스가 없어요.',
                    description: '다른 필터로 다시 확인해보세요.',
                  ),
                )
              : ListView.separated(
                  padding: EdgeInsets.zero,
                  itemCount: trips.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final trip = trips[index];

                    return HomePlanCard(
                      trip: trip,
                      onTap: () => onTripTap?.call(trip),
                    );
                  },
                ),
        ),
      ],
    );
  }
}

class _TripRecordTitle extends StatelessWidget {
  const _TripRecordTitle();

  @override
  Widget build(BuildContext context) {
    return Text(
      '나의 촌캉스 기록',
      style: AppTypography.titleMedium.copyWith(color: AppColors.black),
    );
  }
}
