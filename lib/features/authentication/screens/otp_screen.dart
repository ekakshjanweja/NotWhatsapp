import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:not_whatsapp/constants/colors.dart';
import 'package:not_whatsapp/constants/font_styles.dart';
import 'package:not_whatsapp/features/authentication/controller/auth_controller.dart';
import 'package:not_whatsapp/features/authentication/firebase/auth.dart';

class OtpScreen extends ConsumerWidget {
  static const String routeName = '/otp-screen';
  final String verificationId;
  const OtpScreen({
    Key? key,
    required this.verificationId,
  }) : super(key: key);

  void verifyOTP(
    WidgetRef ref,
    BuildContext context,
    String userOTP,
  ) {
    ref.read(authControllerProvider).verifyOTP(
          context,
          userOTP,
          verificationId,
        );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: backgroundColor,
        title: Text(
          'Verify your phone number',
          style: FontStyle.h2(context),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(
              vertical: MediaQuery.of(context).size.height * 0.01,
              horizontal: MediaQuery.of(context).size.width * 0.2,
            ),
            child: TextField(
              textAlign: TextAlign.center,
              textAlignVertical: TextAlignVertical.bottom,
              decoration: InputDecoration(
                hintText: '__  __  __  __  __  __',
                hintStyle: FontStyle.h2(context).copyWith(
                  color: textColor.withOpacity(0.5),
                ),
              ),
              keyboardType: TextInputType.number,
              onChanged: (val) {
                if (val.length == 6) {
                  verifyOTP(
                    ref,
                    context,
                    val.trim(),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
