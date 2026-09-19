import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_typography.dart';
import '../../../core/network/api_exception.dart';
import '../../../core/widgets/base/search_field/search_field_base.dart';
import '../../../core/widgets/empty_state/character/empty_state_character_medium.dart';
import '../../../core/widgets/inputs/search_text_field.dart';
import '../../../core/widgets/navigation/navigation_back_button.dart';
import '../../../core/widgets/search/clear_button.dart';
import '../../../core/widgets/tag/map_tag.dart';
import '../data/itinerary_api.dart';
import '../models/place_search_result.dart';
import 'itinerary_place_detail_page.dart';

/// 9.3.2 검색 결과 / 9.3.4 검색 결과 없는 경우.
class ItineraryPlaceSearchPage extends StatefulWidget {
  const ItineraryPlaceSearchPage({
    super.key,
    required this.chonkangId,
    required this.dayNumber,
  });

  final int chonkangId;
  final int dayNumber;

  @override
  State<ItineraryPlaceSearchPage> createState() =>
      _ItineraryPlaceSearchPageState();
}

class _ItineraryPlaceSearchPageState extends State<ItineraryPlaceSearchPage> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  bool _isLoading = false;
  bool _hasSearched = false;
  String? _errorMessage;
  List<PlaceSearchResult> _results = const [];

  @override
  void initState() {
    super.initState();

    _controller.addListener(() => setState(() {}));
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();

    super.dispose();
  }

  Future<void> _search(String keyword) async {
    final trimmed = keyword.trim();
    if (trimmed.isEmpty) {
      return;
    }

    _focusNode.unfocus();

    setState(() {
      _isLoading = true;
      _hasSearched = true;
      _errorMessage = null;
    });

    try {
      final results = await ItineraryApi.searchPlaces(
        widget.chonkangId,
        keyword: trimmed,
      );

      if (mounted) {
        setState(() {
          _results = results;
        });
      }
    } on ApiException catch (error) {
      if (mounted) {
        setState(() {
          _errorMessage = error.message;
          _results = const [];
        });
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _openDetail(PlaceSearchResult result) async {
    final added = await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (_) => ItineraryPlaceDetailPage(
          chonkangId: widget.chonkangId,
          placeId: result.placeId,
          addTargetDay: widget.dayNumber,
        ),
      ),
    );

    if (added == true && mounted) {
      Navigator.of(context).pop(true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundPrimary,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            _buildSearchBar(),
            Expanded(child: _buildBody()),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 6, 16, 5),
        child: Row(
          children: [
            NavigationBackButton(
              onTap: () => Navigator.of(context).pop(),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: SearchFieldBase(
                child: Row(
                  children: [
                    SvgPicture.asset(
                      'assets/icons/search/search.svg',
                      width: 45,
                      height: 45,
                      colorFilter: const ColorFilter.mode(
                        AppColors.black,
                        BlendMode.srcIn,
                      ),
                    ),
                    Expanded(
                      child: SearchTextField(
                        controller: _controller,
                        focusNode: _focusNode,
                        placeholder: '장소를 검색해보세요',
                        isFocused: _focusNode.hasFocus,
                        onChanged: (_) {},
                        onSubmitted: _search,
                      ),
                    ),
                    if (_controller.text.isNotEmpty) ...[
                      ClearButton(onTap: () => _controller.clear()),
                      const SizedBox(width: 14.5),
                    ] else
                      const SizedBox(width: 14.5),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(color: AppColors.main),
      );
    }

    if (_errorMessage != null) {
      return Center(
        child: Text(
          _errorMessage!,
          style: AppTypography.bodyExtraLarge.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
      );
    }

    if (!_hasSearched) {
      return const SizedBox.shrink();
    }

    if (_results.isEmpty) {
      return const Padding(
        padding: EdgeInsets.only(top: 90),
        child: EmptyStateCharacterMedium(
          title: '검색 결과가 없어요.',
          description: '다른 키워드로 검색해보세요.',
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
      itemCount: _results.length,
      separatorBuilder: (_, _) => const SizedBox(height: 12),
      itemBuilder: (_, index) => _ResultRow(
        result: _results[index],
        onTap: () => _openDetail(_results[index]),
      ),
    );
  }
}

class _ResultRow extends StatelessWidget {
  const _ResultRow({required this.result, required this.onTap});

  final PlaceSearchResult result;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: result.thumbnailUrl == null ||
                    result.thumbnailUrl!.trim().isEmpty
                ? Container(
                    width: 60,
                    height: 60,
                    color: AppColors.linePrimary,
                  )
                : Image.network(
                    result.thumbnailUrl!,
                    width: 60,
                    height: 60,
                    fit: BoxFit.cover,
                    errorBuilder: (_, _, _) => Container(
                      width: 60,
                      height: 60,
                      color: AppColors.linePrimary,
                    ),
                  ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        result.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTypography.titleSmall.copyWith(
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),
                    const SizedBox(width: 6),
                    MapTag(
                      label: result.categoryLabel,
                      color: result.tagColor,
                      size: MapTagSize.small,
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  result.address,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTypography.tabMedium.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
