import 'facility_type.dart';

class FacilityItem {
  const FacilityItem({required this.type, required this.available});

  final FacilityType type;

  /// true: 가능/있음
  /// false: 불가능/없음
  /// null: 정보 없음
  final bool? available;
}
