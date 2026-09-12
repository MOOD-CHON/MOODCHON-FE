import '../../../core/network/api_client.dart';
import '../../../core/network/api_result.dart';
import '../../chonkang_join/models/accommodation_condition.dart';
import '../../chonkang_join/models/chonkang_trip_info.dart';
import '../../chonkang_join/models/companion_type.dart';
import '../../chonkang_join/models/desired_region.dart';
import '../../chonkang_join/models/mood_card.dart';
import '../../chonkang_join/models/travel_method.dart';
import '../models/chonkang_member.dart';
import '../models/recommended_itinerary.dart';
import '../models/travel_room_main_data.dart';
import '../models/travel_room_main_mapper.dart';
import '../models/update_chonkang_info_result.dart';

class TravelRoomSettingsApi {
  const TravelRoomSettingsApi._();

  /// 촌캉스 방 안에서는 chonkangId로 바로 전체 여행 정보를 조회하는
  /// API가 없어서, 초대 코드를 먼저 조회한 뒤 그 코드로 여행 정보를
  /// 다시 조회합니다 (참여 화면에서 쓰는 것과 같은 응답 형태).
  static Future<ChonkangTripInfo> getTripInfo(int chonkangId) async {
    final inviteCode = await getInviteCode(chonkangId);

    return ApiResult.unwrap(
      () => ApiClient.instance.get('/api/chonkangs/invite/$inviteCode'),
      (data) => ChonkangTripInfo.fromJson(data as Map<String, dynamic>),
    );
  }

  /// 여행방 메인 화면(단계별 무드/숙소/일정 현황)에 필요한 데이터를
  /// 가져옵니다.
  static Future<TravelRoomMainData> getMainData(int chonkangId) async {
    final results = await Future.wait([
      ApiResult.unwrap(
        () => ApiClient.instance.get('/api/chonkangs/$chonkangId/main'),
        (data) => data as Map<String, dynamic>,
      ),
      getTripInfo(chonkangId),
    ]);

    final main = results[0] as Map<String, dynamic>;
    final tripInfo = results[1] as ChonkangTripInfo;

    return mapChonkangMainResponse(main, tripInfo);
  }

  static Future<String> getInviteCode(int chonkangId) {
    return ApiResult.unwrap(
      () => ApiClient.instance.get('/api/chonkangs/$chonkangId/invite-code'),
      (data) => (data as Map<String, dynamic>)['inviteCode'] as String,
    );
  }

  static Future<UpdateChonkangInfoResult> updateInfo(
    int chonkangId, {
    required String name,
    required DateTime startDate,
    required DateTime endDate,
    required int plannedMemberCount,
    required CompanionType companionType,
    required TravelMethod travelMethod,
    required DesiredRegion desiredRegion,
    required Set<AccommodationCondition> accommodationConditions,
    required bool retakeMood,
  }) {
    return ApiResult.unwrap(
      () => ApiClient.instance.patch(
        '/api/chonkangs/$chonkangId/info',
        data: {
          'name': name,
          'startDate': _formatDate(startDate),
          'endDate': _formatDate(endDate),
          'plannedMemberCount': plannedMemberCount,
          'companionType': companionType.apiValue,
          'travelMethod': travelMethod.apiValue,
          'desiredRegion': desiredRegion.apiValue,
          'accommodationConditions': accommodationConditions
              .map((condition) => condition.apiValue)
              .toList(),
          'retakeMood': retakeMood,
        },
      ),
      (data) =>
          UpdateChonkangInfoResult.fromJson(data as Map<String, dynamic>),
    );
  }

  static Future<String?> getCurrentMoodName(int chonkangId) {
    return ApiResult.unwrap(
      () => ApiClient.instance.get('/api/chonkangs/$chonkangId/main'),
      (data) {
        final moodResult = (data as Map<String, dynamic>)['moodResult'];

        if (moodResult is Map<String, dynamic>) {
          return moodResult['name'] as String?;
        }

        return null;
      },
    );
  }

  static Future<List<ChonkangMember>> getMembers(int chonkangId) {
    return ApiResult.unwrap(
      () => ApiClient.instance.get('/api/chonkangs/$chonkangId/members'),
      (data) => (data as List)
          .map((item) => ChonkangMember.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }

  /// 나가기 성공 시, 남아있는 다른 진행 중인 촌캉스가 있는지 여부를
  /// 돌려줍니다.
  static Future<bool> leave(int chonkangId) {
    return ApiResult.unwrap(
      () => ApiClient.instance.post('/api/chonkangs/$chonkangId/leave'),
      (data) =>
          (data as Map<String, dynamic>)['hasOtherOngoingChonkang'] as bool? ??
          false,
    );
  }

  static Future<List<MoodCard>> getRandomMoodCards() {
    return ApiResult.unwrap(
      () => ApiClient.instance.get('/api/mood-cards/random'),
      (data) => (data as List)
          .map((item) => MoodCard.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }

  static Future<void> submitMoodSelection(
    int chonkangId, {
    required Set<int> selectedMoodCardIds,
  }) {
    return ApiResult.unwrap(
      () => ApiClient.instance.post(
        '/api/chonkangs/$chonkangId/mood-selection',
        data: {'selectedMoodCardIds': selectedMoodCardIds.toList()},
      ),
      (_) {},
    );
  }

  static Future<RecommendedItinerary> getRecommendedItinerary(
    int chonkangId,
  ) {
    return ApiResult.unwrap(
      () => ApiClient.instance.get(
        '/api/chonkangs/$chonkangId/recommended-itinerary',
      ),
      (data) => RecommendedItinerary.fromJson(data as Map<String, dynamic>),
    );
  }

  static Future<void> commitRecommendedItinerary(int chonkangId) {
    return ApiResult.unwrap(
      () => ApiClient.instance.post(
        '/api/chonkangs/$chonkangId/recommended-itinerary/commit',
      ),
      (_) {},
    );
  }

  static String _formatDate(DateTime date) {
    final year = date.year.toString().padLeft(4, '0');
    final month = date.month.toString().padLeft(2, '0');
    final day = date.day.toString().padLeft(2, '0');

    return '$year-$month-$day';
  }
}
