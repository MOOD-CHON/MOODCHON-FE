import '../../../core/widgets/facility/facility_item.dart';
import '../../../core/widgets/facility/facility_type.dart';
import '../models/accommodation_detail_data.dart';
import '../models/room_info.dart';

const accommodationDetailMockData = AccommodationDetailData(
  imagePath: null,
  name: '글램핑로망',
  aiSummary: '자연 속에서 여유롭게 쉬며 감성적인 하루를 보내기 좋은 숙소예요.',
  shortAddress: '대구광역시 달성군',
  fullAddress: '대구광역시 달성군 옥포읍 예시로 123',
  description:
      '넓은 마당과 자연이 어우러진 공간에서 조용히 머물 수 있는 숙소예요. '
      '여유로운 휴식과 함께 바비큐를 즐기기에도 좋아요.',
  moods: ['고즈넉한', '조용한', '자연스러운'],
  petAllowed: true,
  bbqAvailable: true,
  cookingAvailable: true,
  facilities: [
    FacilityItem(type: FacilityType.bike, available: true),
    FacilityItem(type: FacilityType.sauna, available: false),
    FacilityItem(type: FacilityType.sports, available: true),
    FacilityItem(type: FacilityType.fire, available: null),
  ],
  rooms: [
    RoomInfo(
      name: '스탠다드 객실',
      roomCount: 2,
      standardCapacity: 8,
      maximumCapacity: 10,
      offSeasonWeekdayPrice: '97,100원~',
      offSeasonWeekendPrice: '105,200원~',
      peakSeasonWeekdayPrice: '121,400원~',
      peakSeasonWeekendPrice: '129,500원~',
      facilities: ['에어컨', 'TV', '인터넷', '냉장고', '테이블', '드라이기'],
    ),
    RoomInfo(
      name: '디럭스 객실',
      roomCount: 1,
      standardCapacity: 4,
      maximumCapacity: 6,
      offSeasonWeekdayPrice: '110,000원~',
      offSeasonWeekendPrice: '130,000원~',
      facilities: [
        '에어컨',
        'TV',
        '쇼파',
        '인터넷',
        '냉장고',
        '테이블',
        '드라이기',
        '목욕시설',
        '세면도구',
      ],
    ),
    RoomInfo(
      name: '독채 객실',
      standardCapacity: 4,
      maximumCapacity: 8,
      peakSeasonWeekendPrice: '180,000원~',
      facilities: [
        '에어컨',
        'TV',
        'PC',
        '쇼파',
        '케이블설치',
        '인터넷',
        '냉장고',
        '테이블',
        '드라이기',
        '목욕시설',
        '세면도구',
        '취사용품',
      ],
    ),
  ],
  checkInTime: '15:00',
  checkOutTime: '11:00',
  contact: '02-000-0000',
  reservationHomepage: 'https://example.com',
);
