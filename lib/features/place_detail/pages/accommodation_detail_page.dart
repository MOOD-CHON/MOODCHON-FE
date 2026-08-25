import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_typography.dart';
import '../../../core/widgets/banner/toast_overlay.dart';
import '../../../core/widgets/button/copy_button.dart';
import '../../../core/widgets/button/green/green_button.dart';
import '../../../core/widgets/button/green/green_button_size.dart';
import '../../../core/widgets/facility/facilities_all.dart';
import '../../../core/widgets/navigation/top_bar.dart';
import '../../../core/widgets/tag/map_tag.dart';
import '../../../core/widgets/tag/mood_tag.dart';
import '../data/accommodation_detail_mock_data.dart';
import '../models/accommodation_detail_data.dart';
import '../widgets/accommodation_condition_section.dart';
import '../widgets/accommodation_room_section.dart';
import '../widgets/detail_info_section.dart';

class AccommodationDetailPage extends StatelessWidget {
  const AccommodationDetailPage({
    super.key,
    this.data = accommodationDetailMockData,
  });

  final AccommodationDetailData data;

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

  bool get _hasFacilities {
    return data.facilities.any((facility) => facility.available != null);
  }

  bool get _hasUsageInfo =>
      _hasValue(data.checkInTime) || _hasValue(data.checkOutTime);

  bool get _hasContactInfo =>
      _hasValue(data.contact) || _hasValue(data.reservationHomepage);

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

  Future<void> _openReservationHomepage() async {
    final homepage = data.reservationHomepage;

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
                _AccommodationMainImage(imagePath: data.imagePath),

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

                            const SizedBox(height: 26),
                            _buildDescription(),

                            if (_visibleMoods.isNotEmpty) ...[
                              const SizedBox(height: 26),
                              _buildMood(),
                            ],

                            if (data.petAllowed ||
                                data.bbqAvailable ||
                                data.cookingAvailable) ...[
                              const SizedBox(height: 26),
                              AccommodationConditionSection(
                                petAllowed: data.petAllowed,
                                bbqAvailable: data.bbqAvailable,
                                cookingAvailable: data.cookingAvailable,
                              ),
                            ],

                            if (_hasFacilities) ...[
                              const SizedBox(height: 26),
                              const _DetailDivider(),

                              const SizedBox(height: 26),

                              FacilitiesAll(
                                title: '숙소 편의 시설',
                                items: data.facilities,
                              ),
                            ],

                            if (data.rooms.isNotEmpty) ...[
                              const SizedBox(height: 26),
                              const _DetailDivider(),

                              const SizedBox(height: 26),

                              Text(
                                '객실 정보',
                                style: AppTypography.titleMedium.copyWith(
                                  color: AppColors.textPrimary,
                                ),
                              ),

                              const SizedBox(height: 12),

                              AccommodationRoomSection(rooms: data.rooms),
                            ],

                            if (_hasUsageInfo) ...[
                              const SizedBox(height: 26),
                              const _DetailDivider(),

                              const SizedBox(height: 26),

                              DetailInfoSection(
                                title: '이용 안내',
                                items: [
                                  DetailInfoItem(
                                    label: '입실 시간',
                                    value: data.checkInTime,
                                  ),
                                  DetailInfoItem(
                                    label: '퇴실 시간',
                                    value: data.checkOutTime,
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
                                    label: '예약 홈페이지',
                                    value: data.reservationHomepage,
                                    isLink: true,
                                    onTap: _openReservationHomepage,
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

          _buildSaveButton(),
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
          '숙소 위치',
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

  Widget _buildDescription() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              '숙소 소개',
              style: AppTypography.titleMedium.copyWith(
                color: AppColors.textPrimary,
              ),
            ),

            const SizedBox(width: 6),

            const MapTag(
              label: '숙소',
              color: MapTagColor.green,
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

  Widget _buildMood() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '숙소 무드',
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

  Widget _buildSaveButton() {
    return Positioned(
      left: 16,
      right: 16,
      bottom: _saveButtonBottom,
      child: SafeArea(
        top: false,
        child: GreenButton(
          size: GreenButtonSize.long,
          label: '장소 저장하기',
          onTap: () {
            // TODO: 장소 저장 API 연동 시 구현
          },
        ),
      ),
    );
  }
}

class _AccommodationMainImage extends StatelessWidget {
  const _AccommodationMainImage({required this.imagePath});

  final String? imagePath;

  @override
  Widget build(BuildContext context) {
    final hasImage = imagePath != null && imagePath!.trim().isNotEmpty;

    return SizedBox(
      width: double.infinity,
      height: 387,
      child: hasImage
          ? Image.asset(imagePath!, fit: BoxFit.cover)
          : const ColoredBox(color: AppColors.linePrimary),
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
