import 'event_place_type.dart';

class EventDetailData {
  const EventDetailData({
    required this.type,
    required this.name,
    required this.aiSummary,
    required this.shortAddress,
    required this.fullAddress,
    required this.description,
    this.imagePaths = const [],
    this.moods = const [],
    this.programs = const [],
    this.eventPeriod,
    this.performanceTime,
    this.fee,
    this.ageLimit,
    this.eventPlace,
    this.organizer,
    this.organizerContact,
    this.homepage,
  });

  final EventPlaceType type;

  final String name;
  final String aiSummary;

  final List<String> imagePaths;

  final String shortAddress;
  final String fullAddress;

  final List<String> moods;

  final String description;

  // 프로그램
  final List<String> programs;

  // 이용 안내
  final String? eventPeriod;
  final String? performanceTime;
  final String? fee;
  final String? ageLimit;
  final String? eventPlace;

  // 문의 및 예약
  final String? organizer;
  final String? organizerContact;
  final String? homepage;
}
