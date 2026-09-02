import 'mood_vote_result.dart';

class MoodResult {
  const MoodResult({
    required this.moodName,
    required this.description,
    required this.imageUrls,
    required this.memberCount,
    required this.voteResults,
    required this.reason,
  });

  final String moodName;
  final String description;

  /// 최대 4장의 무드 이미지
  final List<String> imageUrls;

  /// 여행방 전체 구성원 수 (1~6명)
  final int memberCount;

  final List<MoodVoteResult> voteResults;

  final String reason;
}
