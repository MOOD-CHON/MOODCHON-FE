import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_shadows.dart';
import '../../../app/theme/app_typography.dart';
import '../../../core/network/api_exception.dart';
import '../../../core/widgets/banner/toast_overlay.dart';
import '../../../core/widgets/button/green/green_thin_button.dart';
import '../../../core/widgets/button/stroke/white_medium_stroke_button.dart';
import '../../../core/widgets/navigation/top_bar.dart';
import '../../../core/widgets/tag/map_tag.dart';
import '../data/itinerary_api.dart';
import '../models/itinerary_activity_suggestion.dart';
import 'add_custom_itinerary_item_page.dart';
import 'itinerary_place_search_page.dart';

/// 9.3.1-1 일정 추가하기 — 검색 / 장소 없이 추가 / 추천 활동.
class AddItineraryItemPage extends StatefulWidget {
  const AddItineraryItemPage({
    super.key,
    required this.chonkangId,
    required this.dayNumber,
  });

  final int chonkangId;
  final int dayNumber;

  @override
  State<AddItineraryItemPage> createState() => _AddItineraryItemPageState();
}

class _AddItineraryItemPageState extends State<AddItineraryItemPage> {
  bool _isLoading = true;
  String? _errorMessage;
  List<ItineraryActivitySuggestion> _suggestions = const [];
  int? _addingPlaceId;

  @override
  void initState() {
    super.initState();

    _fetchSuggestions();
  }

  Future<void> _fetchSuggestions() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final suggestions = await ItineraryApi.getSuggestions(widget.chonkangId);

      if (mounted) {
        setState(() {
          _suggestions = suggestions;
        });
      }
    } on ApiException catch (error) {
      if (mounted) {
        setState(() {
          _errorMessage = error.message;
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

  Future<void> _openSearch() async {
    final added = await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (_) => ItineraryPlaceSearchPage(
          chonkangId: widget.chonkangId,
          dayNumber: widget.dayNumber,
        ),
      ),
    );

    if (added == true && mounted) {
      Navigator.of(context).pop(true);
    }
  }

  Future<void> _openCustom() async {
    final added = await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (_) => AddCustomItineraryItemPage(
          chonkangId: widget.chonkangId,
          dayNumber: widget.dayNumber,
        ),
      ),
    );

    if (added == true && mounted) {
      Navigator.of(context).pop(true);
    }
  }

  Future<void> _addSuggestion(ItineraryActivitySuggestion suggestion) async {
    if (_addingPlaceId != null) {
      return;
    }

    setState(() {
      _addingPlaceId = suggestion.placeId;
    });

    try {
      await ItineraryApi.addPlaceItem(
        widget.chonkangId,
        dayNumber: widget.dayNumber,
        placeId: suggestion.placeId,
      );

      if (mounted) {
        Navigator.of(context).pop(true);
      }
    } on ApiException catch (error) {
      if (mounted) {
        ToastOverlay.show(context, message: error.message, bottom: 40);
        setState(() {
          _addingPlaceId = null;
        });
      }
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
            TopBar(
              type: TopBarType.title,
              title: '일정 추가하기',
              onBack: () => Navigator.of(context).pop(),
            ),
            _buildHeaderActions(),
            Expanded(child: _buildSuggestions()),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderActions() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
      child: Column(
        children: [
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: _openSearch,
            child: Container(
              height: 45,
              padding: const EdgeInsets.symmetric(horizontal: 14),
              decoration: BoxDecoration(
                color: AppColors.backgroundWhite,
                borderRadius: BorderRadius.circular(30),
                boxShadow: AppShadows.base,
              ),
              child: Row(
                children: [
                  SvgPicture.asset(
                    'assets/icons/search/search.svg',
                    width: 24,
                    height: 24,
                    colorFilter: const ColorFilter.mode(
                      AppColors.black,
                      BlendMode.srcIn,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '장소를 검색해보세요',
                    style: AppTypography.bodyExtraLarge.copyWith(
                      color: AppColors.black.withValues(alpha: 0.4),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          WhiteMediumStrokeButton(
            label: '장소 없이 추가하기',
            onTap: _openCustom,
          ),
        ],
      ),
    );
  }

  Widget _buildSuggestions() {
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

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
      children: [
        Text(
          '무드촌이 추천하는 활동',
          style: AppTypography.titleMedium.copyWith(color: AppColors.black),
        ),
        const SizedBox(height: 14),
        if (_suggestions.isEmpty)
          Text(
            '추천할 활동을 찾지 못했어요.',
            style: AppTypography.captionMedium.copyWith(
              color: AppColors.grayPrimary,
            ),
          )
        else
          ..._suggestions.map(
            (suggestion) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _SuggestionCard(
                suggestion: suggestion,
                isAdding: _addingPlaceId == suggestion.placeId,
                onAdd: () => _addSuggestion(suggestion),
              ),
            ),
          ),
      ],
    );
  }
}

class _SuggestionCard extends StatelessWidget {
  const _SuggestionCard({
    required this.suggestion,
    required this.isAdding,
    required this.onAdd,
  });

  final ItineraryActivitySuggestion suggestion;
  final bool isAdding;
  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AppColors.backgroundWhite,
        borderRadius: BorderRadius.circular(16),
        boxShadow: AppShadows.card,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: suggestion.thumbnailUrl == null ||
                        suggestion.thumbnailUrl!.trim().isEmpty
                    ? Container(
                        width: 68,
                        height: 48,
                        color: AppColors.linePrimary,
                      )
                    : Image.network(
                        suggestion.thumbnailUrl!,
                        width: 68,
                        height: 48,
                        fit: BoxFit.cover,
                        errorBuilder: (_, _, _) => Container(
                          width: 68,
                          height: 48,
                          color: AppColors.linePrimary,
                        ),
                      ),
              ),
              const SizedBox(width: 13),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            suggestion.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppTypography.tabLarge.copyWith(
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          '무드 적합도 ${suggestion.moodFitScore}%',
                          style: AppTypography.captionExtraSmall.copyWith(
                            color: AppColors.main,
                          ),
                        ),
                      ],
                    ),
                    if (suggestion.accommodationDistanceText != null) ...[
                      const SizedBox(height: 2),
                      Text(
                        suggestion.accommodationDistanceText!,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTypography.captionExtraSmall.copyWith(
                          color: AppColors.grayPrimary,
                        ),
                      ),
                    ],
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        MapTag(
                          label: suggestion.categoryLabel,
                          color: suggestion.tagColor,
                          size: MapTagSize.small,
                        ),
                        const SizedBox(width: 2),
                        Expanded(
                          child: Text(
                            suggestion.aiSummary,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppTypography.captionExtraSmall.copyWith(
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            child: GreenThinButton(
              label: isAdding ? '추가하는 중...' : '일정에 추가하기',
              onTap: isAdding ? () {} : onAdd,
            ),
          ),
        ],
      ),
    );
  }
}
