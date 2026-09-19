import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_typography.dart';
import '../../../core/network/api_exception.dart';
import '../../../core/widgets/banner/toast_overlay.dart';
import '../../../core/widgets/button/copy_button.dart';
import '../../../core/widgets/button/green/green_button.dart';
import '../../../core/widgets/button/green/green_button_size.dart';
import '../../../core/widgets/icon/pin_icon.dart';
import '../../../core/widgets/image_count/image_count_badge.dart';
import '../../../core/widgets/navigation/top_bar.dart';
import '../../../core/widgets/tag/map_tag.dart';
import '../../../core/widgets/tag/mood_tag.dart';
import '../data/itinerary_api.dart';
import '../models/itinerary_item_detail.dart';

/// 9.3.3 장소 상세 페이지.
///
/// - [itemId]가 있으면 이미 담긴 항목을 보기만 합니다.
/// - [placeId]가 있으면 미리보기이며, [addTargetDay]가 있으면
///   "일정에 추가하기" 버튼으로 해당 일차에 담을 수 있습니다.
class ItineraryPlaceDetailPage extends StatefulWidget {
  const ItineraryPlaceDetailPage({
    super.key,
    required this.chonkangId,
    this.itemId,
    this.placeId,
    this.addTargetDay,
  }) : assert(
         itemId != null || placeId != null,
         'itemId 또는 placeId 중 하나는 있어야 합니다.',
       );

  final int chonkangId;
  final int? itemId;
  final int? placeId;
  final int? addTargetDay;

  @override
  State<ItineraryPlaceDetailPage> createState() =>
      _ItineraryPlaceDetailPageState();
}

class _ItineraryPlaceDetailPageState extends State<ItineraryPlaceDetailPage> {
  final PageController _imageController = PageController();

  bool _isLoading = true;
  bool _isAdding = false;
  String? _errorMessage;
  ItineraryItemDetail? _detail;
  int _imageIndex = 0;

  bool get _canAdd => widget.addTargetDay != null && widget.placeId != null;

  @override
  void initState() {
    super.initState();

    _fetchDetail();
  }

  @override
  void dispose() {
    _imageController.dispose();

    super.dispose();
  }

  Future<void> _fetchDetail() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final detail = widget.itemId != null
          ? await ItineraryApi.getItemDetail(widget.chonkangId, widget.itemId!)
          : await ItineraryApi.previewPlace(
              widget.chonkangId,
              widget.placeId!,
            );

      if (mounted) {
        setState(() {
          _detail = detail;
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

  Future<void> _handleAdd() async {
    final detail = _detail;
    if (detail == null || _isAdding) {
      return;
    }

    setState(() {
      _isAdding = true;
    });

    try {
      await ItineraryApi.addPlaceItem(
        widget.chonkangId,
        dayNumber: widget.addTargetDay!,
        placeId: detail.place.id,
      );

      if (mounted) {
        Navigator.of(context).pop(true);
      }
    } on ApiException catch (error) {
      if (mounted) {
        ToastOverlay.show(context, message: error.message, bottom: 96);
        setState(() {
          _isAdding = false;
        });
      }
    }
  }

  void _copyAddress(String address) {
    Clipboard.setData(ClipboardData(text: address));
    ToastOverlay.show(context, message: '주소를 복사했어요.', bottom: 96);
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
              title: '장소 상세',
              onBack: () {
                Navigator.of(context).pop();
              },
            ),
            Expanded(child: _buildBody()),
            if (_canAdd && _detail != null)
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                child: GreenButton(
                  size: GreenButtonSize.long,
                  label: '일정에 추가하기',
                  onTap: _isAdding ? () {} : _handleAdd,
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

    final detail = _detail;

    if (_errorMessage != null || detail == null) {
      return Center(
        child: Text(
          _errorMessage ?? '장소 정보를 불러오지 못했어요.',
          style: AppTypography.bodyExtraLarge.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildImages(detail),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        detail.place.name,
                        style: AppTypography.titlePlace.copyWith(
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),
                  ],
                ),
                if (detail.aiSummary.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Text(
                    detail.aiSummary,
                    style: AppTypography.bodyLarge.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
                const SizedBox(height: 14),
                Row(
                  children: [
                    Text(
                      '무드 적합도',
                      style: AppTypography.tabMedium.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${detail.moodFitScore}%',
                      style: AppTypography.bodyMood.copyWith(
                        color: AppColors.main,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                _SectionTitle('위치'),
                const SizedBox(height: 8),
                _buildLocation(detail),
                if (detail.tags.isNotEmpty) ...[
                  const SizedBox(height: 20),
                  _SectionTitle('장소 무드'),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 4,
                    runSpacing: 4,
                    children: detail.tags
                        .map(
                          (tag) => MoodTag(
                            label: tag,
                            size: MoodTagSize.medium,
                            background: MoodTagBackground.green,
                          ),
                        )
                        .toList(),
                  ),
                ],
                if ((detail.description ?? '').isNotEmpty) ...[
                  const SizedBox(height: 20),
                  _SectionTitle('장소 소개'),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      MapTag(
                        label: detail.place.categoryLabel,
                        color: detail.place.tagColor,
                        size: MapTagSize.medium,
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    detail.description!,
                    style: AppTypography.bodyLarge.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImages(ItineraryItemDetail detail) {
    final images = detail.images;

    if (images.isEmpty) {
      return Container(
        width: double.infinity,
        height: 240,
        color: AppColors.linePrimary,
      );
    }

    return SizedBox(
      width: double.infinity,
      height: 240,
      child: Stack(
        children: [
          PageView.builder(
            controller: _imageController,
            itemCount: images.length,
            onPageChanged: (index) {
              setState(() {
                _imageIndex = index;
              });
            },
            itemBuilder: (_, index) {
              return Image.network(
                images[index],
                fit: BoxFit.cover,
                errorBuilder: (_, _, _) {
                  return Container(color: AppColors.linePrimary);
                },
              );
            },
          ),
          if (images.length > 1)
            Positioned(
              right: 16,
              bottom: 16,
              child: ImageCountBadge(
                current: _imageIndex + 1,
                total: images.length,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildLocation(ItineraryItemDetail detail) {
    final address = detail.place.address ?? '';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const PinIcon(size: PinIconSize.medium),
            const SizedBox(width: 4),
            Expanded(
              child: Text(
                address.isEmpty ? '주소 정보가 없어요.' : address,
                style: AppTypography.tabMedium.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ),
            if (address.isNotEmpty) ...[
              const SizedBox(width: 8),
              CopyButton(onTap: () => _copyAddress(address)),
            ],
          ],
        ),
        if (detail.accommodationDistanceText != null) ...[
          const SizedBox(height: 6),
          Text(
            detail.accommodationDistanceText!,
            style: AppTypography.captionMedium.copyWith(
              color: AppColors.grayPrimary,
            ),
          ),
        ],
      ],
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: AppTypography.titleSmall.copyWith(color: AppColors.black),
    );
  }
}
