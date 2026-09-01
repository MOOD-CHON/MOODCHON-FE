import 'accommodation_recommendation.dart';

class MoodAccommodationPageData {
  const MoodAccommodationPageData({
    required this.moodName,
    required this.moodTags,
    required this.travelInfo,
    required this.topAccommodations,
    required this.similarAccommodations,
  });

  final String moodName;

  /// 항상 상위 4개
  final List<String> moodTags;

  /// 미입력 정보는 제외
  final List<String> travelInfo;

  /// 1~5위
  final List<AccommodationRecommendation> topAccommodations;

  /// 6위 이후
  final List<AccommodationRecommendation> similarAccommodations;
}
