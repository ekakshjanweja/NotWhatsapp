// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:not_whatsapp/common/widgets/loader.dart';

import 'package:not_whatsapp/constants/info.dart';
import 'package:not_whatsapp/features/chat/controller/chat_controller.dart';
import 'package:not_whatsapp/models/message_model.dart';
import 'package:not_whatsapp/widgets/sender_message_card.dart';
import 'package:not_whatsapp/widgets/user_message_card.dart';

class ChatList extends ConsumerWidget {
  final String receiverUserId;
  const ChatList({
    required this.receiverUserId,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return StreamBuilder<List<MessageModel>>(
        stream: ref.watch(chatControllerProvider).messageStream(receiverUserId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Loader();
          }
          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: ((context, index) {
              //Message Data

              final messageData = snapshot.data![index];

              if (messageData.senderId ==
                  FirebaseAuth.instance.currentUser!.uid) {
                // My message card
                return UserMessageCard(
                  message: messageData.text,
                  time: DateFormat.Hm().format(messageData.timeSent),
                );
              } else {
                //sender message card
                return SenderMessageCard(
                  message: messageData.text,
                  time: DateFormat.Hm().format(messageData.timeSent),
                );
              }
            }),
          );
        });
  }
}
