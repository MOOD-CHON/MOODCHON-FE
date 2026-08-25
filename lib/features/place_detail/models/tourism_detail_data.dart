import '../../../core/widgets/facility/facility_item.dart';
import 'tourism_place_type.dart';

class TourismDetailData {
  const TourismDetailData({
    required this.type,
    required this.name,
    required this.aiSummary,
    required this.shortAddress,
    required this.fullAddress,
    required this.description,
    this.imagePaths = const [],
    this.moods = const [],
    this.experienceAge,
    this.experienceGuide,
    this.facilities = const [],
    this.dayOff,
    this.admissionFee,
    this.openPeriod,
    this.useTime,
    this.capacity,
    this.parkingFee,
    this.contact,
    this.reservationInfo,
    this.homepage,
  });

  final TourismPlaceType type;

  final String name;
  final String aiSummary;

  final List<String> imagePaths;

  final String shortAddress;
  final String fullAddress;

  final List<String> moods;

  final String description;

  final String? experienceAge;
  final String? experienceGuide;

  final List<FacilityItem> facilities;

  final String? dayOff;
  final String? admissionFee;
  final String? openPeriod;
  final String? useTime;
  final String? capacity;
  final String? parkingFee;

  final String? contact;
  final String? reservationInfo;
  final String? homepage;
}
