import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:not_whatsapp/common/enums/message_enum.dart';
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
    ref.read(userDataAuthProvider).whenData(
          (senderUserData) => chatFirebase.sendTextMessage(
            context: context,
            text: text,
            receiverUserId: receiverUserId,
            senderUserData: senderUserData!,
          ),
        );
  }

  //Send Files In Messages

  void sendFileMessage({
    required BuildContext context,
    required File file,
    required String receiverUserId,
    required MessageEnum messageEnum,
  }) {
    ref.read(userDataAuthProvider).whenData(
          (value) => chatFirebase.sendFileMessage(
            context: context,
            file: file,
            receiverUserId: receiverUserId,
            senderUserData: value!,
            ref: ref,
            messageEnum: messageEnum,
          ),
        );
  }
}
