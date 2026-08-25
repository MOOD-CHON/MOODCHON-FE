import '../../../core/widgets/facility/facility_item.dart';
import '../../../core/widgets/facility/facility_type.dart';
import '../models/shopping_detail_data.dart';

const shoppingDetailMockData = ShoppingDetailData(
  name: '시골 장터 상점',
  aiSummary: '지역의 정겨운 분위기를 느끼며 다양한 특산품을 구경하기 좋은 곳이에요.',
  shortAddress: '전라남도 담양군',
  fullAddress: '전라남도 담양군 예시길 40',
  imagePaths: ['', '', '', ''],
  moods: ['정겨운 시골살이', '빈티지 기록'],
  description: '지역에서 생산한 농산물과 수공예품, 기념품 등을 만나볼 수 있는 쇼핑 공간이에요.',
  salesItem: '지역 농산물, 수공예품, 생활용품, 기념품',
  facilities: [
    FacilityItem(type: FacilityType.parking, available: true),
    FacilityItem(type: FacilityType.toilet, available: true),
    FacilityItem(type: FacilityType.stroller, available: false),
    FacilityItem(type: FacilityType.card, available: true),
    FacilityItem(type: FacilityType.puppy, available: false),
  ],
  dayOff: '매주 월요일',
  businessHours: '10:00~19:00',
  parkingFee: '무료',
  contact: '061-000-0000',
  homepage: 'https://example.com',
);
