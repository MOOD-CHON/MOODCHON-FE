import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/network/remote_image.dart';

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
import '../data/travel_room_api.dart';
import '../models/travel_accommodation_detail_data.dart';
import '../models/vote_member.dart';
import 'travel_room_main_loader_page.dart';
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

  late bool _hasVoted = widget.data.votedByMe;

  // 투표 직후 구성원 프로필이 바로 반영되도록 서버에서 다시 받아 갱신한다.
  late List<VoteMember> _voters = widget.data.voters;

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
    if (_voters.length < 4) {
      return;
    }

    AccommodationVoteBottomSheet.show(context, members: _voters);
  }

  Future<void> _vote() async {
    if (_hasVoted) {
      return;
    }

    final chonkangId = data.chonkangId;
    final placeId = data.placeId;

    // 눌렀을 때 바로 반영하고, 실패하면 되돌린다.
    setState(() {
      _hasVoted = true;
    });

    if (chonkangId != null && placeId != null) {
      try {
        await TravelRoomApi.instance.voteAccommodation(chonkangId, placeId);
        final voters = await TravelRoomApi.instance.fetchAccommodationVoters(
          chonkangId,
          placeId,
        );
        if (mounted) {
          setState(() {
            _voters = voters;
          });
        }
      } catch (_) {
        if (!mounted) {
          return;
        }
        setState(() {
          _hasVoted = false;
        });
        ToastOverlay.show(
          context,
          message: '투표에 실패했어요. 잠시 후 다시 시도해주세요',
          bottom: _toastBottomOffset(context),
        );
        return;
      }
    }

    if (!mounted) {
      return;
    }

    ToastOverlay.show(
      context,
      message: '이 숙소에 투표했어요',
      bottom: _toastBottomOffset(context),
    );
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

    final chonkangId = data.chonkangId;
    final placeId = data.placeId;

    if (chonkangId != null && placeId != null) {
      try {
        await TravelRoomApi.instance.confirmAccommodation(chonkangId, placeId);
      } catch (_) {
        if (!mounted) {
          return;
        }
        ToastOverlay.show(
          context,
          message: '숙소 확정에 실패했어요. 잠시 후 다시 시도해주세요',
          bottom: _toastBottomOffset(context),
        );
        return;
      }
    }

    if (!mounted) {
      return;
    }

    if (chonkangId == null) {
      Navigator.of(context).pop(true);
      return;
    }

    // 확정하면 방 상태가 ACCOMMODATION_CONFIRMED로 바뀐다. 로더를 새로 띄워
    // 여행방을 다시 불러오게 하고, 그 위에 쌓여 있던 추천/상세 화면은 걷어낸다.
    // TODO: 8.1 화면이 생기면 그쪽으로 이동하도록 교체
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute<void>(
        builder: (_) => TravelRoomMainLoaderPage(chonkangId: chonkangId),
      ),
      (route) => route.isFirst,
    );
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

    final chonkangId = data.chonkangId;

    if (chonkangId != null) {
      try {
        // 서버가 확정 해제와 함께 추천/확정 일정도 초기화한다.
        await TravelRoomApi.instance.cancelConfirmedAccommodation(chonkangId);
      } catch (_) {
        if (!mounted) {
          return;
        }
        ToastOverlay.show(
          context,
          message: '확정 취소에 실패했어요. 잠시 후 다시 시도해주세요',
          bottom: _toastBottomOffset(context),
        );
        return;
      }
    }

    if (!mounted) {
      return;
    }

    final callback = widget.onConfirmedAccommodationCanceled;

    if (callback != null) {
      callback();
    }

    if (!mounted) {
      return;
    }

    if (chonkangId == null) {
      Navigator.of(context).pop(true);
      return;
    }

    // 확정을 풀면 방 상태가 무드 결정 단계로 돌아간다. 여행방을 다시 불러온다.
    // TODO: 6.2 구현 후 숙소 추천 단계로 바로 이동하도록 교체
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute<void>(
        builder: (_) => TravelRoomMainLoaderPage(chonkangId: chonkangId),
      ),
      (route) => route.isFirst,
    );
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
                              voters: _voters,
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

    if (!hasImage) {
      return const SizedBox(
        width: double.infinity,
        height: 387,
        child: ColoredBox(color: AppColors.linePrimary),
      );
    }

    final path = imagePath!.trim();
    // TourAPI 숙소 사진은 원격 URL이고, 목 데이터는 에셋 경로를 쓴다.
    final isNetworkImage = path.startsWith('http');

    return SizedBox(
      width: double.infinity,
      height: 387,
      child: isNetworkImage
          ? Image.network(
              secureImageUrl(path),
              webHtmlElementStrategy: kRemoteImageStrategy,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) =>
                  const ColoredBox(color: AppColors.linePrimary),
            )
          : Image.asset(path, fit: BoxFit.cover),
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
