// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:not_whatsapp/features/authentication/firebase/auth.dart';

import '../../../models/user_model.dart';

//Provider

final authControllerProvider = Provider(
  (ref) {
    final auth = ref.watch(authProvider);
    return AuthController(auth: auth, ref: ref);
  },
);

final userDataAuthProvider = FutureProvider((ref) {
  final authController = ref.watch(authControllerProvider);
  return authController.getUserData();
});

class AuthController {
  final Auth auth;
  final ProviderRef ref;

  AuthController({
    required this.auth,
    required this.ref,
  });

  //Get User Data

  Future<UserModel?> getUserData() async {
    UserModel? user = await auth.getCurrentUserData();
    return user;
  }

  //Sign In With Phone

  void signInWithPhone(BuildContext context, String phoneNumber) {
    auth.signInWithPhone(context, phoneNumber);
  }

  //Verify OTP

  void verifyOTP(
    BuildContext context,
    String userOTP,
    String verificationId,
  ) {
    auth.verifyOTP(
      context: context,
      verificationId: verificationId,
      userOTP: userOTP,
    );
  }

  // Save User Data To Firebase

  void saveUserDataToFirebase(
    BuildContext context,
    String name,
    File? profilePic,
  ) {
    auth.saveUserDataToFirebase(
      name: name,
      profilePic: profilePic,
      providerRef: ref,
      context: context,
    );
  }

  //Used Data

  Stream<UserModel> userDataById(String uid) {
    return auth.userData(uid);
  }
}
