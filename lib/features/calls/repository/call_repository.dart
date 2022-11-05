import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:not_whatsapp/common/utils/utils.dart';
import 'package:not_whatsapp/models/call_model.dart';

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
    } catch (e) {
      showSnackBar(context: context, content: e.toString());
    }
  }
}
