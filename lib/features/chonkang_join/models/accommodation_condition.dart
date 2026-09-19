enum AccommodationCondition { petFriendly, barbecue, cooking }

extension AccommodationConditionApi on AccommodationCondition {
  String get apiValue {
    switch (this) {
      case AccommodationCondition.petFriendly:
        return 'PET_FRIENDLY';
      case AccommodationCondition.barbecue:
        return 'BARBECUE';
      case AccommodationCondition.cooking:
        return 'COOKING';
    }
  }

  String get label {
    switch (this) {
      case AccommodationCondition.petFriendly:
        return '반려동물 동반';
      case AccommodationCondition.barbecue:
        return '바비큐 가능';
      case AccommodationCondition.cooking:
        return '취사 가능';
    }
  }

  static AccommodationCondition fromApiValue(String value) {
    return AccommodationCondition.values.firstWhere(
      (condition) => condition.apiValue == value,
      orElse: () => AccommodationCondition.petFriendly,
    );
  }
}
