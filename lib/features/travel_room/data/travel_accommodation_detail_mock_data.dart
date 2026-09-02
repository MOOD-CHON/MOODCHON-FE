import '../../place_detail/data/accommodation_detail_mock_data.dart';
import '../models/travel_accommodation_detail_data.dart';
import '../models/vote_member.dart';

const TravelAccommodationDetailData travelAccommodationDetailMockData =
    TravelAccommodationDetailData(
      accommodation: accommodationDetailMockData,
      matchRate: 94,
      recommendationRank: 1,
      voters: [
        VoteMember(id: '1', nickname: '보리'),
        VoteMember(id: '2', nickname: '무디'),
        VoteMember(id: '3', nickname: '촌이'),
        VoteMember(id: '4', nickname: '여름'),
      ],
      matchReasons: [
        '마당과 한옥의 차분한 분위기가 공동 무드와 잘 맞아요.',
        '주변에 산책하기 좋은 마을길이 있어요.',
        '4명이 함께 머물기 좋은 독채 숙소예요.',
      ],
      regretReasons: [
        '야외 활동의 차분한 분위기가 공통 무드와 잘 맞아요.',
        '주변에 산책하기 좋은 마을길이 있어요.',
        '4명이 함께 머물기 좋은 독채 숙소예요.',
      ],
    );
