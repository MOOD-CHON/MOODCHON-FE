class ChonkangTripInfo {
  const ChonkangTripInfo({
    required this.plannedMemberCount,
    required this.currentMemberCount,
    this.companionType,
    this.travelMethod,
    this.desiredRegion,
  });

  final int plannedMemberCount;
  final int currentMemberCount;

  // 동행인 정보/이동 방식/희망 지역은 촌캉스 만들기에서 필수 선택이 아니라 null일 수 있다.
  final String? companionType;
  final String? travelMethod;
  final String? desiredRegion;

  factory ChonkangTripInfo.fromJson(Map<String, dynamic> json) {
    return ChonkangTripInfo(
      plannedMemberCount: json['plannedMemberCount'] as int,
      currentMemberCount: (json['currentMemberCount'] as num).toInt(),
      companionType: json['companionType'] as String?,
      travelMethod: json['travelMethod'] as String?,
      desiredRegion: json['desiredRegion'] as String?,
    );
  }
}
