import 'package:flutter/material.dart';

import '../../../app/theme/app_colors.dart';
import '../../../core/network/api_exception.dart';
import '../../../core/widgets/banner/toast_overlay.dart';
import '../../../core/widgets/bottom_tab/bottom_tab_type.dart';
import '../../../core/widgets/navigation/bottom_tab_bar.dart';
import '../../chonkang_join/pages/chonkang_invite_code_page.dart';
import '../../create_trip/pages/create_trip_info_page.dart';
import '../../explore/pages/explore_page.dart';
import '../../home/data/home_api.dart';
import '../../home/models/home_trip.dart';
import '../../home/pages/home_page.dart';
import '../../notification/utils/open_notification_page.dart';
import '../../profile/pages/profile_page.dart';
import '../../saved/pages/saved_page.dart';
import '../../travel_room/data/travel_room_settings_api.dart';
import '../../travel_room/pages/travel_room_main_page.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key, this.initialTab = BottomTabType.home});

  final BottomTabType initialTab;

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  late BottomTabType _selectedTab;
  late Future<List<HomeTrip>> _tripsFuture;

  @override
  void initState() {
    super.initState();

    _selectedTab = widget.initialTab;
    _tripsFuture = HomeApi.instance.fetchTrips();
  }

  int get _selectedIndex {
    switch (_selectedTab) {
      case BottomTabType.home:
        return 0;

      case BottomTabType.explore:
        return 1;

      case BottomTabType.saved:
        return 2;

      case BottomTabType.my:
        return 3;
    }
  }

  void _handleTabChanged(BottomTabType tab) {
    if (_selectedTab == tab) {
      return;
    }

    setState(() {
      _selectedTab = tab;
    });
  }

  void _handleNotificationTap() {
    openNotificationPage(context);
  }

  void _handleExploreMoodsTap() {
    _handleTabChanged(BottomTabType.explore);
  }

  void _handleCreateTripTap() {
    Navigator.of(
      context,
    ).push(MaterialPageRoute<void>(builder: (_) => const CreateTripInfoPage()));
  }

  void _handleJoinTripTap() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const ChonkangInviteCodePage()),
    );
  }

  void _handleHomeNotificationPermissionRequest() {
    // TODO: 푸시 알림 패키지 연동 후 OS 권한 요청을 연결
  }

  void _handleContinueTrip(HomeTrip trip) {
    _openTravelRoom(trip.id);
  }

  void _handleTripTap(HomeTrip trip) {
    _openTravelRoom(trip.id);
  }

  Future<void> _openTravelRoom(int chonkangId) async {
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (_) =>
          const Center(child: CircularProgressIndicator(color: AppColors.main)),
    );

    try {
      final data = await TravelRoomSettingsApi.getMainData(chonkangId);

      if (!mounted) {
        return;
      }

      Navigator.of(context).pop();

      Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => TravelRoomMainPage(data: data)),
      );
    } on ApiException catch (error) {
      if (!mounted) {
        return;
      }

      Navigator.of(context).pop();
      ToastOverlay.show(context, message: error.message, bottom: 96);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isKeyboardVisible = MediaQuery.viewInsetsOf(context).bottom > 0;

    return Scaffold(
      backgroundColor: AppColors.backgroundPrimary,
      body: Stack(
        children: [
          IndexedStack(
            index: _selectedIndex,
            children: [
              FutureBuilder<List<HomeTrip>>(
                future: _tripsFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState != ConnectionState.done) {
                    return const ColoredBox(
                      color: AppColors.backgroundPrimary,
                      child: Center(child: CircularProgressIndicator()),
                    );
                  }

                  return HomePage(
                    trips: snapshot.hasError ? const [] : snapshot.data,
                    onCreateTrip: _handleCreateTripTap,
                    onJoinTrip: _handleJoinTripTap,
                    onExploreMoods: _handleExploreMoodsTap,
                    onNotification: _handleNotificationTap,
                    onRequestNotificationPermission:
                        _handleHomeNotificationPermissionRequest,
                    onContinueTrip: _handleContinueTrip,
                    onTripTap: _handleTripTap,
                  );
                },
              ),
              const ExplorePage(),
              const SavedPage(),
              const ProfilePage(),
            ],
          ),

          if (!isKeyboardVisible)
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: NavigationBottomTabBar(
                selectedTab: _selectedTab,
                onTabChanged: _handleTabChanged,
              ),
            ),
        ],
      ),
    );
  }
}
