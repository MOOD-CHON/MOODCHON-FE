import '../models/accommodation_recommendation.dart';
import '../models/travel_date_type.dart';
import '../models/travel_room_day_plan.dart';
import '../models/travel_room_main_data.dart';
import '../models/travel_room_member.dart';
import '../models/travel_room_plan_category.dart';
import '../models/travel_room_plan_item.dart';
import '../models/travel_room_stage.dart';

const travelRoomMainMockData = TravelRoomMainData(
  roomName: '보미의 촌캉스',
  travelDateType: TravelDateType.date,
  travelDateText: '9.12(토) - 9.18(금)',
  stage: TravelRoomStage.moodSelecting,
  members: [
    TravelRoomMember(id: 'member-1', name: '보미', moodCompleted: true),
    TravelRoomMember(id: 'member-2', name: '지민', moodCompleted: true),
    TravelRoomMember(id: 'member-3', name: '수빈', moodCompleted: true),
    TravelRoomMember(id: 'member-4', name: '예진', moodCompleted: true),
    TravelRoomMember(id: 'member-5', name: '민지', moodCompleted: false),
    TravelRoomMember(id: 'member-6', name: '서연', moodCompleted: false),
  ],
  moodName: '고즈넉한 쉼표 무드',
  moodDescription:
      '오래된 골목과 조용한 공간에서 천천히 걸음을 늦추고, '
      '바쁜 일상에서 잠시 벗어나 차분하게 쉬어가는 무드예요.',
  accommodations: [
    AccommodationRecommendation(
      id: 'accommodation-1',
      rank: 1,
      name: '스테이 고요',
      location: '강원특별자치도 강릉시',
      matchRate: 96,
      moodTags: ['고즈넉한 감성', '조용한 휴식', '아늑한 공간'],
      matchReasons: [
        '한적한 마을 안에 위치해 조용히 쉬기 좋아요.',
        '고즈넉한 분위기와 아늑한 공간이 무드와 잘 어울려요.',
      ],
      facilities: [LodgingFacility.bbq, LodgingFacility.cook],
      voters: [],
    ),
    AccommodationRecommendation(
      id: 'accommodation-2',
      rank: 2,
      name: '오래된 하루',
      location: '강원특별자치도 강릉시',
      matchRate: 93,
      moodTags: ['고즈넉한 감성', '빈티지 감성', '조용한 휴식'],
      matchReasons: ['오래된 공간의 분위기를 살린 숙소예요.', '복잡하지 않은 주변 환경에서 여유롭게 머물 수 있어요.'],
      facilities: [LodgingFacility.puppy, LodgingFacility.cook],
      voters: [],
    ),
    AccommodationRecommendation(
      id: 'accommodation-3',
      rank: 3,
      name: '소담한 집',
      location: '강원특별자치도 강릉시',
      matchRate: 89,
      moodTags: ['아늑한 공간', '조용한 휴식', '여유로운 풍경'],
      matchReasons: [
        '아늑하고 편안한 공간에서 천천히 쉬어가기 좋아요.',
        '숙소 주변의 한적한 풍경이 선택한 무드와 잘 맞아요.',
      ],
      facilities: [LodgingFacility.bbq],
      voters: [],
    ),
    AccommodationRecommendation(
      id: 'accommodation-4',
      rank: 4,
      name: '느린 오후',
      location: '강원특별자치도 강릉시',
      matchRate: 86,
      moodTags: ['조용한 휴식', '여유로운 풍경', '고즈넉한 감성'],
      matchReasons: [
        '조용한 동네에 있어 느긋하게 머물기 좋은 숙소예요.',
        '주변 풍경을 천천히 즐길 수 있어 선택한 무드와 잘 맞아요.',
      ],
      facilities: [LodgingFacility.puppy, LodgingFacility.bbq],
      voters: [],
    ),
    AccommodationRecommendation(
      id: 'accommodation-5',
      rank: 5,
      name: '머무는 사이',
      location: '강원특별자치도 강릉시',
      matchRate: 82,
      moodTags: ['아늑한 공간', '고즈넉한 감성', '빈티지 감성'],
      matchReasons: [
        '차분하고 아늑한 분위기에서 편하게 머물 수 있어요.',
        '빈티지한 공간과 고즈넉한 분위기가 무드와 어울려요.',
      ],
      facilities: [LodgingFacility.cook],
      voters: [],
    ),
  ],
  confirmedAccommodation: AccommodationRecommendation(
    id: 'accommodation-1',
    rank: 1,
    name: '스테이 고요',
    location: '강원특별자치도 강릉시',
    matchRate: 96,
    moodTags: ['고즈넉한 감성', '조용한 휴식', '아늑한 공간'],
    matchReasons: [
      '한적한 마을 안에 위치해 조용히 쉬기 좋아요.',
      '고즈넉한 분위기와 아늑한 공간이 무드와 잘 어울려요.',
    ],
    facilities: [LodgingFacility.bbq, LodgingFacility.cook],
    voters: [],
  ),
  dayPlans: [
    TravelRoomDayPlan(
      day: 1,
      items: [
        TravelRoomPlanItem(
          order: 1,
          title: '강릉 선교장',
          category: TravelRoomPlanCategory.tourism,
          summary: '고즈넉한 한옥의 정취를 느낄 수 있는 공간',
          moodMatchRate: 96,
          accommodationDistanceText: '숙소에서 차량 12분',
        ),
        TravelRoomPlanItem(
          order: 2,
          title: '초당순두부마을',
          category: TravelRoomPlanCategory.restaurant,
          summary: '강릉의 담백한 로컬 음식을 즐길 수 있는 곳',
          moodMatchRate: 91,
          accommodationDistanceText: '숙소에서 차량 15분',
        ),
        TravelRoomPlanItem(
          order: 3,
          title: '숙소 주변 산책하기',
          category: TravelRoomPlanCategory.activity,
          summary: '',
        ),
      ],
    ),
    TravelRoomDayPlan(
      day: 2,
      items: [
        TravelRoomPlanItem(
          order: 1,
          title: '오죽헌',
          category: TravelRoomPlanCategory.tourism,
          summary: '여유롭게 둘러보기 좋은 강릉의 대표 문화유산',
          moodMatchRate: 93,
          accommodationDistanceText: '숙소에서 차량 10분',
        ),
        TravelRoomPlanItem(
          order: 2,
          title: '강릉 중앙시장',
          category: TravelRoomPlanCategory.shopping,
          summary: '지역의 먹거리와 분위기를 함께 즐길 수 있는 시장',
          moodMatchRate: 84,
          accommodationDistanceText: '숙소에서 차량 18분',
        ),
      ],
    ),
    TravelRoomDayPlan(
      day: 3,
      items: [
        TravelRoomPlanItem(
          order: 1,
          title: '경포호',
          category: TravelRoomPlanCategory.tourism,
          summary: '잔잔한 호수를 따라 천천히 걷기 좋은 장소',
          moodMatchRate: 95,
          accommodationDistanceText: '숙소에서 차량 14분',
        ),
      ],
    ),
    TravelRoomDayPlan(
      day: 4,
      items: [
        TravelRoomPlanItem(
          order: 1,
          title: '강릉 커피거리',
          category: TravelRoomPlanCategory.restaurant,
          summary: '바다를 바라보며 여유롭게 쉬어갈 수 있는 공간',
          moodMatchRate: 88,
          accommodationDistanceText: '숙소에서 차량 20분',
        ),
      ],
    ),
    TravelRoomDayPlan(
      day: 5,
      items: [
        TravelRoomPlanItem(
          order: 1,
          title: '허균·허난설헌 기념공원',
          category: TravelRoomPlanCategory.tourism,
          summary: '고즈넉한 분위기 속에서 산책하기 좋은 공원',
          moodMatchRate: 90,
          accommodationDistanceText: '숙소에서 차량 13분',
        ),
      ],
    ),
    TravelRoomDayPlan(
      day: 6,
      items: [
        TravelRoomPlanItem(
          order: 1,
          title: '강릉 단오제',
          category: TravelRoomPlanCategory.event,
          summary: '강릉의 전통과 지역 분위기를 느낄 수 있는 축제',
          moodMatchRate: 81,
          accommodationDistanceText: '숙소에서 차량 16분',
        ),
      ],
    ),
    TravelRoomDayPlan(
      day: 7,
      items: [
        TravelRoomPlanItem(
          order: 1,
          title: '숙소에서 여유롭게 쉬기',
          category: TravelRoomPlanCategory.activity,
          summary: '',
        ),
      ],
    ),
  ],
);
