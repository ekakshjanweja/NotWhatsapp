// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:not_whatsapp/features/authentication/firebase/auth.dart';

//Provider

final authControllerProvider = Provider(
  (ref) {
    final auth = ref.watch(authProvider);
    return AuthController(auth: auth);
  },
);

class AuthController {
  final Auth auth;

  AuthController({
    required this.auth,
  });

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
}
