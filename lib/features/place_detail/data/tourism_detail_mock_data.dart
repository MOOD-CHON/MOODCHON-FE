import '../../../core/widgets/facility/facility_item.dart';
import '../../../core/widgets/facility/facility_type.dart';
import '../models/tourism_detail_data.dart';
import '../models/tourism_place_type.dart';

const attractionDetailMockData = TourismDetailData(
  type: TourismPlaceType.attraction,
  name: '고즈넉한 관광지',
  aiSummary: '천천히 걸으며 조용한 풍경을 즐기기 좋은 장소예요.',
  shortAddress: '강원특별자치도 평창군',
  fullAddress: '강원특별자치도 평창군 예시로 123',
  imagePaths: ['', '', '', ''],
  moods: ['고즈넉한 감성', '조용한 휴식'],
  description:
      '자연과 전통적인 풍경을 함께 즐길 수 있는 관광지예요. '
      '천천히 둘러보며 여유로운 시간을 보내기 좋아요.',
  experienceAge: '만 7세 이상',
  experienceGuide: '현장에서 전통문화 체험 프로그램을 운영합니다.',
  facilities: [
    FacilityItem(type: FacilityType.parking, available: true),
    FacilityItem(type: FacilityType.toilet, available: true),
    FacilityItem(type: FacilityType.stroller, available: false),
    FacilityItem(type: FacilityType.card, available: true),
    FacilityItem(type: FacilityType.puppy, available: null),
  ],
  dayOff: '매주 월요일',
  admissionFee: '무료',
  openPeriod: '연중',
  useTime: '09:00 - 18:00',
  capacity: '500명',
  parkingFee: '무료',
  contact: '033-000-0000',
  reservationInfo: '별도 예약 없이 이용 가능',
  homepage: 'https://example.com',
);

const culturalFacilityDetailMockData = TourismDetailData(
  type: TourismPlaceType.culturalFacility,
  name: '지역 문화 공간',
  aiSummary: '지역의 이야기와 문화를 차분하게 만나볼 수 있는 공간이에요.',
  shortAddress: '전라남도 담양군',
  fullAddress: '전라남도 담양군 예시길 20',
  imagePaths: ['', '', ''],
  moods: ['빈티지 감성'],
  description: '지역의 역사와 문화를 전시와 체험을 통해 알아볼 수 있는 문화시설입니다.',
  experienceAge: '전 연령',
  experienceGuide: '일부 프로그램은 현장 접수 후 참여할 수 있습니다.',
  facilities: [
    FacilityItem(type: FacilityType.parking, available: true),
    FacilityItem(type: FacilityType.toilet, available: true),
    FacilityItem(type: FacilityType.stroller, available: true),
    FacilityItem(type: FacilityType.card, available: false),
    FacilityItem(type: FacilityType.puppy, available: false),
  ],
  dayOff: '매주 화요일',
  admissionFee: '5,000원',
  useTime: '10:00 - 17:00',
  contact: '061-000-0000',
  homepage: 'https://example.com',
);

const leisureSportsDetailMockData = TourismDetailData(
  type: TourismPlaceType.leisureSports,
  name: '자연 속 레포츠 체험장',
  aiSummary: '자연 속에서 몸을 움직이며 활기찬 시간을 보내기 좋은 곳이에요.',
  shortAddress: '경기도 가평군',
  fullAddress: '경기도 가평군 예시로 30',
  imagePaths: ['', '', '', ''],
  moods: ['활기있는 분위기'],
  description: '자연환경을 활용한 다양한 레포츠 프로그램을 체험할 수 있는 공간입니다.',
  experienceAge: '만 10세 이상',
  experienceGuide: '안전 장비 착용 후 전문 안내자와 함께 체험합니다.',
  facilities: [
    FacilityItem(type: FacilityType.parking, available: true),
    FacilityItem(type: FacilityType.toilet, available: true),
    FacilityItem(type: FacilityType.stroller, available: null),
    FacilityItem(type: FacilityType.card, available: true),
    FacilityItem(type: FacilityType.puppy, available: false),
  ],
  dayOff: '우천 시 휴무',
  admissionFee: '30,000원부터',
  openPeriod: '3월 - 11월',
  useTime: '09:00 - 17:00',
  capacity: '회차별 20명',
  parkingFee: '무료',
  contact: '031-000-0000',
  reservationInfo: '사전 예약 권장',
  homepage: 'https://example.com',
);
