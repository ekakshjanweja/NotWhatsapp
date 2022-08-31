import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:not_whatsapp/common/widgets/error_screen.dart';
import 'package:not_whatsapp/features/authentication/screens/login_screen.dart';
import 'package:not_whatsapp/features/authentication/screens/otp_screen.dart';
import 'package:not_whatsapp/features/authentication/screens/user_info_screen.dart';

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
      final verificationId = settings.arguments as String;
      return MaterialPageRoute(
        builder: (context) => const UserInfoScreen(),
      );

    default:
      return MaterialPageRoute(
        builder: (context) => const Scaffold(
          body: ErrorScreen(error: 'This page doesn\'t exist.'),
        ),
      );
  }
}
