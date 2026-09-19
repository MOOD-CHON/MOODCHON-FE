class JoinChonkangResult {
  const JoinChonkangResult({
    required this.chonkangId,
    required this.moodDecided,
    required this.isLastParticipant,
    required this.plannedMemberCount,
    required this.currentMemberCount,
    required this.hasRecommendedItinerary,
    required this.itineraryCommitted,
  });

  factory JoinChonkangResult.fromJson(Map<String, dynamic> json) {
    return JoinChonkangResult(
      chonkangId: json['chonkangId'] as int,
      moodDecided: json['moodDecided'] as bool,
      isLastParticipant: json['isLastParticipant'] as bool,
      plannedMemberCount: json['plannedMemberCount'] as int,
      currentMemberCount: json['currentMemberCount'] as int,
      hasRecommendedItinerary: json['hasRecommendedItinerary'] as bool,
      itineraryCommitted: json['itineraryCommitted'] as bool,
    );
  }

  final int chonkangId;
  final bool moodDecided;
  final bool isLastParticipant;
  final int plannedMemberCount;
  final int currentMemberCount;
  final bool hasRecommendedItinerary;
  final bool itineraryCommitted;
}
