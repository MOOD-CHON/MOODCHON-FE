enum CreateTripDateMode { date, range }

extension CreateTripDateModeLabel on CreateTripDateMode {
  String get label {
    switch (this) {
      case CreateTripDateMode.date:
        return '날짜 지정';
      case CreateTripDateMode.range:
        return '기간 지정';
    }
  }
}
