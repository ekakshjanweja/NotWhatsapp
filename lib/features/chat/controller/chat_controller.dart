import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:not_whatsapp/features/authentication/controller/auth_controller.dart';
import 'package:not_whatsapp/features/chat/firebase/chat_firebase.dart';

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
}
