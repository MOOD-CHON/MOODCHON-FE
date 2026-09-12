import '../utils/travel_date_formatter.dart';
import 'accommodation_recommendation.dart';
import 'travel_date_type.dart';
import 'travel_room_day_plan.dart';
import 'travel_room_member.dart';
import 'travel_room_stage.dart';

class TravelRoomMainData {
  const TravelRoomMainData({
    required this.roomName,
    required this.travelDateType,
    required this.travelDateText,
    required this.stage,
    required this.members,
    required this.moodName,
    required this.moodDescription,
    required this.accommodations,
    this.confirmedAccommodation,
    this.dayPlans = const [],
  }) : assert(travelDateText != '');

  final String roomName;

  final TravelDateType travelDateType;
  final String travelDateText;

  final TravelRoomStage stage;

  final List<TravelRoomMember> members;

  final String moodName;
  final String moodDescription;

  final List<AccommodationRecommendation> accommodations;

  final AccommodationRecommendation? confirmedAccommodation;

  final List<TravelRoomDayPlan> dayPlans;

  int get completedMemberCount {
    return members.where((member) => member.moodCompleted).length;
  }

  // GET /api/chonkangs/{chonkangId}/main 응답 매핑. 촌캉스 날짜는 항상 확정된 날짜라
  // travelDateType은 항상 date. status=ACCOMMODATION_CONFIRMED일 때 itinerary가 있으면
  // (추천 일정을 담아서 확정한 경우) 6.3.2, 없으면 6.3.1로 본다.
  factory TravelRoomMainData.fromJson(Map<String, dynamic> json) {
    final status = json['status'] as String;
    final moodProgress = json['moodProgress'] as Map<String, dynamic>?;
    final moodResult = json['moodResult'] as Map<String, dynamic>?;
    final recommendedAccommodations = json['recommendedAccommodations'] as List?;
    final confirmedAccommodation = json['confirmedAccommodation'] as Map<String, dynamic>?;
    final itinerary = json['itinerary'] as Map<String, dynamic>?;

    return TravelRoomMainData(
      roomName: json['name'] as String,
      travelDateType: TravelDateType.date,
      travelDateText: TravelDateFormatter.format(
        type: TravelDateType.date,
        startDate: json['startDate'] as String,
        endDate: json['endDate'] as String,
      ),
      stage: _resolveStage(status, itinerary != null),
      members: moodProgress == null
          ? const []
          : (moodProgress['members'] as List)
                .map((member) => TravelRoomMember.fromJson(member as Map<String, dynamic>))
                .toList(),
      moodName: moodResult?['name'] as String? ?? '',
      moodDescription: moodResult?['description'] as String? ?? '',
      accommodations: recommendedAccommodations == null
          ? const []
          : recommendedAccommodations
                .map((item) => AccommodationRecommendation.fromJson(item as Map<String, dynamic>))
                .toList(),
      confirmedAccommodation: confirmedAccommodation == null
          ? null
          : AccommodationRecommendation.fromConfirmedJson(confirmedAccommodation),
      dayPlans: itinerary == null
          ? const []
          : (itinerary['days'] as List)
                .map((day) => TravelRoomDayPlan.fromJson(day as Map<String, dynamic>))
                .toList(),
    );
  }

  static TravelRoomStage _resolveStage(String status, bool hasItinerary) {
    switch (status) {
      case 'MOOD_DECIDED':
        return TravelRoomStage.accommodationRecommendation;
      case 'ACCOMMODATION_CONFIRMED':
        return hasItinerary ? TravelRoomStage.itineraryConfirmed : TravelRoomStage.itineraryRecommendation;
      case 'MOOD_VOTING':
      default:
        return TravelRoomStage.moodSelecting;
    }
  }

  TravelRoomMainData copyWith({
    String? roomName,
    TravelDateType? travelDateType,
    String? travelDateText,
    TravelRoomStage? stage,
    List<TravelRoomMember>? members,
    String? moodName,
    String? moodDescription,
    List<AccommodationRecommendation>? accommodations,
    AccommodationRecommendation? confirmedAccommodation,
    bool clearConfirmedAccommodation = false,
    List<TravelRoomDayPlan>? dayPlans,
  }) {
    return TravelRoomMainData(
      roomName: roomName ?? this.roomName,
      travelDateType: travelDateType ?? this.travelDateType,
      travelDateText: travelDateText ?? this.travelDateText,
      stage: stage ?? this.stage,
      members: members ?? this.members,
      moodName: moodName ?? this.moodName,
      moodDescription: moodDescription ?? this.moodDescription,
      accommodations: accommodations ?? this.accommodations,
      confirmedAccommodation: clearConfirmedAccommodation
          ? null
          : confirmedAccommodation ?? this.confirmedAccommodation,
      dayPlans: dayPlans ?? this.dayPlans,
    );
  }
}
