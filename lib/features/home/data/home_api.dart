import '../../../core/network/api_client.dart';
import '../../travel_room/models/travel_date_type.dart';
import '../../travel_room/utils/travel_date_formatter.dart';
import '../models/home_trip.dart';

class HomeApi {
  HomeApi._();

  static final HomeApi instance = HomeApi._();

  Future<List<HomeTrip>> fetchTrips() async {
    final response = await ApiClient.instance.get('/api/chonkangs/me/home');
    final data = response.data['data'] as Map<String, dynamic>;
    final records = List<Map<String, dynamic>>.from(data['records'] as List);

    records.sort(
      (a, b) => (a['startDate'] as String).compareTo(b['startDate'] as String),
    );

    return records.map(_toHomeTrip).toList();
  }

  HomeTrip _toHomeTrip(Map<String, dynamic> json) {
    final startDate = json['startDate'] as String;
    final today = DateTime.now();
    final todayDate = DateTime(today.year, today.month, today.day);

    return HomeTrip(
      id: json['id'] as int,
      name: json['name'] as String,
      moodLabel: json['moodName'] as String? ?? '',
      dateRange: TravelDateFormatter.format(
        type: TravelDateType.date,
        startDate: startDate,
        endDate: json['endDate'] as String,
      ),
      memberCount: json['memberCount'] as int,
      dDay: DateTime.parse(startDate).difference(todayDate).inDays,
      status: json['status'] == 'ONGOING'
          ? HomeTripStatus.inProgress
          : HomeTripStatus.completed,
    );
  }
}
