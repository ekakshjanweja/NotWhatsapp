import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:not_whatsapp/common/firebase/common_firebase_storage_repository.dart';
import 'package:not_whatsapp/common/utils/utils.dart';
import 'package:not_whatsapp/features/authentication/screens/otp_screen.dart';
import 'package:not_whatsapp/features/authentication/screens/user_info_screen.dart';
import 'package:not_whatsapp/models/user_model.dart';
import 'package:not_whatsapp/screens/mobile_screen.dart';

//Provider

final authProvider = Provider(
  (ref) => Auth(
    firebaseAuth: FirebaseAuth.instance,
    firebaseFirestore: FirebaseFirestore.instance,
  ),
);

class Auth {
  final FirebaseAuth firebaseAuth;
  final FirebaseFirestore firebaseFirestore;

  Auth({
    required this.firebaseAuth,
    required this.firebaseFirestore,
  });

  //Get Current User Data

  Future<UserModel?> getCurrentUserData() async {
    var userData = await firebaseFirestore
        .collection('users')
        .doc(
          firebaseAuth.currentUser?.uid,
        )
        .get();

    UserModel? user;

    if (userData.data() != null) {
      user = UserModel.fromMap(
        userData.data()!,
      );
    }

    return user;
  }

  //Sign In With Phone

  void signInWithPhone(BuildContext context, String phoneNumber) async {
    try {
      await firebaseAuth.verifyPhoneNumber(
        verificationCompleted: (PhoneAuthCredential credential) async {
          await firebaseAuth.signInWithCredential(credential);
        },
        verificationFailed: (e) {
          throw Exception(e.message);
        },
        codeSent: ((String verificationId, int? resendToken) async {
          Navigator.pushNamed(
            context,
            OtpScreen.routeName,
            arguments: verificationId,
          );
        }),
        codeAutoRetrievalTimeout: (String verificationId) async {},
        phoneNumber: phoneNumber,
      );
    } on FirebaseAuthException catch (e) {
      showSnackBar(
        context: context,
        content: e.message!,
      );
    }
  }

  //Verify OTP

  void verifyOTP({
    required BuildContext context,
    required String verificationId,
    required String userOTP,
  }) async {
    NavigatorState state = Navigator.of(context);
    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: userOTP,
      );
      await firebaseAuth.signInWithCredential(credential);

      //Check what this error is //something know as mounted has to be used to implement good code

      state.pushNamedAndRemoveUntil(
        UserInfoScreen.routeName,
        (route) => false,
      );
    } on FirebaseAuthException catch (e) {
      showSnackBar(
        context: context,
        content: e.message!,
      );
    }
  }

//Save User Data To Firebase

  void saveUserDataToFirebase({
    required String name,
    required File? profilePic,
    required ProviderRef providerRef,
    required BuildContext context,
  }) async {
    NavigatorState state = Navigator.of(context);

    try {
      String uid = firebaseAuth.currentUser!.uid;
      String photoUrl =
          'https://images.unsplash.com/photo-1661765697580-be9f8e39bc06?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=435&q=80';

      if (profilePic != null) {
        photoUrl = await providerRef
            .read(commonFirebaseStorageRepositoryProvider)
            .storeFileToFirebase('profilePic/$uid', profilePic);
      }

      var user = UserModel(
        name: name,
        uid: uid,
        profilePic: photoUrl,
        phoneNumber: firebaseAuth.currentUser!.phoneNumber.toString(),
        isOnline: true,
        groupId: [],
      );

      await firebaseFirestore.collection('users').doc(uid).set(user.toMap());

      state.pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (context) => const MobileScreen(),
        ),
        (route) => false,
      );
    } catch (e) {
      showSnackBar(
        context: context,
        content: e.toString(),
      );
    }
  }
}
