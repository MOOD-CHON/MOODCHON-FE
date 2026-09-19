class VoteMember {
  const VoteMember({required this.id, this.nickname, this.profileImageUrl});

  final String id;
  final String? nickname;
  final String? profileImageUrl;

  factory VoteMember.fromJson(Map<String, dynamic> json) {
    return VoteMember(
      id: json['userId'].toString(),
      nickname: json['nickname'] as String?,
      profileImageUrl: json['profileImageUrl'] as String?,
    );
  }
}
