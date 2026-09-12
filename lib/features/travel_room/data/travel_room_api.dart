import '../../../core/network/api_client.dart';
import '../models/travel_room_main_data.dart';

class TravelRoomApi {
  TravelRoomApi._();

  static final TravelRoomApi instance = TravelRoomApi._();

  Future<TravelRoomMainData> fetchMain(int chonkangId) async {
    final response = await ApiClient.instance.get('/api/chonkangs/$chonkangId/main');
    return TravelRoomMainData.fromJson(response.data['data'] as Map<String, dynamic>);
  }
}
