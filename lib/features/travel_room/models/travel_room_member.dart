class TravelRoomMember {
  const TravelRoomMember({
    required this.id,
    required this.name,
    required this.moodCompleted,
  });

  final String id;
  final String name;
  final bool moodCompleted;

  factory TravelRoomMember.fromJson(Map<String, dynamic> json) {
    return TravelRoomMember(
      id: json['userId'].toString(),
      name: json['nickname'] as String,
      moodCompleted: json['moodSelected'] as bool,
    );
  }
}
