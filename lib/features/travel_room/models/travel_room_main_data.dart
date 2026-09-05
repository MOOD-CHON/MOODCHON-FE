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
