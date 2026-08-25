enum FacilityType {
  bike,
  fire,
  parking,
  stroller,
  card,
  puppy,
  takeout,
  sauna,
  sports,
  toilet,
}

extension FacilityTypeX on FacilityType {
  String get existLabel {
    switch (this) {
      case FacilityType.bike:
        return '자전거 대여 가능';
      case FacilityType.fire:
        return '캠프파이어 가능';
      case FacilityType.parking:
        return '주차 가능';
      case FacilityType.stroller:
        return '유모차 대여 가능';
      case FacilityType.card:
        return '신용카드 가능';
      case FacilityType.puppy:
        return '반려동물 동반 가능';
      case FacilityType.takeout:
        return '포장 가능';
      case FacilityType.sauna:
        return '사우나실 있음';
      case FacilityType.sports:
        return '스포츠 시설 있음';
      case FacilityType.toilet:
        return '화장실 있음';
    }
  }

  String get nonexistenceLabel {
    switch (this) {
      case FacilityType.bike:
        return '자전거 대여 불가능';
      case FacilityType.fire:
        return '캠프파이어 불가능';
      case FacilityType.parking:
        return '주차 불가능';
      case FacilityType.stroller:
        return '유모차 대여 불가능';
      case FacilityType.card:
        return '신용카드 불가능';
      case FacilityType.puppy:
        return '반려동물 동반 불가능';
      case FacilityType.takeout:
        return '포장 불가능';
      case FacilityType.sauna:
        return '사우나실 없음';
      case FacilityType.sports:
        return '스포츠 시설 없음';
      case FacilityType.toilet:
        return '화장실 없음';
    }
  }
}
