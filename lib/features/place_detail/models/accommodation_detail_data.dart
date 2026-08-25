import '../../../core/widgets/facility/facility_item.dart';
import 'room_info.dart';

class AccommodationDetailData {
  const AccommodationDetailData({
    required this.imagePath,
    required this.name,
    required this.aiSummary,
    required this.shortAddress,
    required this.fullAddress,
    required this.description,
    required this.moods,
    required this.petAllowed,
    required this.bbqAvailable,
    required this.cookingAvailable,
    required this.facilities,
    required this.rooms,
    this.checkInTime,
    this.checkOutTime,
    this.contact,
    this.reservationHomepage,
  });

  final String? imagePath;

  final String name;
  final String aiSummary;

  /// 화면에는 시/군까지만 노출
  final String shortAddress;

  /// 복사 버튼 클릭 시 복사되는 전체 주소
  final String fullAddress;

  final String description;
  final List<String> moods;

  /// 숙소 조건
  /// true인 항목만 화면에 노출
  final bool petAllowed;
  final bool bbqAvailable;
  final bool cookingAvailable;

  /// true: 검정
  /// false: 회색
  /// null: 항목 자체 미노출
  final List<FacilityItem> facilities;

  final List<RoomInfo> rooms;

  /// null 또는 빈 문자열이면 해당 행 미노출
  final String? checkInTime;
  final String? checkOutTime;

  final String? contact;
  final String? reservationHomepage;
}
