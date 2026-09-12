import 'mood_vote_result.dart';

class MoodResultDetail {
  const MoodResultDetail({
    required this.name,
    required this.description,
    required this.collageImageUrls,
    required this.tagBreakdown,
    required this.summary,
  });

  final String name;
  final String description;
  final List<String> collageImageUrls;
  final List<MoodVoteResult> tagBreakdown;
  final String summary;

  factory MoodResultDetail.fromJson(Map<String, dynamic> json) {
    return MoodResultDetail(
      name: json['name'] as String,
      description: json['description'] as String,
      collageImageUrls: List<String>.from(json['collageImageUrls'] as List),
      tagBreakdown: (json['tagBreakdown'] as List)
          .map(
            (tag) => MoodVoteResult(
              tag: tag['tagName'] as String,
              voteCount: tag['count'] as int,
            ),
          )
          .toList(),
      summary: json['summary'] as String,
    );
  }
}
