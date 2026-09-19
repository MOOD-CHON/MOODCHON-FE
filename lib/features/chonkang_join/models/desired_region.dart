enum DesiredRegion {
  seoul,
  gyeonggi,
  incheon,
  gangwon,
  sejong,
  daejeon,
  chungcheongbuk,
  chungcheongnam,
  gwangju,
  jeonbuk,
  jeollanam,
  daegu,
  gyeongsangbuk,
  busan,
  ulsan,
  gyeongsangnam,
  jeju,
}

extension DesiredRegionApi on DesiredRegion {
  String get apiValue {
    switch (this) {
      case DesiredRegion.seoul:
        return 'SEOUL';
      case DesiredRegion.gyeonggi:
        return 'GYEONGGI';
      case DesiredRegion.incheon:
        return 'INCHEON';
      case DesiredRegion.gangwon:
        return 'GANGWON';
      case DesiredRegion.sejong:
        return 'SEJONG';
      case DesiredRegion.daejeon:
        return 'DAEJEON';
      case DesiredRegion.chungcheongbuk:
        return 'CHUNGCHEONGBUK';
      case DesiredRegion.chungcheongnam:
        return 'CHUNGCHEONGNAM';
      case DesiredRegion.gwangju:
        return 'GWANGJU';
      case DesiredRegion.jeonbuk:
        return 'JEONBUK';
      case DesiredRegion.jeollanam:
        return 'JEOLLANAM';
      case DesiredRegion.daegu:
        return 'DAEGU';
      case DesiredRegion.gyeongsangbuk:
        return 'GYEONGSANGBUK';
      case DesiredRegion.busan:
        return 'BUSAN';
      case DesiredRegion.ulsan:
        return 'ULSAN';
      case DesiredRegion.gyeongsangnam:
        return 'GYEONGSANGNAM';
      case DesiredRegion.jeju:
        return 'JEJU';
    }
  }

  String get label {
    switch (this) {
      case DesiredRegion.seoul:
        return '서울특별시';
      case DesiredRegion.gyeonggi:
        return '경기도';
      case DesiredRegion.incheon:
        return '인천광역시';
      case DesiredRegion.gangwon:
        return '강원특별자치도';
      case DesiredRegion.sejong:
        return '세종특별자치시';
      case DesiredRegion.daejeon:
        return '대전광역시';
      case DesiredRegion.chungcheongbuk:
        return '충청북도';
      case DesiredRegion.chungcheongnam:
        return '충청남도';
      case DesiredRegion.gwangju:
        return '광주광역시';
      case DesiredRegion.jeonbuk:
        return '전북특별자치도';
      case DesiredRegion.jeollanam:
        return '전라남도';
      case DesiredRegion.daegu:
        return '대구광역시';
      case DesiredRegion.gyeongsangbuk:
        return '경상북도';
      case DesiredRegion.busan:
        return '부산광역시';
      case DesiredRegion.ulsan:
        return '울산광역시';
      case DesiredRegion.gyeongsangnam:
        return '경상남도';
      case DesiredRegion.jeju:
        return '제주특별자치도';
    }
  }

  static DesiredRegion fromApiValue(String value) {
    return DesiredRegion.values.firstWhere(
      (region) => region.apiValue == value,
      orElse: () => DesiredRegion.seoul,
    );
  }
}
