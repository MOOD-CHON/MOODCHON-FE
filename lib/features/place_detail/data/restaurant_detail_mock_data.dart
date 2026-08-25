import '../../../core/widgets/facility/facility_item.dart';
import '../../../core/widgets/facility/facility_type.dart';
import '../models/restaurant_detail_data.dart';

const restaurantDetailMockData = RestaurantDetailData(
  name: '시골집 쌀국수',
  aiSummary: '정겨운 분위기에서 따뜻한 한 끼를 즐기기 좋은 음식점이에요.',
  shortAddress: '충청남도 공주시',
  fullAddress: '충청남도 공주시 예시길 12',
  imagePaths: ['', '', '', ''],
  moods: ['정겨운 시골살이', '아늑한 공간'],
  description: '지역 식재료와 다양한 아시아 메뉴를 함께 즐길 수 있는 음식점이에요.',
  representativeMenu: '소고기쌀국수',
  handledMenus: ['돈가스 월남쌈', '직화구이 월남쌈', '팟타이', '나시고랭'],
  facilities: [
    FacilityItem(type: FacilityType.parking, available: true),
    FacilityItem(type: FacilityType.takeout, available: true),
    FacilityItem(type: FacilityType.card, available: true),
  ],
  dayOff: '주말 및 공휴일',
  businessHours: '10:30~21:00\n평일 준비시간 14:30~17:00\n마지막 주문 20:30',
  parkingFee: '무료',
  contact: '02-000-0000',
);
