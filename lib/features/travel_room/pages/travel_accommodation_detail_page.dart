import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_typography.dart';
import '../../../core/widgets/banner/toast_overlay.dart';
import '../../../core/widgets/button/copy_button.dart';
import '../../../core/widgets/button/green/green_button.dart';
import '../../../core/widgets/button/green/green_button_size.dart';
import '../../../core/widgets/button/half/half_button.dart';
import '../../../core/widgets/button/half/half_button_type.dart';
import '../../../core/widgets/facility/facilities_all.dart';
import '../../../core/widgets/modal/confirm/confirm_modal.dart';
import '../../../core/widgets/modal/confirm/confirm_modal_type.dart';
import '../../../core/widgets/navigation/top_bar.dart';
import '../../../core/widgets/tag/mood_tag.dart';
import '../../place_detail/widgets/accommodation_condition_section.dart';
import '../../place_detail/widgets/accommodation_room_section.dart';
import '../../place_detail/widgets/detail_info_section.dart';
import '../data/travel_accommodation_detail_mock_data.dart';
import '../models/travel_accommodation_detail_data.dart';
import '../widgets/accommodation/accommodation_match_section.dart';
import '../widgets/accommodation/accommodation_recommendation_stats.dart';
import '../widgets/accommodation/accommodation_vote_bottom_sheet.dart';

enum TravelAccommodationDetailMode { recommendation, confirmed }

class TravelAccommodationDetailPage extends StatefulWidget {
  const TravelAccommodationDetailPage({
    super.key,
    this.data = travelAccommodationDetailMockData,
    this.mode = TravelAccommodationDetailMode.recommendation,
    this.onConfirmedAccommodationCanceled,
  });

  final TravelAccommodationDetailData data;
  final TravelAccommodationDetailMode mode;

  final VoidCallback? onConfirmedAccommodationCanceled;

  @override
  State<TravelAccommodationDetailPage> createState() =>
      _TravelAccommodationDetailPageState();
}

class _TravelAccommodationDetailPageState
    extends State<TravelAccommodationDetailPage> {
  static const double _buttonBottom = 22;
  static const double _buttonHeight = 49;
  static const double _toastGap = 12;

  bool _hasVoted = false;

  TravelAccommodationDetailData get data => widget.data;

  bool get _isConfirmed =>
      widget.mode == TravelAccommodationDetailMode.confirmed;

  List<String> get _visibleMoods {
    return data.accommodation.moods
        .map((mood) => mood.trim())
        .where((mood) => mood.isNotEmpty)
        .toList();
  }

  bool _hasValue(String? value) {
    return value != null && value.trim().isNotEmpty;
  }

  bool get _hasFacilities {
    return data.accommodation.facilities.any(
      (facility) => facility.available != null,
    );
  }

  bool get _hasUsageInfo =>
      _hasValue(data.accommodation.checkInTime) ||
      _hasValue(data.accommodation.checkOutTime);

  bool get _hasContactInfo =>
      _hasValue(data.accommodation.contact) ||
      _hasValue(data.accommodation.reservationHomepage);

  double _toastBottomOffset(BuildContext context) {
    final safeBottom = MediaQuery.paddingOf(context).bottom;

    return safeBottom + _buttonBottom + _buttonHeight + _toastGap;
  }

  Future<void> _copyAddress(BuildContext context) async {
    await Clipboard.setData(
      ClipboardData(text: data.accommodation.fullAddress),
    );

    if (!context.mounted) {
      return;
    }

    ToastOverlay.show(
      context,
      message: '주소를 복사했어요',
      bottom: _toastBottomOffset(context),
    );
  }

  Future<void> _openReservationHomepage() async {
    final homepage = data.accommodation.reservationHomepage;

    if (!_hasValue(homepage)) {
      return;
    }

    final uri = Uri.tryParse(homepage!);

    if (uri == null) {
      return;
    }

    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  void _showVoters() {
    if (data.voters.length < 4) {
      return;
    }

    AccommodationVoteBottomSheet.show(context, members: data.voters);
  }

  void _vote() {
    if (_hasVoted) {
      return;
    }

    setState(() {
      _hasVoted = true;
    });

    ToastOverlay.show(
      context,
      message: '이 숙소에 투표했어요',
      bottom: _toastBottomOffset(context),
    );

    // TODO: 숙소 투표 API 연결
  }

  Future<void> _confirmAccommodation() async {
    final confirmed = await ConfirmModal.show(
      context,
      type: ConfirmModalType.sbTwo,
      title: '이 숙소로 확정할까요?',
      description: '숙소 주변의 활동과 일정을 추천해드려요.',
      confirmText: '확정하기',
      cancelText: '취소',
      top: 347,
    );

    if (confirmed != true || !mounted) {
      return;
    }

    // TODO: 숙소 확정 API 연결
    // TODO: 8.1 화면 구현 후 이동 연결
  }

  Future<void> _cancelConfirmedAccommodation() async {
    final confirmed = await ConfirmModal.show(
      context,
      type: ConfirmModalType.sbTwo,
      title: '숙소 확정을 취소할까요?',
      description: '확정을 취소하면 기존 일정이 전부 사라져요.',
      confirmText: '취소하기',
      cancelText: '취소',
      top: 347,
    );

    if (confirmed != true || !mounted) {
      return;
    }

    // TODO: 숙소 확정 취소 API 연결
    // TODO: 추천 일정 / 확정 일정 초기화
    // TODO: 6.2 구현 후 숙소 추천 단계로 이동

    final callback = widget.onConfirmedAccommodationCanceled;

    if (callback != null) {
      callback();
      return;
    }

    Navigator.of(context).pop(true);
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
                _AccommodationMainImage(
                  imagePath: data.accommodation.imagePath,
                ),

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

                            const SizedBox(height: 28),

                            AccommodationRecommendationStats(
                              matchRate: data.matchRate,
                              recommendationRank: data.recommendationRank,
                              voters: data.voters,
                              onVoteProfileTap: _showVoters,
                            ),

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

                            if (data.accommodation.petAllowed ||
                                data.accommodation.bbqAvailable ||
                                data.accommodation.cookingAvailable) ...[
                              const SizedBox(height: 26),

                              AccommodationConditionSection(
                                petAllowed: data.accommodation.petAllowed,
                                bbqAvailable: data.accommodation.bbqAvailable,
                                cookingAvailable:
                                    data.accommodation.cookingAvailable,
                              ),
                            ],

                            const SizedBox(height: 26),

                            const _DetailDivider(),

                            const SizedBox(height: 26),

                            AccommodationMatchSection(
                              type: AccommodationMatchSectionType.good,
                              reasons: data.matchReasons,
                            ),

                            const SizedBox(height: 26),

                            AccommodationMatchSection(
                              type: AccommodationMatchSectionType.regret,
                              reasons: data.regretReasons,
                            ),

                            if (_hasFacilities) ...[
                              const SizedBox(height: 26),

                              const _DetailDivider(),

                              const SizedBox(height: 26),

                              FacilitiesAll(
                                title: '숙소 편의 시설',
                                items: data.accommodation.facilities,
                              ),
                            ],

                            if (data.accommodation.rooms.isNotEmpty) ...[
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

                              AccommodationRoomSection(
                                rooms: data.accommodation.rooms,
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
                                    label: '입실 시간',
                                    value: data.accommodation.checkInTime,
                                  ),
                                  DetailInfoItem(
                                    label: '퇴실 시간',
                                    value: data.accommodation.checkOutTime,
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
                                    value: data.accommodation.contact,
                                  ),
                                  DetailInfoItem(
                                    label: '예약 홈페이지',
                                    value:
                                        data.accommodation.reservationHomepage,
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

          if (_isConfirmed)
            _buildConfirmedBottomButton()
          else
            _buildRecommendationBottomButtons(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          data.accommodation.name,
          style: AppTypography.titlePlace.copyWith(
            color: AppColors.textPrimary,
          ),
        ),

        const SizedBox(height: 8),

        Text(
          data.accommodation.aiSummary,
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
              data.accommodation.shortAddress,
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
        Text(
          '숙소 소개',
          style: AppTypography.titleMedium.copyWith(
            color: AppColors.textPrimary,
          ),
        ),

        const SizedBox(height: 12),

        Text(
          data.accommodation.description,
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

  Widget _buildRecommendationBottomButtons() {
    return Positioned(
      left: 16,
      right: 16,
      bottom: _buttonBottom,
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            Expanded(
              child: HalfButton(
                type: _hasVoted ? HalfButtonType.full : HalfButtonType.stroke,
                label: '이 숙소에 투표하기',
                disabled: _hasVoted,
                onTap: _vote,
              ),
            ),

            const SizedBox(width: 13),

            Expanded(
              child: HalfButton(
                type: HalfButtonType.full,
                label: '이 숙소로 확정하기',
                onTap: _confirmAccommodation,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildConfirmedBottomButton() {
    return Positioned(
      left: 16,
      right: 16,
      bottom: _buttonBottom,
      child: SafeArea(
        top: false,
        child: SizedBox(
          width: double.infinity,
          child: GreenButton(
            size: GreenButtonSize.long,
            label: '숙소 확정 취소하기',
            onTap: _cancelConfirmedAccommodation,
          ),
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
