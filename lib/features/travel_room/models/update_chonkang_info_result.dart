class UpdateChonkangInfoResult {
  const UpdateChonkangInfoResult({
    required this.needsMoodReselect,
    required this.accommodationResetRequired,
  });

  factory UpdateChonkangInfoResult.fromJson(Map<String, dynamic> json) {
    return UpdateChonkangInfoResult(
      needsMoodReselect: json['needsMoodReselect'] as bool? ?? false,
      accommodationResetRequired:
          json['accommodationResetRequired'] as bool? ?? false,
    );
  }

  final bool needsMoodReselect;
  final bool accommodationResetRequired;
}
