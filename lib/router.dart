import 'dart:io';

import 'package:flutter/material.dart';
import 'package:not_whatsapp/common/widgets/error_screen.dart';
import 'package:not_whatsapp/features/authentication/screens/login_screen.dart';
import 'package:not_whatsapp/features/authentication/screens/otp_screen.dart';
import 'package:not_whatsapp/features/authentication/screens/user_info_screen.dart';
import 'package:not_whatsapp/features/group/screens/create_group_screen.dart';
import 'package:not_whatsapp/features/select_contacts/screens/select_contacts_screen.dart';
import 'package:not_whatsapp/features/chat/screens/mobile_chat_screen.dart';
import 'package:not_whatsapp/features/status/screens/confirm_status_screen.dart';
import 'package:not_whatsapp/features/status/screens/status_screen.dart';
import 'package:not_whatsapp/models/status_model.dart';

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
    case ConfirmStatusScreen.routeName:
      final file = settings.arguments as File;
      return MaterialPageRoute(
        builder: (context) => ConfirmStatusScreen(
          file: file,
        ),
      );
    case MobileChatScreen.routeName:
      final arguments = settings.arguments as Map<String, dynamic>;
      final name = arguments['name'];
      final uid = arguments['uid'];
      final isGroupChat = arguments['isGroupChat'];
      final displayImage = arguments['displayImage'];
      return MaterialPageRoute(
        builder: (context) => MobileChatScreen(
          name: name,
          uid: uid,
          isGroupChat: isGroupChat,
          displayImage: displayImage,
        ),
      );

    case StatusScreen.routeName:
      final status = settings.arguments as StatusModel;
      return MaterialPageRoute(
        builder: (context) => StatusScreen(
          status: status,
        ),
      );

    case CreateGroupScreen.routeName:
      return MaterialPageRoute(
        builder: (context) => const CreateGroupScreen(),
      );

    default:
      return MaterialPageRoute(
        builder: (context) => const Scaffold(
          body: ErrorScreen(error: 'This page doesn\'t exist.'),
        ),
      );
  }
}
