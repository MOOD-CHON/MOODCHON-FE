class ChonkangMember {
  const ChonkangMember({
    required this.userId,
    required this.nickname,
    required this.profileImageUrl,
    required this.isHost,
  });

  factory ChonkangMember.fromJson(Map<String, dynamic> json) {
    return ChonkangMember(
      userId: json['userId'] as int,
      nickname: json['nickname'] as String? ?? '',
      profileImageUrl: json['profileImageUrl'] as String?,
      isHost: json['isHost'] as bool? ?? false,
    );
  }

  final int userId;
  final String nickname;
  final String? profileImageUrl;
  final bool isHost;
}
