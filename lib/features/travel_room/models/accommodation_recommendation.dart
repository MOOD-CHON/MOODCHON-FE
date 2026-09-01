import 'vote_member.dart';

enum LodgingFacility { puppy, bbq, cook }

class AccommodationRecommendation {
  const AccommodationRecommendation({
    required this.id,
    required this.rank,
    required this.name,
    required this.location,
    required this.matchRate,
    required this.moodTags,
    required this.matchReasons,
    required this.voters,
    this.imageUrl,
    this.facilities = const [],
  });

  final String id;
  final int rank;

  final String name;
  final String location;

  final int matchRate;

  final String? imageUrl;

  final List<String> moodTags;
  final List<LodgingFacility> facilities;
  final List<String> matchReasons;

  final List<VoteMember> voters;
}
