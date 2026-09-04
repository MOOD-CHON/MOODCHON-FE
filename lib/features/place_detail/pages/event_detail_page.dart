import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_typography.dart';
import '../../../core/widgets/banner/toast_overlay.dart';
import '../../../core/widgets/button/copy_button.dart';
import '../../../core/widgets/navigation/top_bar.dart';
import '../../../core/widgets/tag/map_tag.dart';
import '../../../core/widgets/tag/mood_tag.dart';
import '../../place_save/widgets/place_save_button.dart';
import '../../travel_room/widgets/place_detail/mood_match_badge.dart';
import '../data/event_detail_mock_data.dart';
import '../models/event_place_type.dart';
import '../models/event_detail_data.dart';
import '../widgets/detail_info_section.dart';
import '../widgets/place_image_carousel.dart';
import '../widgets/program_section.dart';
import '../widgets/saved_place_delete_button.dart';

class EventDetailPage extends StatelessWidget {
  const EventDetailPage({
    super.key,
    this.data = eventDetailMockData,
    this.isSavedView = false,
    this.onDeleteFromFolder,
    this.moodMatchRate,
    this.accommodationDistanceText,
  });

  final EventDetailData data;
  final bool isSavedView;
  final VoidCallback? onDeleteFromFolder;

  final int? moodMatchRate;
  final String? accommodationDistanceText;

  static const double _saveButtonBottom = 22;
  static const double _saveButtonHeight = 49;
  static const double _toastGap = 12;

  bool get _isTravelRoomView => moodMatchRate != null;

  List<String> get _visibleMoods {
    return data.moods
        .map((mood) => mood.trim())
        .where((mood) => mood.isNotEmpty)
        .toList();
  }

  bool _hasValue(String? value) {
    return value != null && value.trim().isNotEmpty;
  }

  bool get _hasPrograms =>
      data.programs.any((program) => program.trim().isNotEmpty);

  bool get _hasUsageInfo =>
      _hasValue(data.eventPeriod) ||
      _hasValue(data.performanceTime) ||
      _hasValue(data.fee) ||
      _hasValue(data.ageLimit) ||
      _hasValue(data.eventPlace);

  bool get _hasContactInfo =>
      _hasValue(data.organizer) ||
      _hasValue(data.organizerContact) ||
      _hasValue(data.homepage);

  double _toastBottomOffset(BuildContext context) {
    final safeBottom = MediaQuery.paddingOf(context).bottom;

    return safeBottom + _saveButtonBottom + _saveButtonHeight + _toastGap;
  }

  Future<void> _copyAddress(BuildContext context) async {
    await Clipboard.setData(ClipboardData(text: data.fullAddress));

    if (!context.mounted) {
      return;
    }

    ToastOverlay.show(
      context,
      message: '주소를 복사했어요',
      bottom: isSavedView || _isTravelRoomView
          ? 33
          : _toastBottomOffset(context),
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
            padding: EdgeInsets.only(
              bottom: isSavedView || _isTravelRoomView ? 36 : 110,
            ),
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

                            if (_isTravelRoomView) ...[
                              const SizedBox(height: 16),

                              MoodMatchBadge(matchRate: moodMatchRate!),

                              const SizedBox(height: 20),
                            ] else
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

                            if (_hasPrograms) ...[
                              const SizedBox(height: 26),
                              ProgramSection(programs: data.programs),
                            ],

                            if (_hasUsageInfo) ...[
                              const SizedBox(height: 26),

                              const _DetailDivider(),

                              const SizedBox(height: 26),

                              DetailInfoSection(
                                title: '이용 안내',
                                items: [
                                  DetailInfoItem(
                                    label: '행사 기간',
                                    value: data.eventPeriod,
                                  ),
                                  DetailInfoItem(
                                    label: '공연 시간',
                                    value: data.performanceTime,
                                  ),
                                  DetailInfoItem(
                                    label: '이용 요금',
                                    value: data.fee,
                                  ),
                                  DetailInfoItem(
                                    label: '관람 가능 연령',
                                    value: data.ageLimit,
                                  ),
                                  DetailInfoItem(
                                    label: '행사 장소',
                                    value: data.eventPlace,
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
                                    label: '주최자 정보',
                                    value: data.organizer,
                                  ),
                                  DetailInfoItem(
                                    label: '주최자 연락처',
                                    value: data.organizerContact,
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

          if (!isSavedView && !_isTravelRoomView) _buildSaveButton(context),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Text(
                data.name,
                style: AppTypography.titlePlace.copyWith(
                  color: AppColors.textPrimary,
                ),
              ),
            ),
            if (isSavedView) ...[
              const SizedBox(width: 9),
              SavedPlaceDeleteButton(onDeleted: onDeleteFromFolder ?? () {}),
            ],
          ],
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
    final distanceText = accommodationDistanceText?.trim();

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

        if (_isTravelRoomView &&
            distanceText != null &&
            distanceText.isNotEmpty) ...[
          const SizedBox(height: 4),

          Text(
            distanceText,
            style: AppTypography.tabMedium.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildMood() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '행사 무드',
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
              '행사 소개',
              style: AppTypography.titleMedium.copyWith(
                color: AppColors.textPrimary,
              ),
            ),

            const SizedBox(width: 6),

            MapTag(
              label: data.type.label,
              color: data.type.mapTagColor,
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
