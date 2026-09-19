import '../../../core/widgets/facility/facility_item.dart';
import '../../../core/widgets/facility/facility_type.dart';
import '../../place_detail/models/accommodation_detail_data.dart';
import '../../place_detail/models/room_info.dart';
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
    this.description = '',
    this.regretReasons = const [],
    this.petFriendly,
    this.bbqAvailable,
    this.cookingAvailable,
    this.bicycleAvailable,
    this.campfireAvailable,
    this.parkingAvailable,
    this.saunaAvailable,
    this.sportsAvailable,
    this.checkInTime,
    this.checkOutTime,
    this.contact,
    this.reservationUrl,
    this.rooms = const [],
    this.votedByMe = false,
    this.voteCount = 0,
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

  /// 아래는 상세 화면에서 쓰는 값들. 목록 응답에 이미 모두 들어 있다.
  final String description;
  final List<String> regretReasons;

  /// 편의시설은 true/false/null(=정보없음) 세 가지 상태를 그대로 유지한다.
  /// null이면 화면에 항목 자체를 노출하지 않는다.
  final bool? petFriendly;
  final bool? bbqAvailable;
  final bool? cookingAvailable;
  final bool? bicycleAvailable;
  final bool? campfireAvailable;
  final bool? parkingAvailable;
  final bool? saunaAvailable;
  final bool? sportsAvailable;

  final String? checkInTime;
  final String? checkOutTime;
  final String? contact;
  final String? reservationUrl;

  final List<RoomInfo> rooms;

  final bool votedByMe;
  final int voteCount;

  // barbecueAvailable/cookingAvailable/petFriendly는 정보가 없으면 null(=정보없음)이라,
  // true인 것만 뱃지로 보여준다. false/null은 둘 다 뱃지를 안 보여주는 걸로 취급.
  factory AccommodationRecommendation.fromJson(Map<String, dynamic> json) {
    return AccommodationRecommendation(
      id: json['placeId'].toString(),
      // 확정 숙소 응답에서는 추천을 거치지 않았으면 null 로 온다.
      rank: json['rank'] as int? ?? 0,
      name: json['name'] as String,
      location: json['address'] as String,
      matchRate: json['matchScore'] as int? ?? 0,
      imageUrl: json['thumbnailUrl'] as String?,
      moodTags: List<String>.from(json['tags'] as List? ?? const []),
      facilities: _facilitiesFromJson(json),
      matchReasons: List<String>.from(json['highlights'] as List? ?? const []),
      voters: (json['voters'] as List? ?? const [])
          .map((voter) => VoteMember.fromJson(voter as Map<String, dynamic>))
          .toList(),
      description: json['description'] as String? ?? '',
      regretReasons: List<String>.from(json['regrets'] as List? ?? const []),
      petFriendly: json['petFriendly'] as bool?,
      bbqAvailable: json['barbecueAvailable'] as bool?,
      cookingAvailable: json['cookingAvailable'] as bool?,
      bicycleAvailable: json['bicycleAvailable'] as bool?,
      campfireAvailable: json['campfireAvailable'] as bool?,
      parkingAvailable: json['parkingAvailable'] as bool?,
      saunaAvailable: json['saunaAvailable'] as bool?,
      sportsAvailable: json['sportsAvailable'] as bool?,
      checkInTime: json['checkInTime'] as String?,
      checkOutTime: json['checkOutTime'] as String?,
      contact: json['contact'] as String?,
      reservationUrl: json['reservationUrl'] as String?,
      rooms: (json['rooms'] as List? ?? const [])
          .map((room) => _roomFromJson(room as Map<String, dynamic>))
          .toList(),
      votedByMe: json['votedByMe'] as bool? ?? false,
      voteCount: json['voteCount'] as int? ?? 0,
    );
  }

  /// 상세 화면이 쓰는 모델로 변환. 목록 응답에 상세에 필요한 값이 모두 들어 있어
  /// 별도 상세 API를 다시 호출하지 않는다.
  AccommodationDetailData toDetailData() {
    return AccommodationDetailData(
      imagePath: imageUrl,
      name: name,
      aiSummary: matchReasons.isEmpty ? '' : matchReasons.first,
      shortAddress: _shortAddress(location),
      fullAddress: location,
      description: description,
      moods: moodTags,
      petAllowed: petFriendly == true,
      bbqAvailable: bbqAvailable == true,
      cookingAvailable: cookingAvailable == true,
      facilities: [
        FacilityItem(type: FacilityType.parking, available: parkingAvailable),
        FacilityItem(type: FacilityType.bike, available: bicycleAvailable),
        FacilityItem(type: FacilityType.fire, available: campfireAvailable),
        FacilityItem(type: FacilityType.sauna, available: saunaAvailable),
        FacilityItem(type: FacilityType.sports, available: sportsAvailable),
      ],
      rooms: rooms,
      checkInTime: checkInTime,
      checkOutTime: checkOutTime,
      contact: contact,
      reservationHomepage: reservationUrl,
    );
  }

  static RoomInfo _roomFromJson(Map<String, dynamic> json) {
    return RoomInfo(
      name: json['name'] as String,
      imagePath: json['imageUrl'] as String?,
      roomCount: json['roomCount'] as int?,
      standardCapacity: json['baseCount'] as int?,
      maximumCapacity: json['maxCount'] as int?,
      offSeasonWeekdayPrice: _formatFee(json['offSeasonWeekdayFee'] as int?),
      offSeasonWeekendPrice: _formatFee(json['offSeasonWeekendFee'] as int?),
      peakSeasonWeekdayPrice: _formatFee(json['peakSeasonWeekdayFee'] as int?),
      peakSeasonWeekendPrice: _formatFee(json['peakSeasonWeekendFee'] as int?),
      facilities: List<String>.from(json['facilities'] as List? ?? const []),
    );
  }

  /// 서버는 원 단위 정수를 주고 표기는 클라이언트가 만든다. 150000 -> "150,000원~"
  static String? _formatFee(int? fee) {
    if (fee == null || fee <= 0) {
      return null;
    }

    final digits = fee.toString();
    final buffer = StringBuffer();
    for (var i = 0; i < digits.length; i++) {
      if (i > 0 && (digits.length - i) % 3 == 0) {
        buffer.write(',');
      }
      buffer.write(digits[i]);
    }
    return '${buffer}원~';
  }

  /// 화면에는 "제주특별자치도 서귀포시"처럼 시/군까지만 노출한다.
  static String _shortAddress(String fullAddress) {
    final tokens = fullAddress.trim().split(RegExp(r'\s+'));
    if (tokens.length <= 2) {
      return fullAddress.trim();
    }
    return tokens.take(2).join(' ');
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
      moodTags: List<String>.from(json['tags'] as List? ?? const []),
      matchReasons: List<String>.from(json['highlights'] as List? ?? const []),
      voters: const [],
    );
  }
}
