import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:not_whatsapp/common/enums/message_enum.dart';
import 'package:not_whatsapp/common/providers/message_reply_provider.dart';
import 'package:not_whatsapp/features/authentication/controller/auth_controller.dart';
import 'package:not_whatsapp/features/chat/firebase/chat_firebase.dart';
import 'package:not_whatsapp/models/chat_contact.dart';
import 'package:not_whatsapp/models/message_model.dart';

final chatControllerProvider = Provider(
  (ref) {
    final chatFirebase = ref.watch(chatFirebaseProvider);
    return ChatController(
      chatFirebase: chatFirebase,
      ref: ref,
    );
  },
);

class ChatController {
  final ChatFirebase chatFirebase;
  final ProviderRef ref;

  ChatController({
    required this.chatFirebase,
    required this.ref,
  });

  //Get Message Stream

  Stream<List<MessageModel>> messageStream(String receiverUserId) {
    return chatFirebase.getMessageStream(receiverUserId);
  }

  //Get Chat Stream

  Stream<List<ChatContact>> chatStream() {
    return chatFirebase.getChatStream();
  }

  //Send Text Message

  void sendTextMessage(
    BuildContext context,
    String text,
    String receiverUserId,
  ) {
    final messageReply = ref.read(messageReplyProvider);
    ref.read(userDataAuthProvider).whenData(
          (senderUserData) => chatFirebase.sendTextMessage(
            context: context,
            text: text,
            receiverUserId: receiverUserId,
            senderUserData: senderUserData!,
            messageReply: messageReply,
          ),
        );
    ref.read(messageReplyProvider.state).update((state) => null);
  }

  //Send Files In Messages

  void sendFileMessage({
    required BuildContext context,
    required File file,
    required String receiverUserId,
    required MessageEnum messageEnum,
  }) {
    final messageReply = ref.read(messageReplyProvider);
    ref.read(userDataAuthProvider).whenData(
          (value) => chatFirebase.sendFileMessage(
            context: context,
            file: file,
            receiverUserId: receiverUserId,
            senderUserData: value!,
            ref: ref,
            messageEnum: messageEnum,
            messageReply: messageReply,
          ),
        );

    ref.read(messageReplyProvider.state).update((state) => null);
  }

  //Send GIF

  void sendGIFMessage(
    BuildContext context,
    String gifUrl,
    String receiverUserId,
  ) {
    int gifUrlPartIndex = gifUrl.lastIndexOf('-') + 1;
    String gifUrlPart = gifUrl.substring(gifUrlPartIndex);
    String newGifUrl = 'https://i.giphy.com/media/$gifUrlPart/200.gif';
    final messageReply = ref.read(messageReplyProvider);

    ref.read(userDataAuthProvider).whenData(
          (value) => chatFirebase.sendGIFMessage(
            context: context,
            gifUrl: newGifUrl,
            receiverUserId: receiverUserId,
            senderUser: value!,
            messageReply: messageReply,
          ),
        );
    ref.read(messageReplyProvider.state).update((state) => null);
  }

  //Message Seen Functionality

  void isMessageSeen(
    BuildContext context,
    String receiverUserId,
    String messageId,
  ) {
    chatFirebase.isMessageSeen(
      context,
      receiverUserId,
      messageId,
    );
  }
}
