import '../../../core/network/api_client.dart';
import '../models/create_trip_draft.dart';
import '../models/create_trip_mood_card.dart';
import '../models/create_trip_result.dart';

class CreateTripApi {
  CreateTripApi._();

  static final CreateTripApi instance = CreateTripApi._();

  Future<List<CreateTripMoodCard>> fetchRandomMoodCards() async {
    final response = await ApiClient.instance.get('/api/mood-cards/random');
    final records = List<Map<String, dynamic>>.from(
      response.data['data'] as List,
    );

    return records.map(CreateTripMoodCard.fromJson).toList();
  }

  Future<CreateTripResult> createChonkang({
    required CreateTripDraft draft,
    required Set<int> selectedMoodCardIds,
  }) async {
    final response = await ApiClient.instance.post(
      '/api/chonkangs',
      data: {
        'name': draft.name,
        'startDate': _formatDate(draft.startDate),
        'endDate': _formatDate(draft.endDate),
        'plannedMemberCount': draft.plannedMemberCount,
        'companionType': draft.companionType,
        'travelMethod': draft.travelMethod,
        'desiredRegion': draft.desiredRegion,
        'accommodationConditions': draft.accommodationConditions.toList(),
        'selectedMoodCardIds': selectedMoodCardIds.toList(),
      },
    );

    return CreateTripResult.fromJson(
      response.data['data'] as Map<String, dynamic>,
    );
  }

  String _formatDate(DateTime date) {
    final year = date.year.toString().padLeft(4, '0');
    final month = date.month.toString().padLeft(2, '0');
    final day = date.day.toString().padLeft(2, '0');
    return '$year-$month-$day';
  }
}
