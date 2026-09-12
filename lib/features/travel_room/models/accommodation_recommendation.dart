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

  // barbecueAvailable/cookingAvailable/petFriendly는 정보가 없으면 null(=정보없음)이라,
  // true인 것만 뱃지로 보여준다. false/null은 둘 다 뱃지를 안 보여주는 걸로 취급.
  factory AccommodationRecommendation.fromJson(Map<String, dynamic> json) {
    return AccommodationRecommendation(
      id: json['placeId'].toString(),
      rank: json['rank'] as int,
      name: json['name'] as String,
      location: json['address'] as String,
      matchRate: json['matchScore'] as int,
      imageUrl: json['thumbnailUrl'] as String?,
      moodTags: List<String>.from(json['tags'] as List? ?? const []),
      facilities: _facilitiesFromJson(json),
      matchReasons: List<String>.from(json['highlights'] as List? ?? const []),
      voters: (json['voters'] as List? ?? const [])
          .map((voter) => VoteMember.fromJson(voter as Map<String, dynamic>))
          .toList(),
    );
  }

  static List<LodgingFacility> _facilitiesFromJson(Map<String, dynamic> json) {
    final facilities = <LodgingFacility>[];
    if (json['barbecueAvailable'] == true) {
      facilities.add(LodgingFacility.bbq);
    }
    if (json['cookingAvailable'] == true) {
      facilities.add(LodgingFacility.cook);
    }
    if (json['petFriendly'] == true) {
      facilities.add(LodgingFacility.puppy);
    }
    return facilities;
  }

  factory AccommodationRecommendation.fromConfirmedJson(Map<String, dynamic> json) {
    return AccommodationRecommendation(
      id: json['placeId'].toString(),
      rank: 0,
      name: json['name'] as String,
      location: json['address'] as String,
      matchRate: 0,
      imageUrl: json['thumbnailUrl'] as String?,
      moodTags: const [],
      matchReasons: const [],
      voters: const [],
    );
  }
}
