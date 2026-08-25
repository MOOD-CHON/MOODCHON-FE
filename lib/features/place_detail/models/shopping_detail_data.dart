import '../../../core/widgets/facility/facility_item.dart';

class ShoppingDetailData {
  const ShoppingDetailData({
    required this.name,
    required this.aiSummary,
    required this.shortAddress,
    required this.fullAddress,
    required this.description,
    this.imagePaths = const [],
    this.moods = const [],
    this.salesItem,
    this.facilities = const [],
    this.dayOff,
    this.businessHours,
    this.parkingFee,
    this.contact,
    this.homepage,
  });

  final String name;
  final String aiSummary;

  final List<String> imagePaths;

  final String shortAddress;
  final String fullAddress;

  final List<String> moods;

  final String description;

  // 판매 품목
  final String? salesItem;

  // 주차 / 화장실 / 유모차 / 신용카드 / 반려동물
  final List<FacilityItem> facilities;

  // 이용 안내
  final String? dayOff;
  final String? businessHours;
  final String? parkingFee;

  // 문의 및 예약
  final String? contact;
  final String? homepage;
}
