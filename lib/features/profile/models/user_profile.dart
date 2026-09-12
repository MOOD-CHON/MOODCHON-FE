class UserProfile {
  const UserProfile({
    required this.id,
    required this.nickname,
    required this.profileImageUrl,
    required this.notificationEnabled,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: json['id'] as int,
      nickname: json['nickname'] as String? ?? '',
      profileImageUrl: json['profileImageUrl'] as String?,
      notificationEnabled: json['notificationEnabled'] as bool? ?? false,
    );
  }

  final int id;
  final String nickname;
  final String? profileImageUrl;
  final bool notificationEnabled;
}
