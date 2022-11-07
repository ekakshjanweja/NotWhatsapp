import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:not_whatsapp/common/utils/utils.dart';
import 'package:not_whatsapp/features/calls/screens/call_screen.dart';
import 'package:not_whatsapp/models/call_model.dart';
import 'package:not_whatsapp/models/group.dart';

final callRepositoryProvider = Provider(
  (ref) => CallRepository(
    firebaseFirestore: FirebaseFirestore.instance,
    firebaseAuth: FirebaseAuth.instance,
  ),
);

class CallRepository {
  final FirebaseFirestore firebaseFirestore;
  final FirebaseAuth firebaseAuth;

  CallRepository({
    required this.firebaseFirestore,
    required this.firebaseAuth,
  });

  //Make A Call

  void makeACall(
    CallModel senderCallData,
    BuildContext context,
    CallModel receiverCallData,
  ) async {
    NavigatorState state = Navigator.of(context);
    try {
      await firebaseFirestore
          .collection('calls')
          .doc(senderCallData.callerId)
          .set(
            senderCallData.toMap(),
          );

      await firebaseFirestore
          .collection('calls')
          .doc(senderCallData.receiverId)
          .set(
            receiverCallData.toMap(),
          );

      state.push(MaterialPageRoute(
        builder: (context) => CallScreen(
          channelId: senderCallData.callId,
          call: senderCallData,
          isGroupChat: false,
        ),
      ));
    } catch (e) {
      showSnackBar(context: context, content: e.toString());
    }
  }

  //Call Stream

  Stream<DocumentSnapshot> get callStream => firebaseFirestore
      .collection('calls')
      .doc(firebaseAuth.currentUser!.uid)
      .snapshots();

  //End Call

  void endCall(
    String callerId,
    String receiverId,
    BuildContext context,
  ) async {
    NavigatorState state = Navigator.of(context);

    try {
      await firebaseFirestore.collection('calls').doc(callerId).delete();

      await firebaseFirestore.collection('calls').doc(receiverId).delete();

      state.pop();
    } catch (e) {
      showSnackBar(context: context, content: e.toString());
    }
  }

  //Group Call

  void makeGroupCall(
    CallModel senderCallData,
    BuildContext context,
    CallModel receiverCallData,
  ) async {
    NavigatorState state = Navigator.of(context);
    try {
      await firebaseFirestore
          .collection('calls')
          .doc(senderCallData.callerId)
          .set(senderCallData.toMap());

      var groupSnapshot = await firebaseFirestore
          .collection('groups')
          .doc(senderCallData.receiverId)
          .get();

      Group group = Group.fromMap(groupSnapshot.data()!);

      for (var id in group.groupUsers) {
        await firebaseFirestore
            .collection('calls')
            .doc(id)
            .set(receiverCallData.toMap());
      }

      state.push(MaterialPageRoute(
        builder: (context) => CallScreen(
          channelId: senderCallData.callId,
          call: senderCallData,
          isGroupChat: true,
        ),
      ));
    } catch (e) {
      showSnackBar(context: context, content: e.toString());
    }
  }

  //End Group Call

  void endGroupCall(
    String callerId,
    String receiverId,
    BuildContext context,
  ) async {
    try {
      await firebaseFirestore.collection('calls').doc(callerId).delete();

      var groupSnapshot =
          await firebaseFirestore.collection('groups').doc(receiverId).get();

      Group group = Group.fromMap(groupSnapshot.data()!);

      for (var id in group.groupUsers) {
        await firebaseFirestore.collection('calls').doc(id).delete();
      }
    } catch (e) {
      showSnackBar(context: context, content: e.toString());
    }
  }
}
