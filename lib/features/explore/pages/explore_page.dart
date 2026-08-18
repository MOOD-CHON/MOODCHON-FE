import 'package:flutter/material.dart';

import '../../../app/theme/app_colors.dart';
import '../../../core/widgets/bottom_tab/bottom_tab_type.dart';
import '../../../core/widgets/navigation/bottom_tab_bar.dart';
import '../../../core/widgets/navigation/top_bar.dart';
import '../../../core/widgets/select_image/select_image_grid.dart';
import '../../../core/widgets/select_image/select_image_mode.dart';
import '../../home/pages/home_page.dart'; // 임시 홈페이지
import '../data/explore_mock_data.dart';
import '../models/explore_item.dart';
import '../widgets/explore_filter_chips.dart';
import '../widgets/explore_search_empty.dart';

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
    // TODO: 알림 페이지 구현 후 연결
  }

  void _handleExploreItemTap(String id) {
    // TODO: 장소 상세 페이지 구현 후 연결
  }

  // 임시 홈페이지 하단바 연결
  void _handleBottomTabChanged(BottomTabType tab) {
    if (tab == BottomTabType.explore) {
      return;
    }

    if (tab == BottomTabType.home) {
      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          pageBuilder: (_, __, ___) => const HomePage(),
          transitionDuration: Duration.zero,
          reverseTransitionDuration: Duration.zero,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final filteredItems = _filteredItems;
    final gridItems = _toGridItems(filteredItems);

    final isKeyboardVisible = MediaQuery.viewInsetsOf(context).bottom > 0;

    return Scaffold(
      backgroundColor: AppColors.backgroundPrimary,
      body: SafeArea(
        bottom: false,
        child: GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: _handlePageTap,
          child: Stack(
            children: [
              Column(
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
              if (!isKeyboardVisible)
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 22,
                  child: NavigationBottomTabBar(
                    selectedTab: BottomTabType.explore,
                    onTabChanged: _handleBottomTabChanged,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
