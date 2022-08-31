import 'package:flutter/material.dart';
import 'package:not_whatsapp/common/widgets/custom_button.dart';
import 'package:not_whatsapp/constants/colors.dart';
import 'package:not_whatsapp/constants/font_styles.dart';
import 'package:not_whatsapp/features/authentication/screens/login_screen.dart';

class LandingScreen extends StatelessWidget {
  const LandingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: EdgeInsets.symmetric(
            vertical: MediaQuery.of(context).size.height * 0.05,
            horizontal: MediaQuery.of(context).size.width * 0.05,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(
                'Welcome to NotWhatsapp',
                style: FontStyle.h1Bold(context)
                    .copyWith(fontWeight: FontWeight.w500),
              ),
              Image.asset(
                'assets/bg.png',
                color: tabColor,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  //TnC
                  Text(
                    textAlign: TextAlign.center,
                    'Read our Privacy Policy. Tap "Agree and Continue" to accept the terms of service.',
                    style: FontStyle.bodyText(context),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.05,
                  ),

                  //Button

                  CustomButton(
                    buttonText: 'AGREE AND CONTINUE',
                    buttonColor: tabColor,
                    onTap: () {
                      Navigator.pushNamed(context, LoginScreen.routeName);
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
