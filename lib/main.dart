import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:not_whatsapp/constants/colors.dart';
import 'package:not_whatsapp/features/authentication/controller/auth_controller.dart';
import 'package:not_whatsapp/features/landing/screens/landing_screen.dart';
import 'package:not_whatsapp/firebase_options.dart';
import 'package:not_whatsapp/router.dart';
import 'package:not_whatsapp/screens/mobile_screen.dart';
import 'common/widgets/error_screen.dart';
import 'common/widgets/loader.dart';

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

class MyApp extends ConsumerWidget {
  @override
  Widget build(
    BuildContext context,
    WidgetRef ref,
  ) {
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
      home: ref.watch(userDataAuthProvider).when(
            data: (user) {
              if (user == null) {
                return const LandingScreen();
              } else {
                return const MobileScreen();
              }
            },
            error: (error, stackTrace) => ErrorScreen(
              error: error.toString(),
            ),
            loading: () => const Loader(),
          ),
      onGenerateRoute: (settings) => generateRoute(settings),
    );
  }
}
