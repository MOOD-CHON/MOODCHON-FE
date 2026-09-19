import '../../../core/network/api_client.dart';
import '../../../core/network/api_result.dart';
import '../models/accommodation_condition.dart';
import '../models/chonkang_trip_info.dart';
import '../models/companion_type.dart';
import '../models/desired_region.dart';
import '../models/join_chonkang_result.dart';
import '../models/mood_card.dart';
import '../models/travel_method.dart';

class ChonkangJoinApi {
  const ChonkangJoinApi._();

  static Future<ChonkangTripInfo> getTripInfo(String inviteCode) {
    return ApiResult.unwrap(
      () => ApiClient.instance.get('/api/chonkangs/invite/$inviteCode'),
      (data) => ChonkangTripInfo.fromJson(data as Map<String, dynamic>),
    );
  }

  static Future<void> updateTripInfo(
    String inviteCode, {
    required String name,
    required DateTime startDate,
    required DateTime endDate,
    required int plannedMemberCount,
    required CompanionType companionType,
    required TravelMethod travelMethod,
    required DesiredRegion desiredRegion,
    required Set<AccommodationCondition> accommodationConditions,
  }) {
    return ApiResult.unwrap(
      () => ApiClient.instance.patch(
        '/api/chonkangs/invite/$inviteCode',
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
        },
      ),
      (_) {},
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

  static Future<JoinChonkangResult> join(
    String inviteCode, {
    required Set<int> selectedMoodCardIds,
  }) {
    return ApiResult.unwrap(
      () => ApiClient.instance.post(
        '/api/chonkangs/invite/$inviteCode/join',
        data: {'selectedMoodCardIds': selectedMoodCardIds.toList()},
      ),
      (data) => JoinChonkangResult.fromJson(data as Map<String, dynamic>),
    );
  }

  static String _formatDate(DateTime date) {
    final year = date.year.toString().padLeft(4, '0');
    final month = date.month.toString().padLeft(2, '0');
    final day = date.day.toString().padLeft(2, '0');

    return '$year-$month-$day';
  }
}
