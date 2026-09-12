enum CreateTripFormSection {
  name,
  date,
  members,
  companions,
  transport,
  region,
  accommodation,
}

extension CreateTripFormSectionLabel on CreateTripFormSection {
  String get label {
    switch (this) {
      case CreateTripFormSection.name:
        return '여행 이름';
      case CreateTripFormSection.date:
        return '여행 날짜';
      case CreateTripFormSection.members:
        return '인원수';
      case CreateTripFormSection.companions:
        return '동행인 정보';
      case CreateTripFormSection.transport:
        return '이동 방식';
      case CreateTripFormSection.region:
        return '희망 지역';
      case CreateTripFormSection.accommodation:
        return '기타 숙소 조건';
    }
  }

  bool get required {
    switch (this) {
      case CreateTripFormSection.name:
      case CreateTripFormSection.date:
      case CreateTripFormSection.members:
        return true;
      case CreateTripFormSection.companions:
      case CreateTripFormSection.transport:
      case CreateTripFormSection.region:
      case CreateTripFormSection.accommodation:
        return false;
    }
  }
}
