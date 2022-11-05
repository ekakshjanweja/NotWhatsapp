class Group {
  final String groupName;
  final String groupId;
  final String lastMessage;
  final String groupImage;
  final String senederId;

  final List<String> groupUsers;

  Group({
    required this.groupName,
    required this.groupId,
    required this.lastMessage,
    required this.groupImage,
    required this.senederId,
    required this.groupUsers,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'groupName': groupName,
      'groupId': groupId,
      'lastMessage': lastMessage,
      'groupImage': groupImage,
      'senederId': senederId,
      'groupUsers': groupUsers,
    };
  }

  factory Group.fromMap(Map<String, dynamic> map) {
    return Group(
      groupName: map['groupName'] as String,
      groupId: map['groupId'] as String,
      lastMessage: map['lastMessage'] as String,
      groupImage: map['groupImage'] as String,
      senederId: map['senederId'] as String,
      groupUsers: List<String>.from(
        (map['groupUsers'] as List<String>),
      ),
    );
  }
}
