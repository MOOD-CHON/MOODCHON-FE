// 백엔드 enum 값 -> 한글 라벨. create_trip 쪽 매핑(한글 -> enum)의 역방향이라
// 저 목록과 항상 같이 맞춰줘야 한다.
const Map<String, String> companionTypeLabels = {
  'FRIEND': '친구',
  'FAMILY': '가족',
  'PARENT': '부모님',
  'COUPLE': '연인',
  'CHILD': '아이',
  'OTHER': '기타',
};

const Map<String, String> travelMethodLabels = {
  'CAR': '자차',
  'PUBLIC_TRANSPORT': '대중교통',
  'UNDECIDED': '미정',
};

const Map<String, String> regionLabels = {
  'GANGWON': '강원특별자치도',
  'GYEONGGI': '경기도',
  'GYEONGSANGNAM': '경상남도',
  'GYEONGSANGBUK': '경상북도',
  'GWANGJU': '광주광역시',
  'DAEGU': '대구광역시',
  'DAEJEON': '대전광역시',
  'BUSAN': '부산광역시',
  'SEOUL': '서울특별시',
  'SEJONG': '세종특별자치시',
  'ULSAN': '울산광역시',
  'INCHEON': '인천광역시',
  'JEOLLANAM': '전라남도',
  'JEONBUK': '전북특별자치도',
  'JEJU': '제주특별자치도',
  'CHUNGCHEONGNAM': '충청남도',
  'CHUNGCHEONGBUK': '충청북도',
};
