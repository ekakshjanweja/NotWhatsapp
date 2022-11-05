import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:not_whatsapp/features/authentication/controller/auth_controller.dart';
import 'package:not_whatsapp/features/calls/repository/call_repository.dart';
import 'package:not_whatsapp/models/call_model.dart';
import 'package:uuid/uuid.dart';

final callControllerProvider = Provider(
  (ref) {
    final CallRepository callRepository = ref.read(callRepositoryProvider);
    return CallController(
      firebaseAuth: FirebaseAuth.instance,
      callRepository: callRepository,
      ref: ref,
    );
  },
);

class CallController {
  final FirebaseAuth firebaseAuth;
  final CallRepository callRepository;
  final ProviderRef ref;

  CallController({
    required this.firebaseAuth,
    required this.callRepository,
    required this.ref,
  });

  //Make A Call

  void makeACall(
    BuildContext context,
    String receiverUserName,
    String receiverUserId,
    String receiverProfilePic,
    bool isGroupChat,
  ) {
    ref.read(userDataAuthProvider).whenData((value) {
      String callId = const Uuid().v1();

      //Sender Call Data

      CallModel senderCallData = CallModel(
        callerId: firebaseAuth.currentUser!.uid,
        callerName: value!.name,
        callerPic: value.profilePic,
        receiverId: receiverUserId,
        receiverName: receiverUserName,
        receiverPic: receiverProfilePic,
        callId: callId,
        hasDialled: true,
      );

      //Receiver Call Data

      CallModel receiverCallData = CallModel(
        callerId: firebaseAuth.currentUser!.uid,
        callerName: value.name,
        callerPic: value.profilePic,
        receiverId: receiverUserId,
        receiverName: receiverUserName,
        receiverPic: receiverProfilePic,
        callId: callId,
        hasDialled: false,
      );

      callRepository.makeACall(senderCallData, context, receiverCallData);
    });
  }
}
