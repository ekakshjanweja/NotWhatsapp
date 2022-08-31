import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:not_whatsapp/constants/colors.dart';
import 'package:not_whatsapp/features/landing/screens/landing_screen.dart';
import 'package:not_whatsapp/firebase_options.dart';
import 'package:not_whatsapp/router.dart';
import 'package:not_whatsapp/screens/mobile_screen.dart';
import 'package:not_whatsapp/screens/web_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'NotWhatsapp',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: backgroundColor,
        colorScheme: ThemeData().colorScheme.copyWith(
              primary: tabColor,
              secondary: tabColor,
            ),
        appBarTheme: const AppBarTheme(
          color: appBarColor,
          elevation: 0,
        ),
      ),
      // home: const ScreenType(
      //   mobile: MobileScreen(),
      //   web: WebScreen(),
      // ),
      home: const LandingScreen(),
      onGenerateRoute: (settings) => generateRoute(settings),
    );
  }
}
