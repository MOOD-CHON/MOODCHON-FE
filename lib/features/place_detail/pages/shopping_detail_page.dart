import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_typography.dart';
import '../../../core/widgets/banner/toast_overlay.dart';
import '../../../core/widgets/button/copy_button.dart';
import '../../../core/widgets/facility/facilities_all.dart';
import '../../../core/widgets/facility/facility_item.dart';
import '../../../core/widgets/facility/facility_type.dart';
import '../../../core/widgets/navigation/top_bar.dart';
import '../../../core/widgets/tag/map_tag.dart';
import '../../../core/widgets/tag/mood_tag.dart';
import '../../place_save/widgets/place_save_button.dart';
import '../data/shopping_detail_mock_data.dart';
import '../models/shopping_detail_data.dart';
import '../widgets/detail_info_section.dart';
import '../widgets/place_image_carousel.dart';
import '../widgets/sales_item_section.dart';

class ShoppingDetailPage extends StatelessWidget {
  const ShoppingDetailPage({super.key, this.data = shoppingDetailMockData});

  final ShoppingDetailData data;

  static const double _saveButtonBottom = 22;
  static const double _saveButtonHeight = 49;
  static const double _toastGap = 12;

  List<String> get _visibleMoods {
    return data.moods
        .map((mood) => mood.trim())
        .where((mood) => mood.isNotEmpty)
        .toList();
  }

  bool _hasValue(String? value) {
    return value != null && value.trim().isNotEmpty;
  }

  List<FacilityItem> get _shoppingFacilities {
    const allowedTypes = {
      FacilityType.parking,
      FacilityType.toilet,
      FacilityType.stroller,
      FacilityType.card,
      FacilityType.puppy,
    };

    return data.facilities
        .where(
          (facility) =>
              allowedTypes.contains(facility.type) &&
              facility.available != null,
        )
        .toList();
  }

  bool get _hasSalesItem => _hasValue(data.salesItem);

  bool get _hasUsageInfo =>
      _hasValue(data.dayOff) ||
      _hasValue(data.businessHours) ||
      _hasValue(data.parkingFee);

  bool get _hasContactInfo =>
      _hasValue(data.contact) || _hasValue(data.homepage);

  double _toastBottomOffset(BuildContext context) {
    final safeBottom = MediaQuery.paddingOf(context).bottom;

    return safeBottom + _saveButtonBottom + _saveButtonHeight + _toastGap;
  }

  Future<void> _copyAddress(BuildContext context) async {
    await Clipboard.setData(ClipboardData(text: data.fullAddress));

    if (!context.mounted) return;

    ToastOverlay.show(
      context,
      message: '주소를 복사했어요',
      bottom: _toastBottomOffset(context),
    );
  }

  Future<void> _openHomepage() async {
    final homepage = data.homepage;

    if (!_hasValue(homepage)) {
      return;
    }

    final uri = Uri.tryParse(homepage!);

    if (uri == null) {
      return;
    }

    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundWhite,
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.only(bottom: 110),
            child: Stack(
              children: [
                PlaceImageCarousel(imagePaths: data.imagePaths),

                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: SafeArea(
                    bottom: false,
                    child: TopBar(
                      type: TopBarType.back,
                      onBack: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ),
                ),

                Container(
                  margin: const EdgeInsets.only(top: 348),
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: AppColors.backgroundWhite,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(top: 26, bottom: 36),
                    child: Center(
                      child: SizedBox(
                        width: 328,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildHeader(),

                            const SizedBox(height: 26),
                            const _DetailDivider(),

                            const SizedBox(height: 26),
                            _buildLocation(context),

                            if (_visibleMoods.isNotEmpty) ...[
                              const SizedBox(height: 26),
                              _buildMood(),
                            ],

                            const SizedBox(height: 26),
                            _buildDescription(),

                            if (_hasSalesItem) ...[
                              const SizedBox(height: 26),

                              SalesItemSection(salesItem: data.salesItem),
                            ],

                            if (_shoppingFacilities.isNotEmpty) ...[
                              const SizedBox(height: 26),
                              const _DetailDivider(),

                              const SizedBox(height: 26),

                              FacilitiesAll(
                                title: '편의 시설',
                                items: _shoppingFacilities,
                              ),
                            ],

                            if (_hasUsageInfo) ...[
                              const SizedBox(height: 26),
                              const _DetailDivider(),

                              const SizedBox(height: 26),

                              DetailInfoSection(
                                title: '이용 안내',
                                items: [
                                  DetailInfoItem(
                                    label: '쉬는 날',
                                    value: data.dayOff,
                                  ),
                                  DetailInfoItem(
                                    label: '영업 시간',
                                    value: data.businessHours,
                                  ),
                                  DetailInfoItem(
                                    label: '주차 요금',
                                    value: data.parkingFee,
                                  ),
                                ],
                              ),
                            ],

                            if (_hasContactInfo) ...[
                              const SizedBox(height: 26),

                              DetailInfoSection(
                                title: '문의 및 예약',
                                items: [
                                  DetailInfoItem(
                                    label: '문의',
                                    value: data.contact,
                                  ),
                                  DetailInfoItem(
                                    label: '홈페이지',
                                    value: data.homepage,
                                    isLink: true,
                                    onTap: _openHomepage,
                                  ),
                                ],
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          _buildSaveButton(context),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          data.name,
          style: AppTypography.titlePlace.copyWith(
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          data.aiSummary,
          style: AppTypography.captionPlace.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildLocation(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '위치',
          style: AppTypography.titleMedium.copyWith(
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              data.shortAddress,
              style: AppTypography.tabMedium.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(width: 7),
            CopyButton(
              onTap: () {
                _copyAddress(context);
              },
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildMood() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '장소 무드',
          style: AppTypography.titleMedium.copyWith(
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 7,
          runSpacing: 7,
          children: _visibleMoods
              .map(
                (mood) => MoodTag(
                  label: mood,
                  size: MoodTagSize.large,
                  background: MoodTagBackground.green,
                ),
              )
              .toList(),
        ),
      ],
    );
  }

  Widget _buildDescription() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              '장소 소개',
              style: AppTypography.titleMedium.copyWith(
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(width: 6),
            const MapTag(
              label: '쇼핑',
              color: MapTagColor.blue,
              size: MapTagSize.medium,
            ),
          ],
        ),
        const SizedBox(height: 12),
        Text(
          data.description,
          style: AppTypography.descriptionSmall.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildSaveButton(BuildContext context) {
    return Positioned(
      left: 16,
      right: 16,
      bottom: _saveButtonBottom,
      child: SafeArea(
        top: false,
        child: PlaceSaveButton(toastBottom: _toastBottomOffset(context)),
      ),
    );
  }
}

class _DetailDivider extends StatelessWidget {
  const _DetailDivider();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 328,
      height: 0.8,
      color: AppColors.linePrimary.withValues(alpha: 0.7),
    );
  }
}
