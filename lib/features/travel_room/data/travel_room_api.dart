import '../../../core/network/api_client.dart';
import '../models/accommodation_recommendation.dart';
import '../models/chonkang_trip_info.dart';
import '../models/mood_result_detail.dart';
import '../models/travel_room_main_data.dart';

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
