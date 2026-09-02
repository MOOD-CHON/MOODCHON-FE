import '../../place_detail/models/accommodation_detail_data.dart';
import 'vote_member.dart';

class TravelAccommodationDetailData {
  const TravelAccommodationDetailData({
    required this.accommodation,
    required this.matchRate,
    required this.matchReasons,
    required this.regretReasons,
    this.recommendationRank,
    this.voters = const [],
  });

  final AccommodationDetailData accommodation;

  /// 모든 숙소에 표시
  final int matchRate;

  /// 1~5위 숙소에만 값이 존재.
  /// 6위 이후 / 검색 결과 등은 null.
  final int? recommendationRank;

  final List<VoteMember> voters;

  final List<String> matchReasons;
  final List<String> regretReasons;
}
