import '../../../core/widgets/facility/facility_item.dart';

class RestaurantDetailData {
  const RestaurantDetailData({
    required this.name,
    required this.aiSummary,
    required this.shortAddress,
    required this.fullAddress,
    required this.description,
    this.imagePaths = const [],
    this.moods = const [],
    this.representativeMenu,
    this.handledMenus = const [],
    this.facilities = const [],
    this.dayOff,
    this.businessHours,
    this.parkingFee,
    this.contact,
  });

  final String name;
  final String aiSummary;

  final List<String> imagePaths;

  final String shortAddress;
  final String fullAddress;

  final List<String> moods;

  final String description;

  // 메뉴
  final String? representativeMenu;
  final List<String> handledMenus;

  // 주차 / 포장 / 신용카드
  final List<FacilityItem> facilities;

  // 이용 안내
  final String? dayOff;
  final String? businessHours;
  final String? parkingFee;

  // 문의 및 예약
  final String? contact;
}
