import 'package:flutter/material.dart';

import '../../../app/theme/app_colors.dart';
import '../../../core/widgets/banner/toast_overlay.dart';
import '../../../core/widgets/empty_state/character/empty_state_character_medium.dart';
import '../../../core/widgets/modal/confirm/confirm_modal.dart';
import '../../../core/widgets/modal/confirm/confirm_modal_type.dart';
import '../../../core/widgets/navigation/top_bar.dart';
import '../../../core/widgets/select_image/select_image_grid.dart';
import '../../../core/widgets/select_image/select_image_mode.dart';
import '../../explore/models/explore_item.dart';
import '../../place_detail/data/event_detail_mock_data.dart';
import '../../place_detail/data/tourism_detail_mock_data.dart';
import '../../place_detail/pages/accommodation_detail_page.dart';
import '../../place_detail/pages/event_detail_page.dart';
import '../../place_detail/pages/restaurant_detail_page.dart';
import '../../place_detail/pages/shopping_detail_page.dart';
import '../../place_detail/pages/tourism_detail_page.dart';
import '../../place_save/models/place_folder.dart';
import '../data/saved_place_mock_data.dart';
import '../models/saved_folder_detail_result.dart';

class SavedFolderDetailPage extends StatefulWidget {
  const SavedFolderDetailPage({super.key, required this.folder});

  final PlaceFolder folder;

  @override
  State<SavedFolderDetailPage> createState() => _SavedFolderDetailPageState();
}

class _SavedFolderDetailPageState extends State<SavedFolderDetailPage> {
  late final List<ExploreItem> _places;

  @override
  void initState() {
    super.initState();

    _places = List<ExploreItem>.from(
      savedPlaceMockData[widget.folder.id] ?? [],
    );
  }

  List<SelectImageGridItem> get _gridItems {
    return _places
        .map(
          (item) => SelectImageGridItem(
            id: item.id,
            imageUrl: item.imageUrl,
            tag: item.tag,
          ),
        )
        .toList();
  }

  SavedFolderDetailResult _buildResult({bool folderDeleted = false}) {
    return SavedFolderDetailResult(
      folderDeleted: folderDeleted,
      placeCount: _places.length,
      coverImageUrl: _places.isEmpty ? null : _places.first.imageUrl,
    );
  }

  void _handleBack() {
    Navigator.of(context).pop(_buildResult());
  }

  Future<void> _handleDeleteFolder() async {
    final confirmed = await ConfirmModal.show(
      context,
      type: ConfirmModalType.sbTwo,
      title: '이 폴더를 삭제할까요?',
      description: '삭제한 폴더는 되돌릴 수 없어요.',
      confirmText: '삭제하기',
    );

    if (confirmed != true || !mounted) {
      return;
    }

    Navigator.of(context).pop(_buildResult(folderDeleted: true));
  }

  Future<void> _handlePlaceTap(String id) async {
    ExploreItem? selectedItem;

    for (final item in _places) {
      if (item.id == id) {
        selectedItem = item;
        break;
      }
    }

    if (selectedItem == null) {
      return;
    }

    final deleted = await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (_) {
          return _buildDetailPage(selectedItem!);
        },
      ),
    );

    if (deleted != true || !mounted) {
      return;
    }

    setState(() {
      _places.removeWhere((item) => item.id == id);
    });

    ToastOverlay.show(context, message: '장소를 폴더에서 삭제했어요', bottom: 33);
  }

  Widget _buildDetailPage(ExploreItem item) {
    void handleDeleted() {
      Navigator.of(context).pop(true);
    }

    switch (item.placeType) {
      case ExplorePlaceType.accommodation:
        return AccommodationDetailPage(
          isSavedView: true,
          onDeleteFromFolder: handleDeleted,
        );

      case ExplorePlaceType.attraction:
        return TourismDetailPage(
          data: attractionDetailMockData,
          isSavedView: true,
          onDeleteFromFolder: handleDeleted,
        );

      case ExplorePlaceType.culturalFacility:
        return TourismDetailPage(
          data: culturalFacilityDetailMockData,
          isSavedView: true,
          onDeleteFromFolder: handleDeleted,
        );

      case ExplorePlaceType.leisureSports:
        return TourismDetailPage(
          data: leisureSportsDetailMockData,
          isSavedView: true,
          onDeleteFromFolder: handleDeleted,
        );

      case ExplorePlaceType.event:
        return EventDetailPage(
          data: eventDetailMockData,
          isSavedView: true,
          onDeleteFromFolder: handleDeleted,
        );

      case ExplorePlaceType.performance:
        return EventDetailPage(
          data: performanceDetailMockData,
          isSavedView: true,
          onDeleteFromFolder: handleDeleted,
        );

      case ExplorePlaceType.festival:
        return EventDetailPage(
          data: festivalDetailMockData,
          isSavedView: true,
          onDeleteFromFolder: handleDeleted,
        );

      case ExplorePlaceType.restaurant:
        return RestaurantDetailPage(
          isSavedView: true,
          onDeleteFromFolder: handleDeleted,
        );

      case ExplorePlaceType.shopping:
        return ShoppingDetailPage(
          isSavedView: true,
          onDeleteFromFolder: handleDeleted,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final hasPlaces = _places.isNotEmpty;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) {
          _handleBack();
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.backgroundPrimary,
        body: SafeArea(
          bottom: false,
          child: Column(
            children: [
              TopBar(
                type: TopBarType.delete,
                title: widget.folder.name,
                onBack: _handleBack,
                onDelete: _handleDeleteFolder,
              ),

              Expanded(
                child: hasPlaces
                    ? CustomScrollView(
                        slivers: [
                          const SliverToBoxAdapter(child: SizedBox(height: 12)),

                          SliverToBoxAdapter(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                              ),
                              child: SelectImageGrid(
                                items: _gridItems,
                                mode: SelectImageMode.explore,
                                onExploreTap: _handlePlaceTap,
                              ),
                            ),
                          ),

                          const SliverToBoxAdapter(child: SizedBox(height: 33)),
                        ],
                      )
                    : const Column(
                        children: [
                          SizedBox(height: 215),

                          Center(
                            child: EmptyStateCharacterMedium(
                              title: '아직 폴더에 저장한 장소가 없어요.',
                              description: '탐색 탭에서 장소를 저장해주세요.',
                            ),
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
