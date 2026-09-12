import '../../../core/network/api_client.dart';
import '../../../core/network/api_result.dart';
import '../models/itinerary_activity_suggestion.dart';
import '../models/itinerary_item_detail.dart';
import '../models/itinerary_place_category.dart';
import '../models/place_search_result.dart';
import '../models/recommended_itinerary.dart';

/// 9.x 일정 확인 및 수정 화면에서 쓰는 API 모음.
class ItineraryApi {
  const ItineraryApi._();

  static String _base(int chonkangId) =>
      '/api/chonkangs/$chonkangId/recommended-itinerary';

  /// 9.1 / 9.2 – 전체 일정 조회.
  static Future<RecommendedItinerary> getItinerary(int chonkangId) {
    return ApiResult.unwrap(
      () => ApiClient.instance.get(_base(chonkangId)),
      (data) => RecommendedItinerary.fromJson(data as Map<String, dynamic>),
    );
  }

  /// 9.3.3 – 이미 담긴 항목의 상세.
  static Future<ItineraryItemDetail> getItemDetail(
    int chonkangId,
    int itemId,
  ) {
    return ApiResult.unwrap(
      () => ApiClient.instance.get('${_base(chonkangId)}/items/$itemId'),
      (data) => ItineraryItemDetail.fromJson(data as Map<String, dynamic>),
    );
  }

  /// 9.3.1-1 – "무드촌이 추천하는 활동" 목록.
  static Future<List<ItineraryActivitySuggestion>> getSuggestions(
    int chonkangId,
  ) {
    return ApiResult.unwrap(
      () => ApiClient.instance.get('${_base(chonkangId)}/suggestions'),
      (data) => (data as List)
          .map(
            (item) => ItineraryActivitySuggestion.fromJson(
              item as Map<String, dynamic>,
            ),
          )
          .toList(),
    );
  }

  /// 9.3.2 – 장소 검색.
  static Future<List<PlaceSearchResult>> searchPlaces(
    int chonkangId, {
    required String keyword,
  }) {
    return ApiResult.unwrap(
      () => ApiClient.instance.get(
        '${_base(chonkangId)}/places/search',
        queryParameters: {'keyword': keyword},
      ),
      (data) => (data as List)
          .map(
            (item) => PlaceSearchResult.fromJson(item as Map<String, dynamic>),
          )
          .toList(),
    );
  }

  /// 9.3.3 – 아직 담기지 않은 장소의 미리보기 상세.
  static Future<ItineraryItemDetail> previewPlace(
    int chonkangId,
    int placeId,
  ) {
    return ApiResult.unwrap(
      () => ApiClient.instance.get(
        '${_base(chonkangId)}/places/$placeId/preview',
      ),
      (data) => ItineraryItemDetail.fromJson(data as Map<String, dynamic>),
    );
  }

  /// 9.3.2 / 9.3.3 – 특정 일차에 장소 항목 추가.
  static Future<void> addPlaceItem(
    int chonkangId, {
    required int dayNumber,
    required int placeId,
  }) {
    return ApiResult.unwrap(
      () => ApiClient.instance.post(
        '${_base(chonkangId)}/days/$dayNumber/items',
        data: {'placeId': placeId},
      ),
      (_) {},
    );
  }

  /// 9.3.1-2 – 특정 일차에 "장소 없이" 항목 추가.
  static Future<void> addCustomItem(
    int chonkangId, {
    required int dayNumber,
    required String name,
    required ItineraryPlaceCategory category,
  }) {
    return ApiResult.unwrap(
      () => ApiClient.instance.post(
        '${_base(chonkangId)}/days/$dayNumber/items/custom',
        data: {'name': name, 'category': category.apiValue},
      ),
      (_) {},
    );
  }

  /// 9.2 저장하기 – 특정 일차 항목 순서 재배열.
  static Future<void> reorderDay(
    int chonkangId, {
    required int dayNumber,
    required List<int> itemIds,
  }) {
    return ApiResult.unwrap(
      () => ApiClient.instance.put(
        '${_base(chonkangId)}/days/$dayNumber/items/order',
        data: {'itemIds': itemIds},
      ),
      (_) {},
    );
  }

  /// 9.2.2 삭제 – 항목 삭제.
  static Future<void> deleteItem(int chonkangId, int itemId) {
    return ApiResult.unwrap(
      () => ApiClient.instance.delete('${_base(chonkangId)}/items/$itemId'),
      (_) {},
    );
  }
}
