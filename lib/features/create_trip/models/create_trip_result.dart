class CreateTripResult {
  const CreateTripResult({
    required this.chonkangId,
    required this.inviteCode,
    required this.plannedMemberCount,
  });

  final int chonkangId;
  final String inviteCode;
  final int plannedMemberCount;

  factory CreateTripResult.fromJson(Map<String, dynamic> json) {
    return CreateTripResult(
      chonkangId: json['chonkangId'] as int,
      inviteCode: json['inviteCode'] as String,
      plannedMemberCount: json['plannedMemberCount'] as int,
    );
  }
}
