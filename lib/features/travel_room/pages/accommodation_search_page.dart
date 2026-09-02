import 'package:flutter/material.dart';

import '../../../app/theme/app_colors.dart';
import '../../../core/widgets/empty_state/character/empty_state_character_medium.dart';
import '../../../core/widgets/navigation/top_bar.dart';
import '../data/accommodation_search_mock_data.dart';
import '../models/accommodation_search_result.dart';
import '../widgets/accommodation/accommodation_search_item.dart';

class AccommodationSearchPage extends StatefulWidget {
  const AccommodationSearchPage({super.key});

  @override
  State<AccommodationSearchPage> createState() =>
      _AccommodationSearchPageState();
}

class _AccommodationSearchPageState extends State<AccommodationSearchPage> {
  String _submittedQuery = '';

  List<AccommodationSearchResult> get _searchResults {
    final String query = _submittedQuery.trim().toLowerCase();

    if (query.isEmpty) {
      return const [];
    }

    return accommodationSearchMockData.where((item) {
      final String name = item.name.toLowerCase();

      return name.contains(query);
    }).toList();
  }

  void _onSearchChanged(String value) {
    // 검색창의 X 버튼 등으로 입력값을 전부 지운 경우
    // 기존 검색 결과도 함께 초기화한다.
    if (value.trim().isEmpty && _submittedQuery.isNotEmpty) {
      setState(() {
        _submittedQuery = '';
      });
    }
  }

  void _onSearchSubmitted(String value) {
    final String query = value.trim();

    setState(() {
      _submittedQuery = query;
    });
  }

  void _onResultTap(AccommodationSearchResult result) {
    // TODO: 직접 찾은 숙소 상세 페이지 구현 후 연결
  }

  @override
  Widget build(BuildContext context) {
    final List<AccommodationSearchResult> results = _searchResults;

    final bool hasSearched = _submittedQuery.trim().isNotEmpty;

    return Scaffold(
      backgroundColor: AppColors.backgroundSecondary,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            TopBar(
              type: TopBarType.backSearch,
              searchPlaceholder: '숙소명을 검색해보세요',
              onBack: () {
                Navigator.of(context).pop();
              },
              onSearchChanged: _onSearchChanged,
              onSearchSubmitted: _onSearchSubmitted,
            ),

            Expanded(
              child: Stack(
                children: [
                  if (hasSearched && results.isNotEmpty)
                    _buildSearchResults(results),

                  if (hasSearched && results.isEmpty) _buildEmptyState(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchResults(List<AccommodationSearchResult> results) {
    return Positioned.fill(
      child: ListView.separated(
        padding: const EdgeInsets.only(
          left: 16,
          right: 16,
          top: 20,
          bottom: 32,
        ),
        itemCount: results.length,
        separatorBuilder: (_, __) {
          return const SizedBox(height: 12);
        },
        itemBuilder: (context, index) {
          final AccommodationSearchResult result = results[index];

          return AccommodationSearchItem(
            data: result,
            onTap: () {
              _onResultTap(result);
            },
          );
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    /*
     * TopBar 높이 = 56
     *
     * Empty State를 화면 기준 y=331 부근에 배치하기 위해
     * TopBar 아래 Expanded 영역에서는
     *
     * 331 - 56 = 275
     *
     * 위치에서 시작하도록 잡는다.
     */
    return const Positioned(
      top: 275,
      left: 0,
      right: 0,
      child: Center(
        child: EmptyStateCharacterMedium(
          title: '검색한 숙소를 찾지 못했어요.',
          description: '숙소명을 다시 확인해주세요.',
        ),
      ),
    );
  }
}
