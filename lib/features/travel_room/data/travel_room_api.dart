import '../../../core/network/api_client.dart';
import '../models/accommodation_recommendation.dart';
import '../models/chonkang_trip_info.dart';
import '../models/mood_result_detail.dart';
import '../models/travel_room_main_data.dart';
import '../models/vote_member.dart';

class TravelRoomApi {
  TravelRoomApi._();

  static final TravelRoomApi instance = TravelRoomApi._();

  Future<TravelRoomMainData> fetchMain(int chonkangId) async {
    final response = await ApiClient.instance.get('/api/chonkangs/$chonkangId/main');
    return TravelRoomMainData.fromJson(response.data['data'] as Map<String, dynamic>);
  }

  Future<void> remindMoodSelection(int chonkangId) async {
    await ApiClient.instance.post('/api/chonkangs/$chonkangId/mood-selection/remind');
  }

  Future<List<AccommodationRecommendation>> fetchAllRecommendedAccommodations(
    int chonkangId,
  ) async {
    final response = await ApiClient.instance.get(
      '/api/chonkangs/$chonkangId/recommended-accommodations',
    );
    final records = List<Map<String, dynamic>>.from(response.data['data'] as List);
    return records.map(AccommodationRecommendation.fromJson).toList();
  }

  /// 확정된 숙소. 응답 형태가 추천 목록과 같아 같은 파서를 쓴다.
  /// 추천을 거치지 않고 직접 찾은 숙소를 확정한 경우 matchScore/rank는 null이다.
  Future<AccommodationRecommendation> fetchConfirmedAccommodation(
    int chonkangId,
  ) async {
    final response = await ApiClient.instance.get(
      '/api/chonkangs/$chonkangId/accommodation/confirmed',
    );
    return AccommodationRecommendation.fromJson(
      response.data['data'] as Map<String, dynamic>,
    );
  }

  /// 이미 투표한 상태에서 다시 호출해도 서버가 조용히 무시한다.
  Future<void> voteAccommodation(int chonkangId, int placeId) async {
    await ApiClient.instance.post(
      '/api/chonkangs/$chonkangId/recommended-accommodations/$placeId/vote',
    );
  }

  /// 투표 직후 구성원 프로필을 갱신할 때 쓴다.
  Future<List<VoteMember>> fetchAccommodationVoters(
    int chonkangId,
    int placeId,
  ) async {
    final response = await ApiClient.instance.get(
      '/api/chonkangs/$chonkangId/recommended-accommodations/$placeId/voters',
    );
    final records = List<Map<String, dynamic>>.from(
      response.data['data'] as List,
    );
    return records.map(VoteMember.fromJson).toList();
  }

  Future<void> confirmAccommodation(int chonkangId, int placeId) async {
    await ApiClient.instance.post(
      '/api/chonkangs/$chonkangId/accommodation/$placeId/confirm',
    );
  }

  /// 확정을 취소하면 서버에서 추천/확정 일정도 함께 초기화된다.
  Future<void> cancelConfirmedAccommodation(int chonkangId) async {
    await ApiClient.instance.delete(
      '/api/chonkangs/$chonkangId/accommodation/confirm',
    );
  }

  Future<ChonkangTripInfo> fetchTripInfo(int chonkangId) async {
    final response = await ApiClient.instance.get('/api/chonkangs/$chonkangId/trip-info');
    return ChonkangTripInfo.fromJson(response.data['data'] as Map<String, dynamic>);
  }

  Future<MoodResultDetail> fetchMoodResultDetail(int chonkangId) async {
    final response = await ApiClient.instance.get(
      '/api/chonkangs/$chonkangId/mood-result/detail',
    );
    return MoodResultDetail.fromJson(response.data['data'] as Map<String, dynamic>);
  }
}
