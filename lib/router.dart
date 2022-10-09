import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:not_whatsapp/common/widgets/error_screen.dart';
import 'package:not_whatsapp/features/authentication/screens/login_screen.dart';
import 'package:not_whatsapp/features/authentication/screens/otp_screen.dart';
import 'package:not_whatsapp/features/authentication/screens/user_info_screen.dart';
import 'package:not_whatsapp/features/select_contacts/firebase/select_contact_repository.dart';
import 'package:not_whatsapp/features/select_contacts/screens/select_contacts_screen.dart';
import 'package:not_whatsapp/screens/mobile_chat_screen.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case LoginScreen.routeName:
      return MaterialPageRoute(
        builder: (context) => const LoginScreen(),
      );
    case OtpScreen.routeName:
      final verificationId = settings.arguments as String;
      return MaterialPageRoute(
        builder: (context) => OtpScreen(
          verificationId: verificationId,
        ),
      );

    case UserInfoScreen.routeName:
      return MaterialPageRoute(
        builder: (context) => const UserInfoScreen(),
      );
    case SelectContactsScreen.routeName:
      return MaterialPageRoute(
        builder: (context) => const SelectContactsScreen(),
      );
    case MobileChatScreen.routeName:
      final arguments = settings.arguments as Map<String, dynamic>;
      final name = arguments['name'];
      final uid = arguments['uid'];
      return MaterialPageRoute(
        builder: (context) => MobileChatScreen(
          name: name,
          uid: uid,
        ),
      );

    default:
      return MaterialPageRoute(
        builder: (context) => const Scaffold(
          body: ErrorScreen(error: 'This page doesn\'t exist.'),
        ),
      );
  }
}
