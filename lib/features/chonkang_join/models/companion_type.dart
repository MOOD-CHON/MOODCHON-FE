enum CompanionType { friend, family, parent, couple, child, other }

extension CompanionTypeApi on CompanionType {
  String get apiValue {
    switch (this) {
      case CompanionType.friend:
        return 'FRIEND';
      case CompanionType.family:
        return 'FAMILY';
      case CompanionType.parent:
        return 'PARENT';
      case CompanionType.couple:
        return 'COUPLE';
      case CompanionType.child:
        return 'CHILD';
      case CompanionType.other:
        return 'OTHER';
    }
  }

  String get label {
    switch (this) {
      case CompanionType.friend:
        return '친구';
      case CompanionType.family:
        return '가족';
      case CompanionType.parent:
        return '부모님';
      case CompanionType.couple:
        return '연인';
      case CompanionType.child:
        return '아이';
      case CompanionType.other:
        return '기타';
    }
  }

  static CompanionType fromApiValue(String value) {
    return CompanionType.values.firstWhere(
      (type) => type.apiValue == value,
      orElse: () => CompanionType.other,
    );
  }
}
