import '../models/home_trip.dart';

abstract final class HomeMockData {
  static const List<HomeTrip> trips = [
    HomeTrip(
      name: 'MOODI',
      moodLabel: '고즈넉한 쉼표 무드',
      dateRange: '9.22(화) - 9.23(수)',
      memberCount: 3,
      dDay: 10,
      status: HomeTripStatus.inProgress,
    ),
    HomeTrip(
      name: '가을 촌캉스',
      moodLabel: '따뜻한 노을 무드',
      dateRange: '10.3(토) - 10.5(월)',
      memberCount: 4,
      dDay: 21,
      status: HomeTripStatus.inProgress,
    ),
  ];
}
