// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import 'package:not_whatsapp/common/widgets/loader.dart';
import 'package:not_whatsapp/features/chat/controller/chat_controller.dart';
import 'package:not_whatsapp/models/message_model.dart';
import 'package:not_whatsapp/widgets/sender_message_card.dart';
import 'package:not_whatsapp/widgets/user_message_card.dart';

class ChatList extends ConsumerStatefulWidget {
  final String receiverUserId;
  const ChatList({
    super.key,
    required this.receiverUserId,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ChatListState();
}

class _ChatListState extends ConsumerState<ChatList> {
  //Scroll Controller

  final ScrollController messageController = ScrollController();

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    messageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<MessageModel>>(
        stream: ref
            .watch(chatControllerProvider)
            .messageStream(widget.receiverUserId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Loader();
          }

          //Auto Scroll Functionality

          SchedulerBinding.instance.addPostFrameCallback((_) {
            messageController
                .jumpTo(messageController.position.maxScrollExtent);
          });
          return ListView.builder(
            controller: messageController,
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
    ;
  }
}
