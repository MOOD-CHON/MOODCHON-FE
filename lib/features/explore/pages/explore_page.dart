import 'package:flutter/material.dart';

import '../../../app/theme/app_colors.dart';
import '../../../core/widgets/navigation/top_bar.dart';
import '../../../core/widgets/select_image/select_image_grid.dart';
import '../../../core/widgets/select_image/select_image_mode.dart';
import '../../place_detail/data/event_detail_mock_data.dart';
import '../../place_detail/data/tourism_detail_mock_data.dart';
import '../../place_detail/pages/accommodation_detail_page.dart';
import '../../place_detail/pages/event_detail_page.dart';
import '../../place_detail/pages/restaurant_detail_page.dart';
import '../../place_detail/pages/shopping_detail_page.dart';
import '../../place_detail/pages/tourism_detail_page.dart';
import '../data/explore_mock_data.dart';
import '../models/explore_item.dart';
import '../widgets/explore_filter_chips.dart';
import '../widgets/explore_search_empty.dart';
import '../../notification/utils/open_notification_page.dart';

class ExplorePage extends StatefulWidget {
  const ExplorePage({super.key});

  @override
  State<ExplorePage> createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage> {
  String _selectedMood = '전체';
  String _searchQuery = '';

  bool get _isSearching => _searchQuery.isNotEmpty;

  List<ExploreItem> get _filteredItems {
    if (_isSearching) {
      return exploreMockItems
          .where((item) => item.matchesQuery(_searchQuery))
          .toList();
    }

    if (_selectedMood == '전체') {
      return exploreMockItems;
    }

    return exploreMockItems
        .where((item) => item.mood == _selectedMood)
        .toList();
  }

  List<SelectImageGridItem> _toGridItems(List<ExploreItem> items) {
    return items
        .map(
          (item) => SelectImageGridItem(
            id: item.id,
            imageUrl: item.imageUrl,
            tag: item.tag,
          ),
        )
        .toList();
  }

  void _handleSearchChanged(String value) {
    if (value.isEmpty && _searchQuery.isNotEmpty) {
      setState(() {
        _searchQuery = '';
      });
    }
  }

  void _handleSearchSubmitted(String value) {
    final query = value.trim();

    FocusScope.of(context).unfocus();

    setState(() {
      _searchQuery = query;
    });
  }

  void _handlePageTap() {
    FocusScope.of(context).unfocus();
  }

  void _handleMoodSelected(String mood) {
    setState(() {
      _selectedMood = mood;
    });
  }

  void _handleNotificationTap() {
    openNotificationPage(context);
  }

  void _handleExploreItemTap(String id) {
    final item = _findExploreItem(id);

    if (item == null) {
      return;
    }

    Navigator.of(context)
        .push(MaterialPageRoute(builder: (_) => _buildDetailPage(item)));
  }

  ExploreItem? _findExploreItem(String id) {
    for (final item in exploreMockItems) {
      if (item.id == id) {
        return item;
      }
    }

    return null;
  }

  Widget _buildDetailPage(ExploreItem item) {
    switch (item.placeType) {
      case ExplorePlaceType.accommodation:
        return const AccommodationDetailPage();

      case ExplorePlaceType.attraction:
        return const TourismDetailPage(data: attractionDetailMockData);

      case ExplorePlaceType.culturalFacility:
        return const TourismDetailPage(data: culturalFacilityDetailMockData);

      case ExplorePlaceType.leisureSports:
        return const TourismDetailPage(data: leisureSportsDetailMockData);

      case ExplorePlaceType.event:
        return const EventDetailPage(data: eventDetailMockData);

      case ExplorePlaceType.performance:
        return const EventDetailPage(data: performanceDetailMockData);

      case ExplorePlaceType.festival:
        return const EventDetailPage(data: festivalDetailMockData);

      case ExplorePlaceType.restaurant:
        return const RestaurantDetailPage();

      case ExplorePlaceType.shopping:
        return const ShoppingDetailPage();
    }
  }

  @override
  Widget build(BuildContext context) {
    final filteredItems = _filteredItems;
    final gridItems = _toGridItems(filteredItems);

    return Scaffold(
      backgroundColor: AppColors.backgroundPrimary,
      body: SafeArea(
        bottom: false,
        child: GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: _handlePageTap,
          child: Column(
            children: [
              TopBar(
                type: TopBarType.search,
                searchPlaceholder: '지역, 장소, 무드를 검색해보세요.',
                onSearchChanged: _handleSearchChanged,
                onSearchSubmitted: _handleSearchSubmitted,
                onNotification: _handleNotificationTap,
              ),
              Expanded(
                child: _isSearching && filteredItems.isEmpty
                    ? const ExploreSearchEmpty()
                    : CustomScrollView(
                        keyboardDismissBehavior:
                            ScrollViewKeyboardDismissBehavior.onDrag,
                        slivers: [
                          if (!_isSearching) ...[
                            const SliverToBoxAdapter(
                              child: SizedBox(height: 14),
                            ),
                            SliverToBoxAdapter(
                              child: ExploreFilterChips(
                                selectedMood: _selectedMood,
                                onSelected: _handleMoodSelected,
                              ),
                            ),
                            const SliverToBoxAdapter(
                              child: SizedBox(height: 16),
                            ),
                          ] else
                            const SliverToBoxAdapter(
                              child: SizedBox(height: 16),
                            ),
                          SliverToBoxAdapter(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                              ),
                              child: SelectImageGrid(
                                items: gridItems,
                                mode: SelectImageMode.explore,
                                onExploreTap: _handleExploreItemTap,
                              ),
                            ),
                          ),
                          const SliverToBoxAdapter(
                            child: SizedBox(height: 110),
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
