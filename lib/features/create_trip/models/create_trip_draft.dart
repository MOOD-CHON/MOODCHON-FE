class CreateTripDraft {
  const CreateTripDraft({
    required this.name,
    required this.startDate,
    required this.endDate,
    required this.plannedMemberCount,
    required this.companionType,
    required this.travelMethod,
    required this.desiredRegion,
    required this.accommodationConditions,
  });

  final String name;
  final DateTime startDate;
  final DateTime endDate;
  final int plannedMemberCount;
  final String? companionType;
  final String? travelMethod;
  final String? desiredRegion;
  final Set<String> accommodationConditions;
}
