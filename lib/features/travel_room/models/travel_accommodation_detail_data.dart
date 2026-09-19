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
    this.chonkangId,
    this.placeId,
    this.votedByMe = false,
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

  /// 투표·확정 API 호출에 필요한 식별자. 목 데이터로 띄울 때는 null이라
  /// 버튼을 눌러도 서버 호출 없이 화면 상태만 바뀐다.
  final int? chonkangId;
  final int? placeId;

  final bool votedByMe;
}
