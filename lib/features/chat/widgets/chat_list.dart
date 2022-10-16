import 'package:flutter/material.dart';
import 'package:not_whatsapp/constants/info.dart';
import 'package:not_whatsapp/widgets/sender_message_card.dart';
import 'package:not_whatsapp/widgets/user_message_card.dart';

class ChatList extends StatelessWidget {
  const ChatList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: messages.length,
      itemBuilder: ((context, index) {
        if (messages[index]['isMe'] == true) {
          // My message card
          return UserMessageCard(
            message: messages[index]['text'].toString(),
            time: messages[index]['time'].toString(),
          );
        } else {
          //sender message card
          return SenderMessageCard(
            message: messages[index]['text'].toString(),
            time: messages[index]['time'].toString(),
          );
        }
      }),
    );
  }
}
