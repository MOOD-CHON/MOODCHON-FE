import 'accommodation_condition.dart';
import 'companion_type.dart';
import 'desired_region.dart';
import 'travel_method.dart';

class ChonkangTripInfo {
  const ChonkangTripInfo({
    required this.chonkangId,
    required this.name,
    required this.startDate,
    required this.endDate,
    required this.plannedMemberCount,
    required this.companionType,
    required this.travelMethod,
    required this.desiredRegion,
    required this.accommodationConditions,
    required this.currentMemberCount,
    required this.moodDecided,
  });

  factory ChonkangTripInfo.fromJson(Map<String, dynamic> json) {
    return ChonkangTripInfo(
      chonkangId: json['chonkangId'] as int,
      name: json['name'] as String,
      startDate: DateTime.parse(json['startDate'] as String),
      endDate: DateTime.parse(json['endDate'] as String),
      plannedMemberCount: json['plannedMemberCount'] as int,
      companionType: CompanionTypeApi.fromApiValue(
        json['companionType'] as String,
      ),
      travelMethod: TravelMethodApi.fromApiValue(
        json['travelMethod'] as String,
      ),
      desiredRegion: DesiredRegionApi.fromApiValue(
        json['desiredRegion'] as String,
      ),
      accommodationConditions: (json['accommodationConditions'] as List?)
              ?.map(
                (value) =>
                    AccommodationConditionApi.fromApiValue(value as String),
              )
              .toSet() ??
          const {},
      currentMemberCount: json['currentMemberCount'] as int,
      moodDecided: json['moodDecided'] as bool,
    );
  }

  final int chonkangId;
  final String name;
  final DateTime startDate;
  final DateTime endDate;
  final int plannedMemberCount;
  final CompanionType companionType;
  final TravelMethod travelMethod;
  final DesiredRegion desiredRegion;
  final Set<AccommodationCondition> accommodationConditions;
  final int currentMemberCount;
  final bool moodDecided;

  bool get isFull => currentMemberCount >= plannedMemberCount;

  ChonkangTripInfo copyWith({
    String? name,
    DateTime? startDate,
    DateTime? endDate,
    int? plannedMemberCount,
    CompanionType? companionType,
    TravelMethod? travelMethod,
    DesiredRegion? desiredRegion,
    Set<AccommodationCondition>? accommodationConditions,
  }) {
    return ChonkangTripInfo(
      chonkangId: chonkangId,
      name: name ?? this.name,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      plannedMemberCount: plannedMemberCount ?? this.plannedMemberCount,
      companionType: companionType ?? this.companionType,
      travelMethod: travelMethod ?? this.travelMethod,
      desiredRegion: desiredRegion ?? this.desiredRegion,
      accommodationConditions:
          accommodationConditions ?? this.accommodationConditions,
      currentMemberCount: currentMemberCount,
      moodDecided: moodDecided,
    );
  }
}
