import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:not_whatsapp/common/enums/message_enum.dart';
import 'package:not_whatsapp/common/firebase/common_firebase_storage_repository.dart';
import 'package:not_whatsapp/common/providers/message_reply_provider.dart';
import 'package:not_whatsapp/common/utils/utils.dart';
import 'package:not_whatsapp/models/chat_contact.dart';
import 'package:not_whatsapp/models/group.dart';
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

  //Get Group Messages Stream

  Stream<List<MessageModel>> getGroupMessageStream(String groupId) {
    return firebaseFirestore
        .collection('groups')
        .doc(groupId)
        .collection('chats')
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

  //Get Group Stream

  Stream<List<Group>> getGroupStream() {
    return firebaseFirestore.collection('groups').snapshots().map(
      (event) {
        List<Group> groups = [];

        for (var doc in event.docs) {
          var group = Group.fromMap(doc.data());
          if (group.groupUsers.contains(firebaseAuth.currentUser!.uid)) {
            groups.add(group);
          }
        }

        return groups;
      },
    );
  }

  //Send Text Message And Update In Firestore

  void sendTextMessage({
    required BuildContext context,
    required String text,
    required String receiverUserId,
    required UserModel senderUserData,
    required MessageReply? messageReply,
    required bool isGroupChat,
  }) async {
    try {
      //Time of message send

      var timeSent = DateTime.now();

      //Receiver Data

      UserModel? receiverUserData;

      //Get receiver user data in form of a map

      if (!isGroupChat) {
        var userDataMap = await firebaseFirestore
            .collection('users')
            .doc(receiverUserId)
            .get();

        //Receiver Data asssigned

        receiverUserData = UserModel.fromMap(userDataMap.data()!);
      }

      _saveDataToContactsSubCollection(
        senderUserData,
        receiverUserData,
        text,
        timeSent,
        receiverUserId,
        isGroupChat,
      );

      var messageId = const Uuid().v1();

      _saveMessageToMessageSubCollection(
        receiverUserId: receiverUserId,
        text: text,
        timeSent: timeSent,
        messageType: MessageEnum.text,
        messageId: messageId,
        receiverUsername: receiverUserData?.name,
        username: senderUserData.name,
        messageReply: messageReply,
        senderUsername: senderUserData.name,
        messageEnum:
            messageReply == null ? MessageEnum.text : messageReply.messageEnum,
        isGroupChat: isGroupChat,
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
    UserModel? receiverUserData,
    String text,
    DateTime timeSent,
    String receiverUserId,
    bool isGroupChat,
  ) async {
    if (isGroupChat) {
      //groups -> group id -> chat -> message

      await firebaseFirestore.collection('groups').doc(receiverUserId).update({
        'lastMessage': text,
        'timeSent': DateTime.now().millisecondsSinceEpoch,
      });
    } else {
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
        name: receiverUserData!.name,
        profilePic: receiverUserData.profilePic,
        contactId: receiverUserData.uid,
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
  }

  //Save Message To Message Sub Collection

  void _saveMessageToMessageSubCollection(
      {required String receiverUserId,
      required String text,
      required DateTime timeSent,
      required String messageId,
      required String username,
      required String? receiverUsername,
      required MessageEnum messageType,
      required MessageReply? messageReply,
      required String senderUsername,
      required MessageEnum messageEnum,
      required bool isGroupChat}) async {
    final message = MessageModel(
      senderId: firebaseAuth.currentUser!.uid,
      receiverId: receiverUserId,
      text: text,
      type: messageType,
      timeSent: timeSent,
      messageId: messageId,
      isSeen: false,
      repliedMessage: messageReply == null ? '' : messageReply.message,
      repliedTo: messageReply == null
          ? ''
          : messageReply.isMe
              ? senderUsername
              : receiverUsername ?? '',
      repliedMessageType:
          messageReply == null ? messageEnum : messageReply.messageEnum,
    );

    if (isGroupChat) {
      //groups -> group id -> chat -> message

      await firebaseFirestore
          .collection('groups')
          .doc(receiverUserId)
          .collection('chats')
          .doc(messageId)
          .set(message.toMap());
    } else {
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

  //Send Files In Messages

  void sendFileMessage({
    required BuildContext context,
    required File file,
    required String receiverUserId,
    required UserModel senderUserData,
    required ProviderRef ref,
    required MessageEnum messageEnum,
    required MessageReply? messageReply,
    required bool isGroupChat,
  }) async {
    try {
      //Time Sent

      var timeSent = DateTime.now();

      //Message Id

      var messageId = const Uuid().v1();

      //Store imagee to firebase storage

      String imageUrl = await ref
          .read(commonFirebaseStorageRepositoryProvider)
          .storeFileToFirebase(
            'chat/${messageEnum.type}/${senderUserData.uid}/$receiverUserId/$messageId',
            file,
          );

      //Receiver User Data

      UserModel? receiverUserData;

      if (!isGroupChat) {
        var userDataMap = await firebaseFirestore
            .collection('users')
            .doc(receiverUserId)
            .get();

        receiverUserData = UserModel.fromMap(userDataMap.data()!);
      }

      //Save Data TO Conacts Sub Collection

      String conactMessage;

      switch (messageEnum) {
        case MessageEnum.image:
          conactMessage = '???? Photo';
          break;
        case MessageEnum.video:
          conactMessage = '???? Video';
          break;
        case MessageEnum.audio:
          conactMessage = '???? Audio';
          break;
        case MessageEnum.gif:
          conactMessage = 'GIF';
          break;
        default:
          conactMessage = 'GIF';
      }

      _saveDataToContactsSubCollection(
        senderUserData,
        receiverUserData,
        conactMessage,
        timeSent,
        receiverUserId,
        isGroupChat,
      );

      //Saving message to messages sub collection

      _saveMessageToMessageSubCollection(
        receiverUserId: receiverUserId,
        text: imageUrl,
        timeSent: timeSent,
        messageId: messageId,
        username: senderUserData.name,
        receiverUsername: receiverUserData?.name,
        messageType: messageEnum,
        messageReply: messageReply,
        senderUsername: senderUserData.name,
        messageEnum:
            messageReply == null ? MessageEnum.text : messageReply.messageEnum,
        isGroupChat: isGroupChat,
      );
    } catch (e) {
      showSnackBar(context: context, content: e.toString());
    }
  }

  //Send Gif

  void sendGIFMessage({
    required BuildContext context,
    required String gifUrl,
    required String receiverUserId,
    required UserModel senderUser,
    required MessageReply? messageReply,
    required bool isGroupChat,
  }) async {
    try {
      var timeSent = DateTime.now();

      UserModel? receiverUserData;

      if (!isGroupChat) {
        var userDataMap = await firebaseFirestore
            .collection('users')
            .doc(receiverUserId)
            .get();

        receiverUserData = UserModel.fromMap(userDataMap.data()!);
      }

      var messageId = const Uuid().v1();

      _saveDataToContactsSubCollection(
        senderUser,
        receiverUserData,
        'GIF',
        timeSent,
        receiverUserId,
        isGroupChat,
      );

      _saveMessageToMessageSubCollection(
        receiverUserId: receiverUserId,
        text: gifUrl,
        timeSent: timeSent,
        messageId: messageId,
        username: senderUser.name,
        receiverUsername: receiverUserData?.name,
        messageType: MessageEnum.gif,
        messageReply: messageReply,
        senderUsername: senderUser.name,
        messageEnum:
            messageReply == null ? MessageEnum.text : messageReply.messageEnum,
        isGroupChat: isGroupChat,
      );
    } catch (e) {
      showSnackBar(context: context, content: e.toString());
    }
  }

  //Message Seen Functionality

  void isMessageSeen(
    BuildContext context,
    String receiverUserId,
    String messageId,
  ) async {
    try {
      //Update isSeen in messages subcollection of user

      await firebaseFirestore
          .collection('users')
          .doc(firebaseAuth.currentUser!.uid)
          .collection('chats')
          .doc(receiverUserId)
          .collection('messages')
          .doc(messageId)
          .update({'isSeen': true});

      //Update isSeen in messages subcollection of sender

      await firebaseFirestore
          .collection('users')
          .doc(receiverUserId)
          .collection('chats')
          .doc(firebaseAuth.currentUser!.uid)
          .collection('messages')
          .doc(messageId)
          .update({'isSeen': true});
    } catch (e) {
      showSnackBar(context: context, content: e.toString());
    }
  }
}
