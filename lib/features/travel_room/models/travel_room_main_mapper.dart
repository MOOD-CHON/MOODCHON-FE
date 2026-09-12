import '../../chonkang_join/models/chonkang_trip_info.dart';
import '../utils/travel_date_formatter.dart';
import 'accommodation_recommendation.dart';
import 'recommended_itinerary.dart';
import 'recommended_itinerary_mapper.dart';
import 'travel_date_type.dart';
import 'travel_room_main_data.dart';
import 'travel_room_member.dart';
import 'travel_room_stage.dart';
import 'vote_member.dart';

/// `GET /api/chonkangs/{chonkangId}/main` 응답과, 방 이름/날짜를 담고 있는
/// [tripInfo]를 합쳐 여행방 메인 화면에 필요한 데이터를 만듭니다.
TravelRoomMainData mapChonkangMainResponse(
  Map<String, dynamic> json,
  ChonkangTripInfo tripInfo,
) {
  final moodProgress = json['moodProgress'] as Map<String, dynamic>?;
  final moodResult = json['moodResult'] as Map<String, dynamic>?;
  final itineraryJson = json['itinerary'] as Map<String, dynamic>?;
  final itinerary = itineraryJson != null
      ? RecommendedItinerary.fromJson(itineraryJson)
      : null;
  final confirmedAccommodationJson =
      json['confirmedAccommodation'] as Map<String, dynamic>?;

  return TravelRoomMainData(
    chonkangId: tripInfo.chonkangId,
    roomName: tripInfo.name,
    travelDateType: TravelDateType.date,
    travelDateText: TravelDateFormatter.format(
      type: TravelDateType.date,
      startDate: tripInfo.startDate.toIso8601String(),
      endDate: tripInfo.endDate.toIso8601String(),
    ),
    stage: _parseStage(json['status'] as String?, itinerary),
    members: (moodProgress?['members'] as List? ?? const [])
        .map((member) => _memberFromJson(member as Map<String, dynamic>))
        .toList(),
    moodName: moodResult?['name'] as String? ?? '',
    moodDescription: moodResult?['description'] as String? ?? '',
    accommodations: (json['recommendedAccommodations'] as List? ?? const [])
        .map(
          (accommodation) =>
              _accommodationFromJson(accommodation as Map<String, dynamic>),
        )
        .toList(),
    confirmedAccommodation: confirmedAccommodationJson != null
        ? _confirmedAccommodationFromJson(confirmedAccommodationJson)
        : null,
    dayPlans:
        itinerary?.days.map((day) => day.toDayPlan()).toList() ?? const [],
  );
}

TravelRoomStage _parseStage(String? status, RecommendedItinerary? itinerary) {
  switch (status) {
    case 'MOOD_VOTING':
      return TravelRoomStage.moodSelecting;
    case 'ACCOMMODATION_CONFIRMED':
      return itinerary?.committed == true
          ? TravelRoomStage.itineraryConfirmed
          : TravelRoomStage.itineraryRecommendation;
    case 'MOOD_DECIDED':
    default:
      return TravelRoomStage.accommodationRecommendation;
  }
}

TravelRoomMember _memberFromJson(Map<String, dynamic> json) {
  return TravelRoomMember(
    id: (json['userId'] as int).toString(),
    name: json['nickname'] as String? ?? '',
    moodCompleted: json['moodSelected'] as bool? ?? false,
  );
}

const Map<String, LodgingFacility> _facilityByTag = {
  'PET_FRIENDLY': LodgingFacility.puppy,
  'BARBECUE': LodgingFacility.bbq,
  'COOKING': LodgingFacility.cook,
};

AccommodationRecommendation _accommodationFromJson(Map<String, dynamic> json) {
  final tags = (json['tags'] as List? ?? const [])
      .map((tag) => tag as String)
      .toList();

  return AccommodationRecommendation(
    id: (json['placeId'] as int).toString(),
    rank: json['rank'] as int? ?? 0,
    name: json['name'] as String? ?? '',
    location: json['address'] as String? ?? '',
    matchRate: json['matchScore'] as int? ?? 0,
    imageUrl: json['thumbnailUrl'] as String?,
    moodTags: tags,
    facilities: tags
        .map((tag) => _facilityByTag[tag])
        .whereType<LodgingFacility>()
        .toList(),
    matchReasons: (json['highlights'] as List? ?? const [])
        .map((highlight) => highlight as String)
        .toList(),
    // 투표자 목록은 이 응답에 없고, 숙소 상세(voters API)에서만 조회할 수 있어요.
    voters: const <VoteMember>[],
  );
}

AccommodationRecommendation _confirmedAccommodationFromJson(
  Map<String, dynamic> json,
) {
  return AccommodationRecommendation(
    id: (json['placeId'] as int).toString(),
    rank: 1,
    name: json['name'] as String? ?? '',
    location: json['address'] as String? ?? '',
    matchRate: 0,
    imageUrl: json['thumbnailUrl'] as String?,
    moodTags: const [],
    facilities: const [],
    matchReasons: const [],
    voters: const <VoteMember>[],
  );
}
