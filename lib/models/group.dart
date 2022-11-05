// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class Group {
  final String groupName;
  final String groupId;
  final String lastMessage;
  final String groupImage;
  final String senederId;
  final DateTime timeSent;
  final List<String> groupUsers;

  Group({
    required this.timeSent,
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
      'timeSent': timeSent.millisecondsSinceEpoch,
      'groupUsers': groupUsers,
    };
  }

  factory Group.fromMap(Map<String, dynamic> map) {
    return Group(
      groupName: map['groupName'] ?? '',
      groupId: map['groupId'] ?? '',
      lastMessage: map['lastMessage'] ?? '',
      groupImage: map['groupImage'] ?? '',
      senederId: map['senederId'] ?? '',
      timeSent: DateTime.fromMillisecondsSinceEpoch(map['timeSent']),
      groupUsers: List<String>.from(
        (map['groupUsers']),
      ),
    );
  }
}
