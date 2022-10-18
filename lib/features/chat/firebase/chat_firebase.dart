import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:not_whatsapp/common/enums/message_enum.dart';
import 'package:not_whatsapp/common/utils/utils.dart';
import 'package:not_whatsapp/models/chat_contact.dart';
import 'package:not_whatsapp/models/message_model.dart';
import 'package:not_whatsapp/models/user_model.dart';
import 'package:uuid/uuid.dart';

final chatFirebaseProvider = Provider(
  (ref) => ChatFirebase(
    firebaseFirestore: FirebaseFirestore.instance,
    firebaseAuth: FirebaseAuth.instance,
  ),
);

class ChatFirebase {
  final FirebaseFirestore firebaseFirestore;
  final FirebaseAuth firebaseAuth;

  ChatFirebase({
    required this.firebaseFirestore,
    required this.firebaseAuth,
  });

  //Get Messages Stream

  Stream<List<MessageModel>> getMessageStream(String receiverUserId) {
    return firebaseFirestore
        .collection('users')
        .doc(firebaseAuth.currentUser!.uid)
        .collection('chats')
        .doc(receiverUserId)
        .collection('messages')
        .orderBy('timeSent')
        .snapshots()
        .map(
      (event) {
        List<MessageModel> messages = [];

        for (var doc in event.docs) {
          messages.add(
            MessageModel.fromMap(
              doc.data(),
            ),
          );
        }
        return messages;
      },
    );
  }

  //Get Chat Stream

  Stream<List<ChatContact>> getChatStream() {
    return firebaseFirestore
        .collection('users')
        .doc(firebaseAuth.currentUser!.uid)
        .collection('chats')
        .snapshots()
        .asyncMap(
      (event) async {
        List<ChatContact> contacts = [];
        for (var doc in event.docs) {
          var chatContact = ChatContact.fromMap(doc.data());
          var userData = await firebaseFirestore
              .collection('users')
              .doc(chatContact.contactId)
              .get();
          var user = UserModel.fromMap(userData.data()!);
          contacts.add(
            ChatContact(
              name: user.name,
              profilePic: user.profilePic,
              contactId: user.uid,
              timeSent: chatContact.timeSent,
              lastMessage: chatContact.lastMessage,
            ),
          );
        }
        return contacts;
      },
    );
  }

  //Send Text Message And Update In Firestore

  void sendTextMessage({
    required BuildContext context,
    required String text,
    required String receiverUserId,
    required UserModel senderUserData,
  }) async {
    try {
      //Time of message send

      var timeSent = DateTime.now();

      //Receiver Data

      UserModel receiverUserData;

      //Get receiver user data in form of a map

      var userDataMap =
          await firebaseFirestore.collection('users').doc(receiverUserId).get();

      //Receiver Data asssigned

      receiverUserData = UserModel.fromMap(userDataMap.data()!);

      _saveDataToContactsSubCollection(
        senderUserData,
        receiverUserData,
        text,
        timeSent,
        receiverUserId,
      );

      var messageId = const Uuid().v1();

      _saveMessageToMessageSubCollection(
        receiverUserId: receiverUserId,
        text: text,
        timeSent: timeSent,
        messageType: MessageEnum.text,
        messageId: messageId,
        receiverUsername: receiverUserData.name,
        username: senderUserData.name,
      );

      //users -> sender id -> receiver id -> messages -> message id -> store message

    } catch (e) {
      showSnackBar(
        context: context,
        content: e.toString(),
      );
    }
  }

  //Save Text Message Data To Firestore In Contacts Sub Collection

  void _saveDataToContactsSubCollection(
    UserModel senderUserData,
    UserModel receiveruserData,
    String text,
    DateTime timeSent,
    String receiverUserId,
  ) async {
    //users -> receiver user id => chats -> current user id -> set data

    //Receiver Chat Contact

    var receiverChatContact = ChatContact(
      name: senderUserData.name,
      profilePic: senderUserData.profilePic,
      contactId: senderUserData.uid,
      timeSent: timeSent,
      lastMessage: text,
    );

    //Add data to chats sub collection

    await firebaseFirestore
        .collection('users')
        .doc(receiverUserId)
        .collection('chats')
        .doc(firebaseAuth.currentUser!.uid)
        .set(
          receiverChatContact.toMap(),
        );

    //users -> current user id => chats -> receiver user id -> set data

    //Sender Chat Contact

    var senderChatContact = ChatContact(
      name: receiveruserData.name,
      profilePic: receiveruserData.profilePic,
      contactId: receiveruserData.uid,
      timeSent: timeSent,
      lastMessage: text,
    );

    //Add data to chats sub collection

    await firebaseFirestore
        .collection('users')
        .doc(firebaseAuth.currentUser!.uid)
        .collection('chats')
        .doc(receiverUserId)
        .set(
          senderChatContact.toMap(),
        );
  }

  //Save Message To Message Sub Collection

  void _saveMessageToMessageSubCollection({
    required String receiverUserId,
    required String text,
    required DateTime timeSent,
    required String messageId,
    required String username,
    required String receiverUsername,
    required MessageEnum messageType,
  }) async {
    final message = MessageModel(
      senderId: firebaseAuth.currentUser!.uid,
      receiverId: receiverUserId,
      text: text,
      type: messageType,
      timeSent: timeSent,
      messageId: messageId,
      isSeen: false,
    );

    //users -> sender id -> receiver id -> messages -> message id -> store message

    await firebaseFirestore
        .collection('users')
        .doc(firebaseAuth.currentUser!.uid)
        .collection('chats')
        .doc(receiverUserId)
        .collection('messages')
        .doc(messageId)
        .set(
          message.toMap(),
        );

    //users -> receiver id -> sender id -> messages -> message id -> store message

    await firebaseFirestore
        .collection('users')
        .doc(receiverUserId)
        .collection('chats')
        .doc(firebaseAuth.currentUser!.uid)
        .collection('messages')
        .doc(messageId)
        .set(
          message.toMap(),
        );
  }
}
