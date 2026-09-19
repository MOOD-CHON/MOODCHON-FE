enum TravelMethod { car, publicTransport, undecided }

extension TravelMethodApi on TravelMethod {
  String get apiValue {
    switch (this) {
      case TravelMethod.car:
        return 'CAR';
      case TravelMethod.publicTransport:
        return 'PUBLIC_TRANSPORT';
      case TravelMethod.undecided:
        return 'UNDECIDED';
    }
  }

  String get label {
    switch (this) {
      case TravelMethod.car:
        return '자차';
      case TravelMethod.publicTransport:
        return '대중교통';
      case TravelMethod.undecided:
        return '미정';
    }
  }

  static TravelMethod fromApiValue(String value) {
    return TravelMethod.values.firstWhere(
      (method) => method.apiValue == value,
      orElse: () => TravelMethod.car,
    );
  }
}
